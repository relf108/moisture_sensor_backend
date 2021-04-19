import 'dart:io';
import 'dart:typed_data';
import 'package:conduit/conduit.dart';
import 'package:libserialport/libserialport.dart';

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
    final name = SerialPort.availablePorts.first;
final port = SerialPort(name);
if (!port.openReadWrite()) {
  print(SerialPort.lastError);
  exit(-1);
}

port.write(/* ... */);

final reader = SerialPortReader(port);
reader.stream.listen((data) {
  print('received: $data');
});


      // var portNum = 0;
      // var arduOutput = File('/dev/ttyACM$portNum');
      // var lines = await arduOutput.readAsLines();
      // var currentVal = lines.last;
      // //Anolog to percentage conversion maths from https://www.instructables.com/Plant-Moisture-Sensor-W-Arduino/
      // var currentPercent = 2.718282 *
      //     2.718282 *
      //     (.008985 * int.parse(currentVal) + 0.207762).roundToDouble();

      return Response.ok({'MoisturePercent': 'currentPercent'});
    });
    return router;
  }
}
