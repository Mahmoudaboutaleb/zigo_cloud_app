// ignore_for_file: avoid_print, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigo_cloud_app/firebase_options.dart';
import 'package:zigo_cloud_app/models/user_models.dart';

class FirebaseService {
  static final _auth = FirebaseAuth.instance;
  static final _store = FirebaseFirestore.instance;
  static const String EMAIL = "email";
  static const String PASSWORD = "password";

  static UserModel? _currentUser;
  static UserModel? get currentUser => _currentUser;

  static Future<void> setupFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> get buildViews =>
      _store.collection('zigoAppUsers').snapshots();

  static Future<bool> signUp({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final UserModel user = UserModel(
        uid: cred.user!.uid,
        email: email,
        name: name,
        username: username,
        latitude: 0.0,
        longitude: 0.0,
        lastUpdated: DateTime.now(),
      );

      if (cred.user != null) {
        final docRef = _store.collection('zigoAppUsers').doc(cred.user!.uid);
        final doc = await docRef.get();
        if (doc.exists) {
          print('User document already exists');
          return false;
        }

        await docRef.set(user.toJson());
        print('User document created successfully');
        _currentUser = user;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error during sign up: $e');
      return false;
    }
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null) {
        final doc =
            await _store.collection('zigoAppUsers').doc(cred.user!.uid).get();
        final data = doc.data();
        if (data != null) {
          _currentUser = UserModel.fromJson(data);
          SharedPreferences ref = await SharedPreferences.getInstance();
          ref.setString(EMAIL, email);
          ref.setString(PASSWORD, password);

          print(
              'Current User after login: ${_currentUser?.toJson()}'); // أضف هذا السطر
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error during login: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;

    // إزالة بيانات تسجيل الدخول من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }
}
