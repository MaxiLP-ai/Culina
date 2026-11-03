import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile.dart';

class AuthService {
  static const String _kUserKey = 'culina_current_user_v1';
  static const String _kLoggedInKey = 'culina_is_logged_in_v1';

  final UserProfile _defaultUser = UserProfile(
    id: 'user-matias',
    name: 'Matias Tapia',
    email: 'matias.tapia@culina.app',
    username: 'matias',
    memberSince: 'Marzo 2026',
    bio:
        'Chef y cocinero aficionado. Amante de la cocina casera, recetas artesanales e ingredientes frescos.',
    culinaryTags: ['Cocina casera', 'Pastas frescas', 'Ingredientes naturales'],
    favoriteCategory: 'Pastas',
  );

  Future<UserProfile> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString(_kUserKey);
    if (rawUser != null && rawUser.isNotEmpty) {
      try {
        final Map<String, dynamic> map = jsonDecode(rawUser);
        return UserProfile.fromMap(map);
      } catch (_) {
        return _defaultUser;
      }
    }
    return _defaultUser;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedInKey) ?? true; // default true for immediate demo experience, can toggle
  }

  Future<UserProfile> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedInKey, true);

    var user = await getCurrentUser();
    if (email.isNotEmpty && email != user.email) {
      user = user.copyWith(
        email: email,
        name: email.contains('@') ? email.split('@')[0].capitalize() : user.name,
      );
      await saveUser(user);
    }
    return user;
  }

  Future<UserProfile> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final newUser = UserProfile(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim().isEmpty ? 'Matias Tapia' : name.trim(),
      email: email.trim().isEmpty ? 'matias.tapia@culina.app' : email.trim(),
      username: email.contains('@') ? email.split('@')[0].toLowerCase() : 'matias',
      memberSince: 'Marzo 2026',
      bio: 'Cocinero aficionado. Amante de la cocina casera y recetas artesanales.',
      culinaryTags: ['Cocina casera', 'Ingredientes naturales'],
      favoriteCategory: 'Pastas',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedInKey, true);
    await saveUser(newUser);
    return newUser;
  }

  Future<void> saveUser(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserKey, jsonEncode(user.toMap()));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedInKey, false);
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

