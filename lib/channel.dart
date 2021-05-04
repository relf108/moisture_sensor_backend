import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:moisture_sensor/db_commands.dart';

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
      var portNum = 0;
      var lines = <String>[];
      lines = await serialToList(portNum);
      //Ensure serial has been read correctly as reading through serial
      //communication can be extrememly inconsistent
      while (!lines[0].startsWith('#') || lines[0].length < 4) {
        lines = await serialToList(portNum);
      }
      var currentVal = lines[lines.length - 1];
      //Anolog to percentage conversion maths from https://www.instructables.com/Plant-Moisture-Sensor-W-Arduino/
      var currentPercent = 2.718282 *
          2.718282 *
          (.008985 * int.parse(currentVal.replaceAll('#', '')) + 0.207762)
              .roundToDouble();
      //Push val to mysql table
      DBCommands.insert(currentPercent.toInt());
      return Response.ok({'MoisturePercent': currentPercent});
    });

    router.route('/history').linkFunction((request) async {
      List resp = await DBCommands.getRows();
      return Response.ok(resp.toString());
    });

    return router;
  }

  Future<List<String>> serialToList(int portNum) async {
    //Open device file to moniter serial output
    var ardDeviceFile = File('/dev/ttyACM$portNum');
    var ardSerial = ardDeviceFile.openRead();
    //Send request to arduino to give us a value
    await ardDeviceFile.writeAsString('i');
    //Decode and return value
    var lines = await ardSerial.transform(utf8.decoder).toList();
    return lines;
  }
}
