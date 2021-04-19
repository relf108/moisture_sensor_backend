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
      await ardDeviceFile.writeAsString('request');
      //Open the serial port
      var ardSerial = ardDeviceFile.openRead();
      //Write all 
      var logFile = File('log.txt');
      var log = logFile.openWrite();
      ardSerial.listen(log.add);
      await Future.delayed(Duration(seconds: 1));
      var lines = await logFile.readAsLines();
      var currentVal = lines.last;
      //Anolog to percentage conversion maths from https://www.instructables.com/Plant-Moisture-Sensor-W-Arduino/
      var currentPercent = 2.718282 *
          2.718282 *
          (.008985 * int.parse(currentVal) + 0.207762).roundToDouble();
      return Response.ok({'MoisturePercent': currentPercent});
    });
    return router;
  }
}
