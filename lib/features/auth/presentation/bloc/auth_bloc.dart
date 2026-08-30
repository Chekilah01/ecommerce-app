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
    on<UpdateProfileImageEvent>(_onUpdateProfileImage);
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

  String _firebaseAuthError(FirebaseAuthException e) { // tbh I tried to be specific here as much as I could 
  switch (e.code) {
    case 'email-already-in-use':
      return 'This email is already registered.';

    case 'weak-password':
      return 'The password is too weak.';

    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'Invalid email or password.';

    case 'invalid-email':
      return 'Invalid email address.';

    case 'user-disabled':
      return 'This account has been disabled.';

    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';

    case 'operation-not-allowed':
      return 'This sign-in method is not enabled.';

    case 'network-request-failed':
      return 'Network error. Please check your internet connection.';

    default:
      return e.message ?? 'An unexpected error occurred. Please try again.';
  }
}

  Future<void> _onUpdateProfileImage(
  UpdateProfileImageEvent event,
  Emitter<AuthState> emit,
) async {
  final currentState = state;

  if (currentState is! Authenticated) {
    return;
  }

  emit(const AuthLoading());

  try {
    final updatedUser = await _repository.updateProfileImage(
      user: currentState.user,
      image: event.image,
    );

    emit(Authenticated(updatedUser));
  } on FirebaseAuthException catch (e) {
    emit(AuthError(_firebaseAuthError(e)));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

}
