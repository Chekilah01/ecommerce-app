import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/auth/data/models/user_model.dart';
import 'package:final_project/features/auth/domain/entities/gender.dart';
import 'package:final_project/features/auth/domain/entities/user_entity.dart';
import 'package:final_project/features/product/data/datasources/cloudinary_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AuthRemoteDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> _usersRef = FirebaseFirestore
      .instance
      .collection("users");
  //here i know that this import is architecturally not ideal because the Auth feature is now importing a data source from the Product feature but I did that to not change the architechture jst for one thing (which is the profile picture)
  final CloudinaryDataSource _cloudinaryDataSource = CloudinaryDataSource();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String wilaya,
    required String commune,
    required Gender gender,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    final user = UserModel(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      wilaya: wilaya,
      commune: commune,
      gender: gender,
      imageUrl: null,
      imagePublicId: null,
      role: 'customer',
    );

    await _usersRef.doc(uid).set(user.toFirestore());

    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = userCredential.user!.uid;
    final snapshot = await _usersRef.doc(uid).get();

    return UserModel.fromFirestore(data: snapshot.data()!, uid: uid);
  }

  Future<UserModel?> getCurrentUser() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    final snapshot = await _usersRef.doc(currentUser.uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return UserModel.fromFirestore(
      data: snapshot.data()!,
      uid: currentUser.uid,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserModel> updateProfileImage({
    required UserEntity user,
    required XFile image,
  }) async {
    final uploadResult = await _cloudinaryDataSource.uploadImage(image);

    try {
      await _usersRef.doc(user.uid).update({
        'imageUrl': uploadResult.url,
        'imagePublicId': uploadResult.publicId,
      });

      if (user.imagePublicId != null && user.imagePublicId!.isNotEmpty) {
        try {
          await _cloudinaryDataSource.deleteImage(user.imagePublicId!);
        } catch (_) {}
      }

      return UserModel(
        uid: user.uid,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        phone: user.phone,
        wilaya: user.wilaya,
        commune: user.commune,
        gender: user.gender,
        imageUrl: uploadResult.url,
        imagePublicId: uploadResult.publicId,
        role: user.role,
      );
    } catch (e) {
      try {
        await _cloudinaryDataSource.deleteImage(uploadResult.publicId);
      } catch (_) {}

      rethrow;
    }
  }

  Future<UserModel> updateProfile({
    required UserEntity user,
    required String firstName,
    required String lastName,
    required String phone,
    required String wilaya,
    required String commune,
    required Gender gender,
  }) async {
    await _usersRef
        .doc(user.uid)
        .update({
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'wilaya': wilaya,
          'commune': commune,
          'gender': gender.name,
        })
        .timeout(const Duration(seconds: 10));

    return UserModel(
      uid: user.uid,
      firstName: firstName,
      lastName: lastName,
      email: user.email,
      phone: phone,
      wilaya: wilaya,
      commune: commune,
      gender: gender,
      imageUrl: user.imageUrl,
      imagePublicId: user.imagePublicId,
      role: user.role,
    );
  }
}
