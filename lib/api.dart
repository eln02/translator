import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> fetchTranslation(String text, bool language) async {
  if (text == ''){
    return '';
  }
  String? apiKey = dotenv.env['API_KEY'];
  String? folderId = dotenv.env['FOLDER_ID'];
  List<String> texts = [text];

  Map<String, dynamic> body = {
    "targetLanguageCode": language ? 'en' : 'ru',
    "texts": texts,
    "folderId": folderId,
  };

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Api-Key $apiKey"
  };

  final response = await http.post(
    Uri.parse(
        'https://translate.api.cloud.yandex.net/translate/v2/translate'),
    headers: headers,
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    String responseBody = utf8.decode(response.bodyBytes);
    Map<String, dynamic> decodedJson = jsonDecode(responseBody);
    return decodedJson['translations'][0]['text'].toString();
  } else {
    return 'Oшибка: ${response.statusCode}';
  }
}