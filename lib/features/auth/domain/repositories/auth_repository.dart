import 'package:firebase_auth/firebase_auth.dart';

import 'package:final_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:final_project/features/auth/domain/entities/gender.dart';
import 'package:final_project/features/auth/domain/entities/user_entity.dart';
import 'package:image_picker/image_picker.dart';

class AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepository({AuthRemoteDatasource? remoteDatasource})
    : _authRemoteDatasource = remoteDatasource ?? AuthRemoteDatasource();

  User? get currentUser => _authRemoteDatasource.currentUser;

  Stream<User?> get authStateChanges => _authRemoteDatasource.authStateChanges;

  Future<UserEntity> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String wilaya,
    required String commune,
    required Gender gender,
  }) async {
    final user = await _authRemoteDatasource.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
      wilaya: wilaya,
      commune: commune,
      gender: gender,
    );

    return user.toEntity();
  }

  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final user = await _authRemoteDatasource.login(
      email: email,
      password: password,
    );
    return user.toEntity();
  }

  Future<UserEntity?> getCurrentUser() async {
    final user = await _authRemoteDatasource.getCurrentUser();

    return user?.toEntity();
  }

  Future<void> logout() async {
    await _authRemoteDatasource.logout();
  }

  Future<void> resetPassword(String email) async {
    await _authRemoteDatasource.resetPassword(email);
  }

  Future<UserEntity> updateProfileImage({
    required UserEntity user,
    required XFile image,
  }) async {
    final updatedUser = await _authRemoteDatasource.updateProfileImage(
      user: user,
      image: image,
    );

    return updatedUser.toEntity();
  }
}
