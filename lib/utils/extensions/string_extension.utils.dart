extension StringExtension on String {
  String capitalizeText() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get truncateZero {
    if (this.isEmpty) return this;
    if (this[0] == '0') {
      return substring(1).toLowerCase();
    } else {
      return this;
    }
  }

  bool get isVideoUrl {
    return toLowerCase().contains('.mp4') ||
        toLowerCase().contains('.mov') ||
        toLowerCase().contains('.avi') ||
        toLowerCase().contains('.mvc');
  }
}
