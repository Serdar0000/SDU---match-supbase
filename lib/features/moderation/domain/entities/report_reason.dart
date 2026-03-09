/// Причины для жалоб
abstract class ReportReason {
  static const String spam = 'spam';
  static const String harassment = 'harassment';
  static const String fakeProfile = 'fake_profile';
  static const String explicitContent = 'explicit_content';
  static const String underage = 'underage';
  static const String other = 'other';

  static const List<String> all = [
    spam,
    harassment,
    fakeProfile,
    explicitContent,
    underage,
    other,
  ];

  /// Получить корзину локализации для причины
  static String getLocalizationKey(String reason) {
    switch (reason) {
      case spam:
        return 'spam';
      case harassment:
        return 'inappropriate';
      case fakeProfile:
        return 'fakeProfile';
      case explicitContent:
        return 'explicitContent';
      case underage:
        return 'underage';
      default:
        return 'otherReason';
    }
  }
}
