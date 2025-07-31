import 'dart:convert';

typedef ResponseParser<T> = T Function(dynamic data);

T decodeAndParse<T>(dynamic data, ResponseParser<T> parser) {
  final dynamic jsonData = (data is String) ? jsonDecode(data) : data;
  return parser(jsonData);
}
