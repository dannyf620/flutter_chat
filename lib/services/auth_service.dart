import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_chat_latest/global/environment.dart';
import 'package:flutter_chat_latest/models/login_response.dart';
import 'package:flutter_chat_latest/models/usuario.dart';
import 'package:flutter_chat_latest/helpers/mostrar_alerta.dart';

class AuthService with ChangeNotifier {
  late Usuario _usuario;

  Usuario get usuario => _usuario;

  set usuario(Usuario usuario) {
    _usuario = usuario;
  }

  bool _autenticando = false;

  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;

  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  // Getter del token de forma statica

  static Future<String?> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');

    return token;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;
    final data = {'email': email, 'password': password};
    final url = Uri.http(Environment.apiUrl, '${Environment.apiPath}/login');

    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      _guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    autenticando = true;
    final data = {'nombre': name, 'email': email, 'password': password};
    final url =
        Uri.http(Environment.apiUrl, '${Environment.apiPath}/login/new');

    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      usuario = loginResponse.usuario;
      _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      final firstError = respBody['errors'].keys.first;
      return respBody['errors'][firstError]['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');


    if (token == null || token == '') {
      return false;
    }

    final url =
        Uri.http(Environment.apiUrl, '${Environment.apiPath}/login/renew');
    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      _guardarToken(loginResponse.token);

      return true;
    } else {
      logout();

      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
