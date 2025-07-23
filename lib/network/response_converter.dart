import 'dart:convert';

typedef ResponseParser<T> = T Function(dynamic json);

T defaultJsonParser<T>(dynamic data, ResponseParser<T> parser) {
  final dynamic jsonData;
  if (data is String) {
    jsonData = jsonDecode(data);
  } else {
    jsonData = data;
  }
  return parser(jsonData);
}
