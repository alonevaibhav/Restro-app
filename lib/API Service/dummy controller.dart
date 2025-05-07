import 'dart:io';
import 'package:get/get.dart';
import 'api_service.dart';
import 'endpoints.dart';

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

class DummyControllerForAPIService extends GetxController {
  final users = <User>[].obs;
  final currentUser = Rxn<User>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  /// Handles login and stores token/uid
  Future<void> login(String email, String password) async {
    isLoading(true);
    errorMessage.value = null;

    final response = await ApiService.post<Map<String, dynamic>>(
      endpoint: AuthEndpoints.login,
      body: {'email': email, 'password': password},
      fromJson: (json) => json,
      includeToken: false, // 👈 token will NOT be sent
    );

    if (response.success && response.data != null) {
      final token = response.data!['token'];
      final user = response.data!['user'];

      if (token != null && user != null) {
        await ApiService.setToken(token);
        await ApiService.setUid(user['id'].toString());
        currentUser.value = User.fromJson(user);
      } else {
        errorMessage.value = 'Invalid login response.';
      }
    } else {
      errorMessage.value = response.errorMessage ?? 'Login failed.';
    }

    isLoading(false);
  }

  /// Fetch profile by ID (GET request)
  Future<void> fetchProfileById(String userId) async {
    isLoading(true);
    errorMessage.value = null;

    final response = await ApiService.get<User>(
      endpoint: '${AuthEndpoints.fetchProfile}/$userId',
      fromJson: (json) => User.fromJson(json),
    );

    if (response.success && response.data != null) {
      currentUser.value = response.data!;
    } else {
      errorMessage.value = response.errorMessage;
    }

    isLoading(false);
  }

  /// Update user name and email (PUT request)
  Future<void> updateProfile({required String name, required String email}) async {
    if (currentUser.value == null) {
      errorMessage.value = 'No user logged in';
      return;
    }

    isLoading(true);
    errorMessage.value = null;

    final response = await ApiService.put<User>(
      endpoint: AuthEndpoints.update,
      body: {
        'id': currentUser.value!.id,
        'name': name,
        'email': email,
      },
      fromJson: (json) => User.fromJson(json),
    );

    if (response.success && response.data != null) {
      currentUser.value = response.data!;
    } else {
      errorMessage.value = response.errorMessage;
    }

    isLoading(false);
  }

  /// Delete user account (DELETE request)
  Future<void> deleteUserAccount() async {
    if (currentUser.value == null) {
      errorMessage.value = 'No user logged in';
      return;
    }

    isLoading(true);
    errorMessage.value = null;

    final response = await ApiService.delete<void>(
      endpoint: '${AuthEndpoints.register}/${currentUser.value!.id}',
      fromJson: (json) => null,
    );

    if (response.success) {
      currentUser.value = null;
      await ApiService.clearAuthData();
    } else {
      errorMessage.value = response.errorMessage;
    }

    isLoading(false);
  }

  /// Upload avatar using multipart request (Multipart POST request)
  Future<void> uploadAvatar(File avatarFile) async {
    if (currentUser.value == null) {
      errorMessage.value = 'No user logged in';
      return;
    }

    isLoading(true);
    errorMessage.value = null;

    final fields = {'userId': currentUser.value!.id};
    final file = MultipartFiles(field: 'avatar', filePath: avatarFile.path);

    final response = await ApiService.multipartPost<User>(
      endpoint: AuthEndpoints.login,
      fields: fields,
      files: [file],
      fromJson: (json) => User.fromJson(json),
    );

    if (response.success && response.data != null) {
      currentUser.value = response.data!;
    } else {
      errorMessage.value = response.errorMessage;
    }

    isLoading(false);
  }
}
