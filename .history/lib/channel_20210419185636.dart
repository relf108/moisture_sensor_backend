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

      //Open the serial port
      var ardSerial = ardDeviceFile.openRead();
      //Write all data written to serial port to log.txt
      var logFile = File('log.txt');
      var log = logFile.openWrite();
      ardSerial.listen(log.add);
      //Make the request to the arduino
      await ardDeviceFile.writeAsString('begin request');
      //get the most recent value out of the log
      var lines = await logFile.readAsLines();
      var currentVal = lines.last;
      //close the request to the arduino

      //Anolog to percentage conversion maths from https://www.instructables.com/Plant-Moisture-Sensor-W-Arduino/
      var currentPercent = 2.718282 *
          2.718282 *
          (.008985 * int.parse(currentVal) + 0.207762).roundToDouble();
      //await ardDeviceFile.writeAsString('end request');
      return Response.ok({'MoisturePercent': currentPercent});
    });
    return router;
  }
}
