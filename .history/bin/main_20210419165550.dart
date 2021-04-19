// import 'package:conduit/conduit.dart';
// import 'package:moisture_sensor/channel.dart';
// import 'package:moisture_sensor/moisture_sensor.dart';

// Future main() async {

//   final app = Application<MoistureSensorBackend>()
//     ..options.configurationFilePath = 'config.yaml'
//     ..options.port = 8888;

//   final count = Platform.numberOfProcessors ~/ 2;
//   await app.start(numberOfInstances: count > 0 ? count : 1);

//   print('Application started on port: ${app.options.port}.');
//   print('Use Ctrl-C (SIGINT) to stop running the application.');
// }
import 'package:libserialport/libserialport.dart';

main(){
      var port = SerialPort('ttyACM0');
      port.write(Uint8List(1));
      port.read(256);
}