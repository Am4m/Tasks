class Task {
  static int _idCounter = 0;
  final int id;
  final String title;
  Priority priority;
  Status status;

  Task(this.title, this.priority, this.status) : id = _idCounter++;
}

enum Priority {
  low(0xFF00FF00, "Low", 0xe097),
  medium(0xFFFFA500, "Medium", 0xe09b),
  high(0xFFFF0000, "High", 0xe0a0);

  final int colorValue;
  final String text;
  final int codePoint;

  const Priority(this.colorValue, this.text, this.codePoint);
}

enum Status {
  todo("Todo", 0xefae),
  inProgress("In Progress", 0xf44a),
  done("Done", 0xef48);

  final String text;
  final int codePoint;

  const Status(this.text, this.codePoint);
}
