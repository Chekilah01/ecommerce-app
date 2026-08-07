import 'package:equatable/equatable.dart';
import 'package:final_project/features/auth/domain/entities/gender.dart';
import 'package:final_project/features/auth/domain/entities/user_entity.dart';

class UserModel extends Equatable {
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

  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.wilaya,
    required this.commune,
    required this.gender,
    required this.imageUrl,
    required this.role,
  });

  factory UserModel.fromFirestore({required Map<String, dynamic> data, required String uid}) {
    return UserModel(
      uid: uid,
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      phone: data['phone'],
      wilaya: data['wilaya'],
      commune: data['commune'],
      gender: Gender.values.firstWhere((g) => g.name == data['gender']),
      imageUrl: data['imageUrl'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'wilaya': wilaya,
      'commune': commune,
      'gender': gender.name,
      'imageUrl': imageUrl,
      'role': role,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      wilaya: wilaya,
      commune: commune,
      gender: gender,
      imageUrl: imageUrl,
      role: role,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      wilaya: entity.wilaya,
      commune: entity.commune,
      gender: entity.gender,
      imageUrl: entity.imageUrl,
      role: entity.role,
    );
  }

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
