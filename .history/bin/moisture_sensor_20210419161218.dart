import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dcli/dcli.dart';

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
      var arduOutput = File('/dev/ttyACM$portNum');
      var lines = await arduOutput.readAsLines();
      var currentVal = lines.last;
      var currentPercent =   //https://www.instructables.com/Plant-Moisture-Sensor-W-Arduino/
  percent = 2.718282 * 2.718282 * (.008985 * moistureVal + 0.207762);

      return Response.ok({'key': 'value'});
    });
  }
}
