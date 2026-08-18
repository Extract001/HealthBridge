import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class AuthService {
  static Future<List<UserModel>> _loadUsers() async {
    final String response = await rootBundle.loadString('assets/data/users.json');
    final List<dynamic> data = json.decode(response);
    return data.map((jsonItem) => UserModel.fromJson(jsonItem)).toList();
  }

  static Future<UserModel?> login(String username, String password) async {
    final users = await _loadUsers();
    final cleanUsername = username.trim().toLowerCase();
    final cleanPassword = password.trim();

    for (var user in users) {
      if (user.username.toLowerCase() == cleanUsername && user.password == cleanPassword) {
        return user;
      }
    }
    return null;
  }
}
