// ignore_for_file: unnecessary_this, unnecessary_new, file_names

import 'package:flutter/material.dart';
import 'package:ingetin/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {

  bool isAuthenticated = false;
  late String token;
  late ApiService apiService;

  AuthProvider() {
    init();
  }

  Future<void> init() async {
    this.token = await getToken();
    if (this.token.isNotEmpty) {
      this.isAuthenticated = true;
    }
    this.apiService = new ApiService(this.token);
    notifyListeners();
  }

  Future<void> register(String name, String email, String password,
      String passwordConfirm) async {
    this.token = await apiService.register(name, email, password, passwordConfirm);
    setToken(this.token);
    this.isAuthenticated = true;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {    
    this.token = await apiService.login(email, password);
    setToken(this.token);
    this.isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logOut() async {
    setToken('');
    this.isAuthenticated = false;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}