class LogicNotification {
  static LogicNotification success() {
    return LogicNotification();
  }

  final List<LogicNotificationItem> _items = [];
  List<LogicNotificationItem> get items => _items;

  static LogicNotification error(String message) {
    LogicNotification notification = LogicNotification();
    notification.add(message);
    return notification;
  }

  add(String message,
      [NotificationSeverity severity = NotificationSeverity.error]) {
    LogicNotificationItem item =
        LogicNotificationItem(message, severity: severity);
    _items.add(item);
  }
}

class LogicNotificationItem {
  final String message;
  NotificationSeverity severity = NotificationSeverity.error;
  String reference;

  LogicNotificationItem(
    this.message, {
    this.reference = "",
    this.severity = NotificationSeverity.error,
  });
}

enum NotificationSeverity { info, warning, error, critical }
