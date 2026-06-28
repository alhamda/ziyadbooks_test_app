import 'package:ziyadbooks_test/core/error/failures.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';
import 'package:ziyadbooks_test/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:ziyadbooks_test/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required FavoritesLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<List<Book>> getFavorites() async {
    try {
      return await _localDataSource.getFavorites();
    } on Failure {
      rethrow;
    } catch (_) {
      throw const CacheFailure();
    }
  }

  @override
  Future<void> toggleFavorite(Book book) async {
    try {
      final favorites = await _localDataSource.getFavorites();
      final exists = favorites.any((item) => item.id == book.id);

      if (exists) {
        await _localDataSource.removeFavorite(book.id);
      } else {
        await _localDataSource.addFavorite(book);
      }
    } on Failure {
      rethrow;
    } catch (_) {
      throw const CacheFailure();
    }
  }

  @override
  Future<bool> isFavorite(String bookId) async {
    final favorites = await getFavorites();
    return favorites.any((book) => book.id == bookId);
  }
}
