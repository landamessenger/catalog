extension StringExt on String {
  String capitalize() {
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();
    return '${substring(0, 1).toUpperCase()}${substring(1, length)}';
  }

  String addFinalSlash() {
    if (endsWith('/')) {
      return this;
    }
    return '$this/';
  }

  String addCurrentFolderDot() {
    if (startsWith('./')) {
      return this;
    }
    return './$this';
  }
}
