import 'package:flutter/material.dart';

import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../notifications/presentation/pages/home_page.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.authController,
    required this.notificationController,
  });

  final AuthController authController;
  final NotificationController notificationController;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'anwar@example.com');
  final _password = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.authController.login(
      email: _email.text,
      password: _password.text,
    );
    if (!mounted || !success) return;

    await Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => HomePage(
        authController: widget.authController,
        notificationController: widget.notificationController,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clean Architecture Demo')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: AnimatedBuilder(
                animation: widget.authController,
                builder: (context, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Login', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) => value != null && value.contains('@')
                          ? null
                          : 'Enter a valid email',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) => (value?.length ?? 0) >= 6
                          ? null
                          : 'Password must contain at least 6 characters',
                    ),
                    if (widget.authController.errorMessage case final message?) ...[
                      const SizedBox(height: 12),
                      Text(message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: widget.authController.isLoading ? null : _submit,
                      child: widget.authController.isLoading
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign in'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
