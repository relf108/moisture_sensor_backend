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
      try {
        'tail -f /dev/ttyACM$portNum'.start();
      } on Exception catch (_) {
        tail
      }
      return Response.ok({'key': 'value'});
    });
  }
}
