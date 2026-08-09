import 'package:flutter/foundation.dart';

import '../../domain/entities/notification_request.dart';
import '../../domain/usecases/send_notification.dart';

class NotificationController extends ChangeNotifier {
  NotificationController(this._sendNotification);
  final SendNotification _sendNotification;

  bool isLoading = false;
  String? message;

  Future<void> send({
    required String channel,
    required String recipient,
    required String text,
  }) async {
    isLoading = true;
    message = null;
    notifyListeners();

    final result = await _sendNotification(NotificationRequest(
      channel: channel,
      recipient: recipient,
      message: text,
    ));

    result.fold(
      onFailure: (failure) => message = failure.message,
      onSuccess: (notification) =>
          message = '${notification.channel}: ${notification.status} (${notification.id})',
    );

    isLoading = false;
    notifyListeners();
  }
}
