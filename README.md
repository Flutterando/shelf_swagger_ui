# Shelf SwaggerUI
Present clean and professional documentation with Swagger + shelf;

## Example

Get a YAML or JSON schema file. Ex: (swagger.yaml)
```yaml
swagger: "2.0"
info:
  description: "This is a sample server Petstore server.  You can find out more about     Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net, #swagger](http://swagger.io/irc/).      For this sample, you can use the api key `special-key` to test the authorization     filters."
  version: "1.0.0"
  title: "Swagger Ship YAML"
  termsOfService: "http://swagger.io/terms/"
  contact:
    email: "apiteam@swagger.io"
  license:
    name: "Apache 2.0"
    url: "http://www.apache.org/licenses/LICENSE-2.0.html"
host: "petstore.swagger.io"
basePath: "/v2"
```

Configure the handler with Shelf:


```dart
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

void main(List<String> args) async {
  final path = 'swagger.yaml';
  final handler = SwaggerUI(path, title: 'Swagger Test');
  var server = await io.serve(handler, '0.0.0.0', 4001);
  print('Serving at http://${server.address.host}:${server.port}');
}
```

That`s it!