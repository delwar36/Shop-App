class EnglishToBangla {
  static String englishToBanglaNumberFont(String englishNumberFont) {
    final banglaFont = englishNumberFont
        .replaceAll('0', '০')
        .replaceAll('1', '১')
        .replaceAll('2', '২')
        .replaceAll('3', '৩')
        .replaceAll('4', '৪')
        .replaceAll('5', '৫')
        .replaceAll('6', '৬')
        .replaceAll('7', '৭')
        .replaceAll('8', '৮')
        .replaceAll('9', '৯');
    return banglaFont;
  }
}
