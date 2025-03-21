# Shelf SwaggerUI
Present, clean and professional documentation with Swagger + shelf;
![alt text](https://raw.githubusercontent.com/Flutterando/shelf_swagger_ui/main/example.png)


## Example

Get a YAML or JSON schema file. Ex: (specs/swagger.yaml)
```yaml
openapi: 3.0.0
info:
  description: "API system"
  version: "1.0.10"
  title: "Swagger Test"
servers:
  - url: http://my-service.info
    description: Remote server
tags:
- name: "user"
  description: "Access to User"

```

Configure the handler with Shelf:


```dart
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

void main(List<String> args) async {
  final path = 'specs/swagger.yaml';
  final handler = SwaggerUI.fromFile(File(path), title: 'Swagger Test');
  var server = await io.serve(handler, '0.0.0.0', 4001);
  print('Serving at http://${server.address.host}:${server.port}');
}
```

That`s it!