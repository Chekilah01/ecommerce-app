import 'package:equatable/equatable.dart';
import 'package:final_project/features/auth/domain/entities/gender.dart';
import 'package:image_picker/image_picker.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String wilaya;
  final String commune;
  final Gender gender;

  const RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.wilaya,
    required this.commune,
    required this.gender,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    phone,
    wilaya,
    commune,
    gender,
  ];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class UpdateProfileImageEvent extends AuthEvent {
  final XFile image;

  const UpdateProfileImageEvent(this.image);

  @override
  List<Object?> get props => [image];
}