import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  User? _currentUser;
  String _errorMessage = '';
  bool _isLoggedIn = false;

  // Getters
  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  // Constructor - check login status when created
  AuthViewModel() {
    checkLoginStatus();
  }

  // Check if user is logged in
  Future<void> checkLoginStatus() async {
    _setLoading(true);
    try {
      _isLoggedIn = await _authService.isLoggedIn();
      if (_isLoggedIn) {
        _currentUser = await _authService.getCurrentUser();
      }
    } catch (e) {
      _errorMessage = 'Không thể kiểm tra trạng thái đăng nhập: $e';
      _isLoggedIn = false;
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _errorMessage = '';
    
    try {
      final success = await _authService.login(username, password);
      
      if (success) {
        _isLoggedIn = true;
        _currentUser = await _authService.getCurrentUser();
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Đăng nhập không thành công. Vui lòng kiểm tra thông tin đăng nhập.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Lỗi đăng nhập: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    _errorMessage = '';
    
    try {
      final success = await _authService.register(username, email, password);
      
      if (success) {
        return true;
      } else {
        _errorMessage = 'Đăng ký không thành công. Vui lòng thử lại.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Lỗi đăng ký: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<bool> logout() async {
    _setLoading(true);
    _errorMessage = '';
    
    try {
      final success = await _authService.logout();
      
      if (success) {
        _isLoggedIn = false;
        _currentUser = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Đăng xuất không thành công.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Lỗi đăng xuất: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Request password reset
  Future<bool> requestPasswordReset(String email) async {
    _setLoading(true);
    _errorMessage = '';
    
    try {
      final success = await _authService.requestPasswordReset(email);
      
      if (success) {
        return true;
      } else {
        _errorMessage = 'Không thể gửi yêu cầu đặt lại mật khẩu.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Lỗi yêu cầu đặt lại mật khẩu: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}