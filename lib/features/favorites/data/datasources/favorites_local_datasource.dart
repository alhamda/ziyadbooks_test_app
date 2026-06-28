import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziyadbooks_test/core/error/failures.dart';
import 'package:ziyadbooks_test/features/books/data/models/book_model.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';

class FavoritesLocalDataSource {
  FavoritesLocalDataSource(this._prefs);

  static const String favoritesKey = 'favorite_books';

  final SharedPreferences _prefs;

  Future<List<Book>> getFavorites() async {
    try {
      final raw = _prefs.getString(favoritesKey);
      if (raw == null || raw.isEmpty) {
        return [];
      }

      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheFailure();
    }
  }

  Future<void> saveFavorites(List<Book> books) async {
    try {
      final encoded = jsonEncode(
        books.map(_bookToJson).toList(),
      );
      await _prefs.setString(favoritesKey, encoded);
    } catch (_) {
      throw const CacheFailure();
    }
  }

  Future<void> addFavorite(Book book) async {
    final favorites = await getFavorites();
    if (favorites.any((item) => item.id == book.id)) {
      return;
    }
    favorites.add(book);
    await saveFavorites(favorites);
  }

  Future<void> removeFavorite(String bookId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item.id == bookId);
    await saveFavorites(favorites);
  }

  Map<String, dynamic> _bookToJson(Book book) {
    if (book is BookModel) {
      return book.toJson();
    }

    return BookModel(
      id: book.id,
      title: book.title,
      authors: book.authors,
      publishYear: book.publishYear,
      coverId: book.coverId,
      subjects: book.subjects,
      description: book.description,
      publishers: book.publishers,
      editionCount: book.editionCount,
      languages: book.languages,
      firstSentence: book.firstSentence,
    ).toJson();
  }
}
