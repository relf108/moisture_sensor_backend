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
      var arduOutput = File('/dev/ttyACM$portNum');
      var lines = await arduOutput.readAsLines();
      var currentVal = lines.firstWhere((element) => element.indexOf() == );
      //Anolog to percentage conversion maths from https://www.instructables.com/Plant-Moisture-Sensor-W-Arduino/
      var currentPercent =
          2.718282 * 2.718282 * (.008985 * int.parse(currentVal) + 0.207762);

      return Response.ok({'MoisturePercent': currentPercent});
    });
    return router;
  }
}
