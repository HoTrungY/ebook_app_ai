import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  // Keys for SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  // Login user
  Future<bool> login(String username, String password) async {
    try {
      // In a real app, this would be an API call to authenticate
      // For demo: accept any non-empty username/password
      if (username.isEmpty || password.isEmpty) {
        return false;
      }

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Store login state and mock token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_tokenKey, 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString(_userIdKey, 'user_123');
      
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Register user
  Future<bool> register(String username, String email, String password) async {
    try {
      // In a real app, this would be an API call to register
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        return false;
      }

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1200));
      
      // Just return success for demo
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_tokenKey);
      await prefs.remove(_userIdKey);
      
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (!isLoggedIn) {
        return null;
      }
      
      // In a real app, this might fetch the user profile from an API
      // Here we just return mock data
      return User(
        id: 'user_123',
        username: 'reader123',
        name: 'Nguyễn Văn A',
        email: 'reader@example.com',
        avatar: 'assets/images/avatar.png'
      );
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Request password reset
  Future<bool> requestPasswordReset(String email) async {
    try {
      if (email.isEmpty) {
        return false;
      }

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Return success for demo
      return true;
    } catch (e) {
      print('Password reset request error: $e');
      return false;
    }
  }
}