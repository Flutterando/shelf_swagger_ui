import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

void main(List<String> args) async {
  final path = args.isNotEmpty ? args[0] : 'specs/swagger.yaml';
  final swaggerHandler = SwaggerUI(path, title: 'Swagger Test');

  var server = await io.serve(swaggerHandler, '0.0.0.0', 4002);
  print('Serving at http://${server.address.host}:${server.port}');
}
