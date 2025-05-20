/// Present, clean and professional documentation with Swagger + shelf;
library shelf_swagger_ui;

import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

/// Controls the default expansion setting for the operations and tags.
enum DocExpansion {
  /// expands only the tags
  list,

  /// expands the tags and operations
  full,

  /// expands nothing
  none,
}

/// Highlight.js syntax coloring theme to use. (Only these 6 styles are available).
enum SyntaxHighlightTheme {
  agate('agate'),
  arta('arta'),
  monokai('monokai'),
  nord('nord'),
  obsidian('obsidian'),
  tomorrowNight('tomorrow-night');

  final String theme;
  const SyntaxHighlightTheme(this.theme);
}

/// Type of schema (YAML/JSON).
enum SpecType {
  yaml,
  json,
}

///This class starts all the default attributes to start swagger-ui.
///In addition to receiving the Spec (YAML/JSON)
///it is also possible to configure the title and enable "deepLink".
/// <br /><br />
///[fileSchemaPath]: Schema path (YAML/JSON). <br />
///[title]: Defines the title that is visible in the browser tab. <br />
///[docExpansion]: (Default DocExpansion.list), Controls the default expansion setting for the operations and tags. It can be 'list' (expands only the tags), 'full' (expands the tags and operations) or 'none' (expands nothing). <br />
///[deepLink]: (Default true) enables the use of deep-links to reference each node in the url (ex: /swagger/#/post). <br />
///[syntaxHighlightTheme]: (Default SyntaxHighlightTheme.agate) Highlight.js syntax coloring theme to use. (Only these 6 styles are available). <br />
///[persistAuthorization]: (Default false) If set to true, it persists authorization data and it would not be lost on browser close/refresh. <br />
/// <br /><br />
/// Example:
///```dart
///final swaggerHandler = SwaggerUI.fromFile(
///  File('swagger/swagger.yaml'),
///  title: 'Swagger API',
///  deepLink: true,
///);
///
///var server = await io.serve(swaggerHandler, '0.0.0.0', 4000);
///```

class SwaggerUI {
  ///Schema text (YAML/JSON).
  final String schemaText;

  ///Defines the title that is visible in the browser tab.
  final String title;

  /// Controls the default expansion setting for the operations and tags.
  final DocExpansion docExpansion;

  ///(Default false) enables the use of deep-links to reference each node in the url (ex: /swagger/#/post).
  final bool deepLink;

  /// Highlight.js syntax coloring theme to use. (Only these 6 styles are available).
  final SyntaxHighlightTheme syntaxHighlightTheme;

  /// If set to true, it persists authorization data and it would not be lost on browser close/refresh
  final bool persistAuthorization;

  ///Type Schema (YAML/JSON).
  final SpecType specType;

  SwaggerUI(
    this.schemaText, {
    this.specType = SpecType.json,
    this.title = 'API Swagger',
    this.docExpansion = DocExpansion.list,
    this.syntaxHighlightTheme = SyntaxHighlightTheme.agate,
    this.deepLink = false,
    this.persistAuthorization = false,
  });

  static SwaggerUI fromFile(
    File fileSchema, {
    String title = 'API Swagger',
    DocExpansion docExpansion = DocExpansion.list,
    SyntaxHighlightTheme syntaxHighlightTheme = SyntaxHighlightTheme.agate,
    bool deepLink = false,
    bool persistAuthorization = false,
  }) {
    return SwaggerUI(
      fileSchema.readAsStringSync(),
      title: title,
      specType:
          fileSchema.path.endsWith('.yaml') ? SpecType.yaml : SpecType.json,
      docExpansion: docExpansion,
      syntaxHighlightTheme: syntaxHighlightTheme,
      deepLink: deepLink,
      persistAuthorization: persistAuthorization,
    );
  }

  FutureOr<Response> call(Request request) {
    var spec = '';
    if (specType == SpecType.yaml) {
      spec = "const spec = jsyaml.load(`$schemaText`);";
    } else {
      spec = "const spec = $schemaText;";
    }
    return Response.ok(headers: {
      HttpHeaders.contentTypeHeader:
          ContentType('text', 'html', charset: 'utf-8').toString(),
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
<script src="https://cdn.jsdelivr.net/npm/js-yaml@4.1.0/dist/js-yaml.min.js"></script>
<script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-bundle.js" crossorigin></script>

<script>
  window.onload = () => {
  $spec
    window.ui = SwaggerUIBundle({
      dom_id: '#swagger-ui',
      docExpansion: '${docExpansion.name}',
      deepLinking: $deepLink,
      spec: spec,
      syntaxHighlight: {
        activate: true,
        theme: '${syntaxHighlightTheme.theme}',
      },
      persistAuthorization: $persistAuthorization,
    });
  };
</script>
</body>
</html>
''');
  }
}
