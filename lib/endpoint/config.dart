import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';

class CloudStorageConfig {
  static const _credentialsPath =
      'key/exalted-breaker-425319-j4-020f229308be.json';

  static Future<AutoRefreshingAuthClient> getClient() async {
    var credentialsFile = File(_credentialsPath);
    var jsonCredentials = jsonDecode(await credentialsFile.readAsString());
    var credentials = ServiceAccountCredentials.fromJson(jsonCredentials);
    var scopes = ['https://www.googleapis.com/auth/devstorage.full_control'];
    return clientViaServiceAccount(credentials, scopes);
  }
}
