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
    router.route("/").linkFunction((request) async {
      try {
        responseCode = request.raw.uri.queryParametersAll.entries
            .firstWhere((entries) => entries.key == 'code')
            .value;
      } on Exception catch (_) {
        ///TODO Display error message "User must accept permissions to login through google".
      }
      accessToken =
          accessToken.split('access_token')[1].split(':')[1].split('\"')[1];
      print(accessToken);
      return Response.ok({"key": "value"});
    });
  }
}
