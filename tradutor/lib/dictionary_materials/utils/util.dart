// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future setLogin(http.Response response, String senha, String usuario) async {
  final prefs = await SharedPreferences.getInstance();
  var accessToken = jsonDecode(response.body)['access_token'];
  await prefs.clear();

  await prefs.setString('token', accessToken.toString());
  await prefs.setString('user', usuario.toString().toLowerCase());
  await prefs.setString('senha', senha.toString());
  await prefs.setBool('logado', true);

  return true;
}
