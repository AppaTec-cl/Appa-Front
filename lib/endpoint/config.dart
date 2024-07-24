import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class CloudStorageConfig {
  static const _credentialsUrl =
      'https://storage.googleapis.com/almacenamiento_pdf/exalted-breaker-425319-j4-943ef73cec94.json';

  static Future<AutoRefreshingAuthClient> getClient() async {
    try {
      // Descarga el archivo JSON desde la URL
      final response = await http.get(Uri.parse(_credentialsUrl));

      if (response.statusCode == 200) {
        // Parsea el JSON
        var jsonCredentials = jsonDecode(response.body);
        var credentials = ServiceAccountCredentials.fromJson(jsonCredentials);
        var scopes = [
          'https://www.googleapis.com/auth/devstorage.full_control'
        ];

        return clientViaServiceAccount(credentials, scopes);
      } else {
        throw Exception('Failed to load credentials: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading credentials: $e');
      rethrow;
    }
  }
}
