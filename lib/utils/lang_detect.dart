class SimpleLangDetect {
  // Extended language hints with more common words, scripts, and Unicode checks
  static final Map<String, List<String>> langHints = {
    'en': ['the', 'and', 'is', 'are', 'of', 'to', 'for', 'with', 'that', 'this', 'from', 'by', 'was', 'as', 'at', 'have', 'it'],
    'fr': ['le', 'la', 'et', 'est', 'pour', 'les', 'des', 'un', 'une', 'du', 'en', 'dans', 'ce', 'par', 'sur', 'au', 'avec'],
    'es': ['el', 'la', 'es', 'para', 'los', 'una', 'un', 'por', 'con', 'del', 'las', 'sus', 'como', 'pero', 'más'],
    'de': ['der', 'die', 'und', 'ist', 'zu', 'das', 'ein', 'eine', 'mit', 'auf', 'von', 'den', 'dem', 'nicht'],
    'it': ['il', 'la', 'e', 'è', 'per', 'un', 'una', 'che', 'di', 'del', 'con', 'le', 'dei'],
    'ru': ['и', 'в', 'не', 'на', 'что', 'я', 'с', 'он', 'как', 'это', 'по', 'из', 'у', 'к', 'за', 'от', 'до'],
    'zh': ['的', '一', '是', '在', '不', '了', '有', '和', '人', '这', '中', '大', '为', '上', '个', '国'],
    'ar': ['و', 'في', 'من', 'على', 'مع', 'عن', 'أن', 'هذا', 'كان', 'إلى', 'ما', 'كل', 'لا', 'فيها'],
    'ja': ['の', 'に', 'は', 'を', 'た', 'が', 'です', 'ます', 'で', 'から', 'こと', 'もの', 'ない', 'でも'],
    'bn': ['এই', 'আমি', 'তুমি', 'সে', 'কিছু', 'করে', 'একটি', 'এবং', 'হয়', 'ছিল', 'সে', 'তারা', 'আমরা', 'তুমি'],
    'hi': ['है', 'और', 'से', 'के', 'को', 'पर', 'मैं', 'आप', 'नहीं', 'था', 'था', 'वे', 'यह', 'जो', 'क्या'],
  };

  // Unicode script blocks for quick script-based detection
  static final Map<String, RegExp> scriptBlocks = {
    'zh': RegExp(r'[\u4e00-\u9fff]'), // CJK Unified Ideographs
    'ja': RegExp(r'[\u3040-\u309f\u30a0-\u30ff]'), // Hiragana, Katakana
    'ar': RegExp(r'[\u0600-\u06FF]'), // Arabic
    'bn': RegExp(r'[\u0980-\u09FF]'), // Bengali
    'hi': RegExp(r'[\u0900-\u097F]'), // Devanagari
    'ru': RegExp(r'[\u0400-\u04FF]'), // Cyrillic
  };

  /// Enhanced language detection using hints, script blocks, and scoring
  static String detect(String text) {
    text = text.toLowerCase();

    // 1. Script block detection (for unique scripts)
    for (var entry in scriptBlocks.entries) {
      if (entry.value.hasMatch(text)) {
        return entry.key;
      }
    }

    // 2. Word scoring
    int maxCount = 0;
    String detected = 'en';
    langHints.forEach((lang, words) {
      int count = 0;
      for (final w in words) {
        // Use word boundaries for more accurate matching
        final regex = RegExp(r'\b' + RegExp.escape(w) + r'\b', caseSensitive: false);
        if (regex.hasMatch(text)) count++;
      }
      if (count > maxCount) {
        maxCount = count;
        detected = lang;
      }
    });

    // 3. Additional heuristics for tie-breaking or short text
    // If no strong match, try script heuristics (Latin, etc.)
    if (maxCount == 0) {
      if (RegExp(r'[а-яА-ЯёЁ]').hasMatch(text)) return 'ru';
      if (RegExp(r'[àâçéèêëîïôûùüÿœæ]').hasMatch(text)) return 'fr';
      if (RegExp(r'[áéíóúñü¡¿]').hasMatch(text)) return 'es';
      if (RegExp(r'[äöüß]').hasMatch(text)) return 'de';
      if (RegExp(r'[àèéìíîòóùú]').hasMatch(text)) return 'it';
      if (RegExp(r'[অ-ঔক-হ]').hasMatch(text)) return 'bn';
      if (RegExp(r'[हिन्दी]').hasMatch(text)) return 'hi';
      if (RegExp(r'[ぁ-んァ-ン]').hasMatch(text)) return 'ja';
      if (RegExp(r'[ء-ي]').hasMatch(text)) return 'ar';
    }

    return detected;
  }
}
