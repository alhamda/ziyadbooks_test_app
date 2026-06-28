import 'package:equatable/equatable.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({required this.favorites});

  final List<Book> favorites;

  Set<String> get favoriteIds => favorites.map((book) => book.id).toSet();

  bool isFavorite(String bookId) => favoriteIds.contains(bookId);

  @override
  List<Object?> get props => [favorites];
}

final class FavoritesError extends FavoritesState {
  const FavoritesError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
