import 'package:flutter/semantics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferencesHelper? _instance;

  SharedPreferencesHelper._();

  factory SharedPreferencesHelper() =>
      _instance ??= SharedPreferencesHelper._();

  saveData(String key, String value) async {
    final newUserDefault = await SharedPreferences.getInstance();
    newUserDefault.setString(key, value);
  }
  saveIntData(String key, int value) async {
    final newUserDefault = await SharedPreferences.getInstance();
    newUserDefault.setInt(key, value);
  }

  Future<String> readData(String key) async {
    final newUserDefault = await SharedPreferences.getInstance();

    return newUserDefault.getString(key) ?? "";
  }
  Future<int> readIntData(String key) async {
    final newUserDefault = await SharedPreferences.getInstance();
    return newUserDefault.getInt(key) ?? 0;
  }

  // Clear all shared preferences
  Future<void> clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
