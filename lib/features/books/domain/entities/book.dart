import 'package:equatable/equatable.dart';
import 'package:ziyadbooks_test/core/constants/api_constants.dart';

class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.publishYear,
    this.coverId,
    this.subjects = const [],
    this.description,
    this.publishers = const [],
    this.editionCount,
    this.languages = const [],
    this.firstSentence,
  });

  final String id;
  final String title;
  final List<String> authors;
  final int? publishYear;
  final int? coverId;
  final List<String> subjects;
  final String? description;
  final List<String> publishers;
  final int? editionCount;
  final List<String> languages;
  final String? firstSentence;

  String? get coverUrl =>
      coverId != null ? ApiConstants.coverUrl(coverId!) : null;

  String get authorsLabel =>
      authors.isEmpty ? 'Penulis tidak diketahui' : authors.join(', ');

  String get publishYearLabel =>
      publishYear != null ? publishYear.toString() : '-';

  Book copyWith({
    String? id,
    String? title,
    List<String>? authors,
    int? publishYear,
    int? coverId,
    List<String>? subjects,
    String? description,
    List<String>? publishers,
    int? editionCount,
    List<String>? languages,
    String? firstSentence,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      publishYear: publishYear ?? this.publishYear,
      coverId: coverId ?? this.coverId,
      subjects: subjects ?? this.subjects,
      description: description ?? this.description,
      publishers: publishers ?? this.publishers,
      editionCount: editionCount ?? this.editionCount,
      languages: languages ?? this.languages,
      firstSentence: firstSentence ?? this.firstSentence,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        authors,
        publishYear,
        coverId,
        subjects,
        description,
        publishers,
        editionCount,
        languages,
        firstSentence,
      ];
}
