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
      var lines = arduOutput.readAsLines();
      line.for (var i = 0; i < count; i++) {
        
      }

      return Response.ok({'key': 'value'});
    });
  }
}
