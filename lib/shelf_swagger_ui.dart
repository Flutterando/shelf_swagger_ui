library shelf_swagger_ui;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:yaml/yaml.dart';

///Swagger supports two types of markup: YAML and JSON.
///There is no advantage in one or the other, but for reading it
///is necessary to announce the extension for the spec conversion.
enum SchemaLang { json, yaml }

///This class starts all the default attributes to start swagger-ui.
///In addition to receiving the Spec (YAML/JSON)
///it is also possible to configure the title and enable "deepLink".
///
///[fileSchemaPath]: Schema path (YAML/JSON).
///[schemaLang]: (Default SchemaLang.yaml), specifies which markup language will be used as the schema.
///[title]: Defines the title that is visible in the browser tab.
///[deepLink]: (Default true) enables the use of deep-links to reference each node in the url (ex: /swagger/#/post).
class SwaggerUI {
  ///Schema path (YAML/JSON).
  final String fileSchemaPath;

  ///(Default SchemaLang.yaml), specifies which markup language will be used as the schema.
  final SchemaLang schemaLang;

  ///Defines the title that is visible in the browser tab.
  final String title;

  ///(Default false) enables the use of deep-links to reference each node in the url (ex: /swagger/#/post).
  final bool deepLink;

  SwaggerUI(
    this.fileSchemaPath, {
    this.title = 'Shelf Swagger',
    this.schemaLang = SchemaLang.yaml,
    this.deepLink = false,
  });

  ///Shelf Handler
  ///```dart
  ///final swaggerHandler = SwaggerUI(
  ///  'swagger/swagger.yaml',
  ///  title: 'Ship API',
  ///  deepLink: true,
  ///);
  ///
  ///var server = await io.serve(swaggerHandler, '0.0.0.0', 4000);
  ///```
  FutureOr<Response> call(Request request) {
    final file = File(fileSchemaPath);
    String json = file.readAsStringSync();
    if (schemaLang == SchemaLang.yaml) {
      final yaml = loadYaml(json);
      json = jsonEncode(yaml);
    }

    return Response.ok(headers: {
      HttpHeaders.contentTypeHeader: ContentType('text', 'html', charset: 'utf-8').toString(),
    }, '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta
    name="description"
    content="SwaggerUI"
  />
  <title>$title</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui.css" />
</head>
<body>
<div id="swagger-ui"></div>
<script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-bundle.js" crossorigin></script>

<script>
  window.onload = () => {
    window.ui = SwaggerUIBundle({
      dom_id: '#swagger-ui',
      deepLinking: $deepLink,
      spec: $json,
    });
  };
</script>
</body>
</html>
''');
  }
}
