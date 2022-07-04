import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

void main(List<String> args) async {
  final path = args.isNotEmpty ? args[0] : 'swagger.yaml';
  final handler = SwaggerUI(path, title: 'Swagger Test');
  var server = await io.serve(handler, '0.0.0.0', 4001);
  print('Serving at http://${server.address.host}:${server.port}');
}
