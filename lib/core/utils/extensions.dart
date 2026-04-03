extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}

extension DoubleExtensions on double {
  double clampToRange(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  String toPercentageString() {
    return '${(this * 100).toInt()}%';
  }
}

extension IntExtensions on int {
  String toCommaSeparated() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
