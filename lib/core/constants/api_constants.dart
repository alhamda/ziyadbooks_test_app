class ApiConstants {
  static const String baseUrl = 'https://openlibrary.org';
  static const String searchPath = '/search.json';
  static const int defaultLimit = 20;
  static const String childrenSubject = 'children';

  static String coverUrl(int coverId, {String size = 'M'}) {
    return 'https://covers.openlibrary.org/b/id/$coverId-$size.jpg';
  }
}
