import 'dart:io';
import 'package:flutter/foundation.dart';
import 'api_client.dart'; // ApiService with token/uid logic
import 'endpoints.dart'; // Your centralized endpoint definitions

// User model
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

class UserController extends ChangeNotifier {
  List<User> _users = [];
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get users => _users;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Login using email and password
  Future<void> login(String email, String password) async {
    _setLoading(true);

    final response = await ApiService.post<Map<String, dynamic>>(
      endpoint: AuthEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      final data = response.data!;
      final token = data['token'];
      final user = data['user'];

      if (token != null && user != null) {
        await ApiService.setToken(token);
        await ApiService.setUid(user['id'].toString());

        _currentUser = User.fromJson(user);
      } else {
        _errorMessage = 'Invalid login response.';
      }
    } else {
      _errorMessage = response.errorMessage ?? 'Login failed.';
    }

    _setLoading(false);
  }

  /// Fetch current user's profile using UID
  Future<void> fetchProfileById(String userId) async {
    _setLoading(true);

    final response = await ApiService.get<User>(
      endpoint: '${AuthEndpoints.fetchProfile}/$userId',
      fromJson: (json) => User.fromJson(json),
    );

    if (response.success && response.data != null) {
      _currentUser = response.data!;
    } else {
      _errorMessage = response.errorMessage;
    }

    _setLoading(false);
  }

  /// Update user profile (basic)
  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    if (_currentUser == null) {
      _errorMessage = 'No user logged in';
      notifyListeners();
      return;
    }

    _setLoading(true);

    final response = await ApiService.put<User>(
      endpoint: AuthEndpoints.update,
      body: {
        'id': _currentUser!.id,
        'name': name,
        'email': email,
      },
      fromJson: (json) => User.fromJson(json),
    );

    if (response.success && response.data != null) {
      _currentUser = response.data!;
    } else {
      _errorMessage = response.errorMessage;
    }

    _setLoading(false);
  }

  /// Update with complex preferences
  Future<void> updateProfileWithPreferences({
    required String name,
    required String email,
    required List<String> interests,
    Map<String, dynamic>? settings,
  }) async {
    if (_currentUser == null) {
      _errorMessage = 'No current user logged in';
      notifyListeners();
      return;
    }

    _setLoading(true);

    final response = await ApiService.put<User>(
      endpoint: AuthEndpoints.update,
      body: {
        'id': _currentUser!.id,
        'name': name,
        'email': email,
        'interests': interests,
        'settings': settings ?? {'notifications': true},
      },
      fromJson: (json) => User.fromJson(json),
    );

    if (response.success && response.data != null) {
      _currentUser = response.data!;
    } else {
      _errorMessage = response.errorMessage;
    }

    _setLoading(false);
  }

  /// Upload avatar for current user
  Future<void> uploadAvatar(File avatarFile) async {
    if (_currentUser == null) {
      _errorMessage = 'No user logged in';
      notifyListeners();
      return;
    }

    _setLoading(true);

    final fields = {
      'userId': _currentUser!.id,
    };

    final file = MultipartFile(
      field: 'avatar',
      filePath: avatarFile.path,
    );

    final response = await ApiService.multipartPost<User>(
      endpoint: 'architect/upload/avatar', // Adjust as per actual endpoint
      fields: fields,
      files: [file],
      fromJson: (json) => User.fromJson(json),
    );

    if (response.success && response.data != null) {
      _currentUser = response.data!;
    } else {
      _errorMessage = response.errorMessage;
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
