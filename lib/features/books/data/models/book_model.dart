import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.authors,
    super.publishYear,
    super.coverId,
    super.subjects,
    super.description,
    super.publishers,
    super.editionCount,
    super.languages,
    super.firstSentence,
  });

  factory BookModel.fromSearchJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['key'] as String? ?? '',
      title: json['title'] as String? ?? 'Judul tidak diketahui',
      authors: (json['author_name'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      publishYear: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
      subjects: (json['subject'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      publishers: (json['publisher'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      editionCount: json['edition_count'] as int?,
      languages: (json['language'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      firstSentence: _extractFirstSentence(json['first_sentence']),
    );
  }

  factory BookModel.fromWorkJson(
    Map<String, dynamic> json, {
    required Book baseBook,
  }) {
    return BookModel(
      id: baseBook.id,
      title: baseBook.title,
      authors: baseBook.authors,
      publishYear: baseBook.publishYear,
      coverId: baseBook.coverId,
      subjects: baseBook.subjects.isNotEmpty
          ? baseBook.subjects
          : (json['subjects'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              const [],
      description: _extractDescription(json['description']),
      publishers: baseBook.publishers,
      editionCount: baseBook.editionCount,
      languages: baseBook.languages,
      firstSentence:
          baseBook.firstSentence ?? _extractFirstSentence(json['first_sentence']),
    );
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      publishYear: json['publishYear'] as int?,
      coverId: json['coverId'] as int?,
      subjects: (json['subjects'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      description: json['description'] as String?,
      publishers: (json['publishers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      editionCount: json['editionCount'] as int?,
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      firstSentence: json['firstSentence'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'publishYear': publishYear,
      'coverId': coverId,
      'subjects': subjects,
      'description': description,
      'publishers': publishers,
      'editionCount': editionCount,
      'languages': languages,
      'firstSentence': firstSentence,
    };
  }

  static String? _extractDescription(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return value['value'] as String? ?? value.entries.first.value?.toString();
    }
    return value.toString();
  }

  static String? _extractFirstSentence(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return value['value'] as String?;
    }
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is String) return first;
      if (first is Map<String, dynamic>) {
        return first['value'] as String?;
      }
    }
    return null;
  }
}
