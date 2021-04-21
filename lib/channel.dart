import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:conduit/conduit.dart';

class MoistureSensorBackend extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();
    router.route('/getMoisture').linkFunction((request) async {
      var portNum = 1;
      var lines = <String>[];
      lines = await serialToList(portNum);
      while (!lines[0].startsWith('#') || lines[0].length < 4) {
        lines = await serialToList(portNum);
      }
      var currentVal = lines[lines.length - 1];
      //Anolog to percentage conversion maths from https://www.instructables.com/Plant-Moisture-Sensor-W-Arduino/
      var currentPercent = 2.718282 *
          2.718282 *
          (.008985 * int.parse(currentVal.replaceAll('#', '')) + 0.207762)
              .roundToDouble();
      return Response.ok({'MoisturePercent': currentPercent});
    });
    return router;
  }

  Future<List<String>> serialToList(int portNum) async {
    var ardDeviceFile = File('/dev/ttyACM$portNum');
    var ardSerial = ardDeviceFile.openRead();
    await ardDeviceFile.writeAsString('i');
    var lines = await ardSerial.transform(utf8.decoder).toList();
    return lines;
  }
}
