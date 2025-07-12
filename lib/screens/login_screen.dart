import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                              _error = null;
                            });
                            try {
                              await auth.signInWithEmail(_emailController.text,
                                  _passwordController.text);
                            } catch (e) {
                              setState(() {
                                _error = e.toString();
                              });
                            } finally {
                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                          child: const Text('Login with Email'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.login),
                          label: const Text('Sign in with Google'),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                              _error = null;
                            });
                            try {
                              await auth.signInWithGoogle();
                            } catch (e) {
                              setState(() {
                                _error = e.toString();
                              });
                            } finally {
                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.facebook),
                          label: const Text('Sign in with Facebook'),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                              _error = null;
                            });
                            try {
                              await auth.signInWithFacebook();
                            } catch (e) {
                              setState(() {
                                _error = e.toString();
                              });
                            } finally {
                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                        ),
                      ],
                    ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('No account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 