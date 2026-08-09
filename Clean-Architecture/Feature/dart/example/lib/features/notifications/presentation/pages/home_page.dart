import 'package:flutter/material.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../controllers/notification_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.authController,
    required this.notificationController,
  });

  final AuthController authController;
  final NotificationController notificationController;

  @override
  Widget build(BuildContext context) {
    final user = authController.session!.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.name}'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              authController.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (_) => LoginPage(
                  authController: authController,
                  notificationController: notificationController,
                ),
              ));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedBuilder(
              animation: notificationController,
              builder: (context, _) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('SOLID Notification Demo',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('The use case depends on a repository contract, not HTTP details.'),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ['email', 'sms', 'push'].map((channel) {
                      return FilledButton.tonal(
                        onPressed: notificationController.isLoading
                            ? null
                            : () => notificationController.send(
                                  channel: channel,
                                  recipient: user.email,
                                  text: 'Hello from the Flutter Clean Architecture example',
                                ),
                        child: Text('Send $channel'),
                      );
                    }).toList(),
                  ),
                  if (notificationController.isLoading) ...[
                    const SizedBox(height: 24),
                    const LinearProgressIndicator(),
                  ],
                  if (notificationController.message case final message?) ...[
                    const SizedBox(height: 24),
                    Card(child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(message),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
