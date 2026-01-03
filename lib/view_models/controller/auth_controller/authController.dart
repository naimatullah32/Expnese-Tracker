import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../view/AuthScreen/LoginView.dart';
import '../../services/auth_services/auth_services.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final supabase = Supabase.instance.client;
  var userName = "".obs;

  /// ---------------- SIGN UP ----------------
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String emailRedirectTo,
  }) async {
    try {
      await _authService.signUpWithEmailPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw "Something went wrong";
    }
  }

  /// ---------------- LOGIN ----------------
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signInWithEmailPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw "User not found";
      }
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw "Invalid email or password";
    }
  }

  /// ---------------- FORGOT PASSWORD ----------------
  Future<void> sendResetEmail(String email) async {
    try {
      await _authService.resetPassword(email);
    } on AuthException catch (e) {
      throw e.message;
    }
  }

  /// ---------------- UPDATE PASSWORD ----------------
  Future<void> updatePassword(String password) async {
    try {
      await _authService.updatePassword(password);
    } on AuthException catch (e) {
      throw e.message;
    }
  }

  /// ---------------- LOGOUT ----------------
  Future<void> logout() async {
    try {
      // 1. Supabase se sign out karein
      await supabase.auth.signOut();

      // 2. Snackbar dikhayein (Optional)
      Get.snackbar(
        "Success",
        "Logged out successfully",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );

      // 3. User ko Login screen par bhej dein aur pichli saari history clear kar dein
      // 'offAllNamed' best hai agar aapne routes set kiye hain
      Get.offAll(() => LoginView());
      // Get.offAllNamed('/login');

    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong while logging out",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  //---- stored register user-----
  User? get currentUser => _authService.currentUser;

}
