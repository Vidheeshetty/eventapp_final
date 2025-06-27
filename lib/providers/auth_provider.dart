import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Dummy users for testing
  final List<UserModel> _dummyUsers = [
    UserModel(
      id: '1',
      email: 'admin@eventapp.com',
      name: 'Admin User',
      isAdmin: true,
    ),
    UserModel(
      id: '2',
      email: 'user@eventapp.com',
      name: 'Regular User',
      isAdmin: false,
    ),
    UserModel(
      id: '3',
      email: 'john@example.com',
      name: 'John Doe',
      isAdmin: false,
    ),
  ];

  bool get isSignedIn => _isSignedIn;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isSignedIn;

  // Check if user is admin
  bool get isAdmin {
    return _currentUser?.isAdmin ?? false;
  }

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Simulate checking stored auth status
      await Future.delayed(const Duration(milliseconds: 500));

      // For demo purposes, user stays logged out initially
      _isSignedIn = false;
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      _isSignedIn = false;
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if user already exists
      bool userExists = _dummyUsers.any((user) => user.email == email);

      if (userExists) {
        _errorMessage = 'An account with this email already exists.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create new user
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        isAdmin: false,
      );

      _dummyUsers.add(newUser);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Sign up failed. Please try again.';
      notifyListeners();
      debugPrint('Sign up error: $e');
      return false;
    }
  }

  Future<bool> confirmSignUp(String email, String confirmationCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // For demo purposes, any 6-digit code works
      if (confirmationCode.length == 6) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid verification code. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Verification failed. Please try again.';
      notifyListeners();
      debugPrint('Confirmation error: $e');
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Find user in dummy data
      UserModel? user;
      try {
        user = _dummyUsers.firstWhere((user) => user.email == email);
      } catch (e) {
        _errorMessage = 'Invalid email or password.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // For demo purposes, any password works for existing users
      _isSignedIn = true;
      _currentUser = user;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Invalid email or password.';
      notifyListeners();
      debugPrint('Sign in error: $e');
      return false;
    }
  }

  // Alternative method name for compatibility
  Future<bool> signInWithEmail(String email, String password) async {
    return await signIn(email, password);
  }

  Future<void> signOut() async {
    try {
      _isSignedIn = false;
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Sign out failed. Please try again.';
      notifyListeners();
      debugPrint('Sign out error: $e');
    }
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if user exists
      bool userExists = _dummyUsers.any((user) => user.email == email);

      if (!userExists) {
        _errorMessage = 'No account found with this email address.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Password reset failed. Please try again.';
      notifyListeners();
      debugPrint('Reset password error: $e');
      return false;
    }
  }

  Future<bool> confirmResetPassword(
      String email,
      String newPassword,
      String confirmationCode,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // For demo purposes, any 6-digit code works
      if (confirmationCode.length == 6) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid verification code. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Password reset confirmation failed. Please try again.';
      notifyListeners();
      debugPrint('Reset password confirmation error: $e');
      return false;
    }
  }

  Future<void> checkAuthStatus() async {
    await _checkAuthStatus();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Additional helper methods
  Future<Map<String, String>?> getUserAttributes() async {
    try {
      if (!_isSignedIn || _currentUser == null) return null;

      // Return dummy attributes
      return {
        'email': _currentUser!.email,
        'name': _currentUser!.name,
        'sub': _currentUser!.id,
      };
    } catch (e) {
      debugPrint('Error fetching user attributes: $e');
      return null;
    }
  }

  Future<bool> updateUserAttribute(String key, String value) async {
    try {
      // Simulate update
      await Future.delayed(const Duration(milliseconds: 500));

      if (_currentUser != null) {
        // Update the current user
        if (key == 'name') {
          _currentUser = _currentUser!.copyWith(name: value);
          notifyListeners();
        }
      }

      return true;
    } catch (e) {
      debugPrint('Error updating user attribute: $e');
      return false;
    }
  }
}