import 'package:flutter/foundation.dart';
import '../../data/services/auth_service.dart';
import '../../domain/entities/user_profile.dart';

class UserProvider with ChangeNotifier {
  final AuthService authService;

  UserProfile? _user;
  bool _isLoggedIn = true;
  bool _isLoading = false;
  String? _authError;

  UserProvider({required this.authService}) {
    initialize();
  }

  UserProfile? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get authError => _authError;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _user = await authService.getCurrentUser();
    _isLoggedIn = await authService.isLoggedIn();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _authError = null;
    notifyListeners();

    try {
      _user = await authService.login(email, password);
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _authError = 'Error de inicio de sesión: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _authError = null;
    notifyListeners();

    try {
      _user = await authService.register(name, email, password);
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _authError = 'Error al registrar usuario: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> updateBio(String newBio) async {
    if (_user == null) return;
    _user = _user!.copyWith(bio: newBio);
    await authService.saveUser(_user!);
    notifyListeners();
  }

  Future<void> addTag(String tag) async {
    if (_user == null || tag.trim().isEmpty) return;
    if (_user!.culinaryTags.contains(tag.trim())) return;
    final updatedTags = List<String>.from(_user!.culinaryTags)..add(tag.trim());
    _user = _user!.copyWith(culinaryTags: updatedTags);
    await authService.saveUser(_user!);
    notifyListeners();
  }

  Future<void> removeTag(String tag) async {
    if (_user == null) return;
    final updatedTags = List<String>.from(_user!.culinaryTags)..remove(tag);
    _user = _user!.copyWith(culinaryTags: updatedTags);
    await authService.saveUser(_user!);
    notifyListeners();
  }
}

