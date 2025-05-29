class Tr {
  final Map<String, String> translations;

  Tr({required this.translations});

  factory Tr.fromMap(Map<String, dynamic> json) {
    final translations = Map<String, String>.from(json);
    return Tr(translations: translations);
  }

  Map<String, dynamic> toMap() => translations;

  String? getTranslation(String languageCode) {
    return translations[languageCode];
  }

  @override
  String toString() {
    // Prints translations in a clearer format
    return 'Translations: ${translations['en'] ?? ""} (EN), ${translations['de'] ?? ""} (DE), ${translations['ar'] ?? ""} (AR)';
  }
}
