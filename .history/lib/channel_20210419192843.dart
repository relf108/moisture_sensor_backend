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
      var portNum = 0;
      var ardDeviceFile = File('/dev/ttyACM$portNum');

      //Make the request to the arduino
      await ardDeviceFile.writeAsString('begin request');
      sleep(Duration(seconds: 1));

      //Open the serial port
      var ardSerial = ardDeviceFile.openRead();
      var lines = <String>[];
      //get a value out of the serial port (Second last as it's most likely to be read correctly)
      var gotline = Completer<void>();
      ardSerial
          .transform(utf8.decoder)
          .transform(LineSplitter())
          .listen((line){
        lines.add(line);

        gotline.complete();
      });
      await gotline.future;
      var currentVal = lines[lines.length -1];
      //close the request to the arduino
      await ardDeviceFile.writeAsString('end request');
      //Anolog to percentage conversion maths from https://www.instructables.com/Plant-Moisture-Sensor-W-Arduino/
      var currentPercent = 2.718282 *
          2.718282 *
          (.008985 * int.parse(currentVal) + 0.207762).roundToDouble();
      return Response.ok({'MoisturePercent': currentPercent});
    });
    return router;
  }
}
