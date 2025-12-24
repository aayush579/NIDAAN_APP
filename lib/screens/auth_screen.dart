import 'package:civic_issue_reporter/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';
  bool _isLogin = true;
  bool _isLoading = false;

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
      error = '';
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      dynamic result;
      if (_isLogin) {
        result = await _auth.signInWithEmailAndPassword(email, password);
      } else {
        result = await _auth.registerWithEmailAndPassword(email, password);
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }


      if (result == null) {
        setState(() {
          error = 'Please supply a valid email and password.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) =>
                val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: Text(_isLogin ? 'Login' : 'Sign Up'),
                onPressed: _submitForm,
              ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              TextButton(
                child: Text(_isLogin ? 'Create an account' : 'I have an account'),
                onPressed: _toggleForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
