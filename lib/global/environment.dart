import 'dart:io';

class Environment {
  static String apiPath = '/api';
  static String apiUrl = Platform.isAndroid? '192.168.0.7:3000' : 'localhost:3000';
}