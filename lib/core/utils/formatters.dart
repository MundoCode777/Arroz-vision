class Formatters {
  Formatters._();

  /// Ejemplo: 09/11/2026 · 14:32
  static String dateTime(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} · '
        '${two(date.hour)}:${two(date.minute)}';
  }
}
