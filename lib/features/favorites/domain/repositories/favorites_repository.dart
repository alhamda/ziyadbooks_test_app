import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';

abstract class FavoritesRepository {
  Future<List<Book>> getFavorites();

  Future<void> toggleFavorite(Book book);

  Future<bool> isFavorite(String bookId);
}
