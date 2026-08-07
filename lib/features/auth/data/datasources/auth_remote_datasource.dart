import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/auth/data/models/user_model.dart';
import 'package:final_project/features/auth/domain/entities/gender.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> _usersRef = FirebaseFirestore
      .instance
      .collection("users");

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
}
