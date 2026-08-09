class NotificationRequest {
  const NotificationRequest({
    required this.channel,
    required this.recipient,
    required this.message,
  });

  final String channel;
  final String recipient;
  final String message;
}

class SentNotification {
  const SentNotification({required this.id, required this.channel, required this.status});

  final String id;
  final String channel;
  final String status;
}
