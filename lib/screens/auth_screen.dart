import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_notes/providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailCOntroller = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;

  void _submit() async {
    final email = _emailCOntroller.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;
    setState(() => _isLoading = true);
    final auth = ref.read(authProvider.notifier);
    final String? errorMessage;

    if (_isLogin) {
      errorMessage = await auth.signIn(email, password);
    } else {
      errorMessage = await auth.signUp(email, password);
    }
    if (mounted && errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isLogin ? 'Welcome Back ' : 'Create Account',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailCOntroller,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: Text(_isLogin ? 'Login ' : 'Sign Up'),
                  ),
            TextButton(
              onPressed: () {
                setState(() => _isLogin = !_isLogin);
              },
              child: Text(
                _isLogin ? 'Register now' : 'I already have an account ',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
