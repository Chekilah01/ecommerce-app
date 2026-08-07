import 'dart:async';

import 'package:final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({AuthRepository? repository})
    : _repository = repository ?? AuthRepository(),
      super(const AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<ResetPasswordEvent>(_onResetPassword);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      final user = await _repository.register(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        phone: event.phone,
        wilaya: event.wilaya,
        commune: event.commune,
        gender: event.gender,
      );

      emit(Authenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_firebaseAuthError(e)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      final user = await _repository.login(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_firebaseAuthError(e)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _repository.logout();
      emit(const Unauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_firebaseAuthError(e)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.resetPassword(event.email);
      emit(const PasswordResetSent());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_firebaseAuthError(e)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _repository.getCurrentUser();

      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_firebaseAuthError(e)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  String _firebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';

      case 'weak-password':
        return 'The password is too weak.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'invalid-email':
        return 'Invalid email address.';

      default:
        return 'Something went wrong.';
    }
  }
}
