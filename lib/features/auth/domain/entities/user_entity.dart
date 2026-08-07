import 'package:equatable/equatable.dart';

import 'gender.dart';

class UserEntity extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String wilaya;
  final String commune;
  final Gender gender;
  final String? imageUrl;
  final String role;

  const UserEntity({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.wilaya,
    required this.commune,
    required this.gender,
    required this.imageUrl,
    required this.role ,
  });

  @override
  List<Object?> get props => [
    uid,
    firstName,
    lastName,
    email,
    phone,
    wilaya,
    commune,
    gender,
    imageUrl,
    role,
  ];
}
