import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Import for WidgetsFlutterBinding
import 'chat_screen.dart'; // Make sure this import path is correct
import 'signup_screen.dart'; // Make sure this import path is correct

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        throw FirebaseAuthException(code: 'empty-fields', message: 'Please enter both email and password.');
      }

      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to chat screen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'empty-fields') {
         errorMessage = e.message!;
      }
      else {
        errorMessage = e.message ?? 'An error occurred during login.';
      }
      // Handle login errors (e.g., show a SnackBar)
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print(e);
      // Handle other potential errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            _isLoading
                ? CircularProgressIndicator() // Show a loading indicator while logging in
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
            const SizedBox(height: 12.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}