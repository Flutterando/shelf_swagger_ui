import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

void main(List<String> args) async {
  final swaggerHandler = SwaggerUI(
    json,
    title: 'Swagger Test',
    docExpansion: DocExpansion.list,
    syntaxHighlightTheme: SyntaxHighlightTheme.nord,
  );

  var server = await io.serve(swaggerHandler, '0.0.0.0', 4002);
  print('Serving at http://${server.address.host}:${server.port}');
}

final json = r'''
{
  "openapi": "3.0.0",
  "info": {
    "title": "Pet Store API",
    "description": "API para gerenciar pets em uma loja",
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "https://api.petstore.com/v1",
      "description": "Servidor de produção"
    }
  ],
  "paths": {
    "/pets": {
      "get": {
        "summary": "Listar todos os pets",
        "description": "Retorna uma lista de pets disponíveis",
        "parameters": [
          {
            "name": "limit",
            "in": "query",
            "description": "Número máximo de resultados",
            "required": false,
            "schema": {
              "type": "integer",
              "format": "int32"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Lista de pets",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Pet"
                  }
                }
              }
            }
          },
          "500": {
            "description": "Erro interno do servidor"
          }
        }
      },
      "post": {
        "summary": "Adicionar novo pet",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/NewPet"
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Pet criado com sucesso",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Pet"
                }
              }
            }
          },
          "400": {
            "description": "Requisição inválida"
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "Pet": {
        "type": "object",
        "required": [
          "id",
          "name"
        ],
        "properties": {
          "id": {
            "type": "integer",
            "format": "int64"
          },
          "name": {
            "type": "string"
          },
          "tag": {
            "type": "string"
          }
        }
      },
      "NewPet": {
        "type": "object",
        "required": [
          "name"
        ],
        "properties": {
          "name": {
            "type": "string"
          },
          "tag": {
            "type": "string"
          }
        }
      }
    },
    "securitySchemes": {
      "BearerAuth": {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT"
      }
    }
  }
}

''';
