// screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/biometric_service.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isBiometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Center(
                child: Icon(
                  Icons.health_and_safety,
                  size: 80,
                  color: Colors.blue[600],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Health Tracker',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading ? null : _login,
                            child: authProvider.isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Login', style: TextStyle(fontSize: 18)),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    
                    // Biometric Login Option
                    if (_isBiometricAvailable) ...[
                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: _authenticateWithBiometrics,
                          icon: Icon(_getBiometricIcon()),
                          label: Text(
                            'Login with ${BiometricService.getBiometricTypeString(_availableBiometrics)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.teal[600],
                            side: BorderSide(color: Colors.teal[600]!),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.teal[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailController.text,
        _passwordController.text,
      );

      if (success) {
        String route = _getRouteByUserType(authProvider.currentUser!.userType);
        Navigator.pushReplacementNamed(context, route);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please check your credentials.')),
        );
      }
    }
  }

  String _getRouteByUserType(String userType) {
    switch (userType) {
      case 'doctor':
        return '/doctor-dashboard';
      case 'hospital':
        return '/hospital-dashboard';
      case 'caregiver':
        return '/caregiver-dashboard';
      default:
        return '/patient-dashboard';
    }
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final isAvailable = await BiometricService.isAvailable();
      final availableBiometrics = await BiometricService.getAvailableBiometrics();
      
      setState(() {
        _isBiometricAvailable = isAvailable;
        _availableBiometrics = availableBiometrics;
      });
    } catch (e) {
      print('Error checking biometric availability: $e');
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // For demo purposes, we'll check if there's a stored user session
      // In a real app, you'd associate biometric auth with specific user accounts
      await authProvider.checkLoginStatus();
      
      if (authProvider.currentUser != null) {
        final authenticated = await BiometricService.authenticate(
          reason: 'Authenticate to access your health data',
        );
        
        if (authenticated) {
          String route = _getRouteByUserType(authProvider.currentUser!.userType);
          Navigator.pushReplacementNamed(context, route);
        }
      } else {
        // Show dialog to setup biometric authentication
        _showBiometricSetupDialog();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric authentication failed')),
      );
    }
  }

  void _showBiometricSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Setup Biometric Login'),
        content: Text(
          'Please login with your credentials first to enable biometric authentication for future logins.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  IconData _getBiometricIcon() {
    if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    } else if (_availableBiometrics.contains(BiometricType.face)) {
      return Icons.face;
    } else {
      return Icons.security;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
