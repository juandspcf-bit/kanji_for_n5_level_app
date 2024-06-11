import 'dart:convert';

class TranslatedText {
  final String translatedText;

  TranslatedText({
    required this.translatedText,
  });

  TranslatedText copyWith({
    String? translatedText,
  }) {
    return TranslatedText(
      translatedText: translatedText ?? this.translatedText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'translatedText': translatedText,
    };
  }

  factory TranslatedText.fromMap(Map<String, dynamic> map) {
    final translatedText = map["data"]["translations"]["translatedText"];
    return TranslatedText(
      translatedText: translatedText ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TranslatedText.fromJson(String source) =>
      TranslatedText.fromMap(json.decode(source));

  @override
  String toString() => 'TranslatedText(translatedText: $translatedText)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TranslatedText && other.translatedText == translatedText;
  }

  @override
  int get hashCode => translatedText.hashCode;
}
