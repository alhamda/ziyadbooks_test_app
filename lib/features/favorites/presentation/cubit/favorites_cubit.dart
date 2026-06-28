import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziyadbooks_test/core/error/failures.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';
import 'package:ziyadbooks_test/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:ziyadbooks_test/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required FavoritesRepository repository})
      : _repository = repository,
        super(const FavoritesInitial());

  final FavoritesRepository _repository;

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());

    try {
      final favorites = await _repository.getFavorites();
      emit(FavoritesLoaded(favorites: favorites));
    } on Failure catch (failure) {
      emit(FavoritesError(message: failure.message));
    }
  }

  Future<void> toggleFavorite(Book book) async {
    final currentState = state;
    if (currentState is! FavoritesLoaded) {
      return;
    }

    final updatedFavorites = List<Book>.from(currentState.favorites);
    final exists = updatedFavorites.any((item) => item.id == book.id);

    if (exists) {
      updatedFavorites.removeWhere((item) => item.id == book.id);
    } else {
      updatedFavorites.add(book);
    }

    emit(FavoritesLoaded(favorites: updatedFavorites));

    try {
      await _repository.toggleFavorite(book);
    } on Failure catch (failure) {
      emit(FavoritesLoaded(favorites: currentState.favorites));
      emit(FavoritesError(message: failure.message));
      emit(FavoritesLoaded(favorites: currentState.favorites));
    }
  }

  bool isFavorite(String bookId) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.isFavorite(bookId);
    }
    return false;
  }
}
