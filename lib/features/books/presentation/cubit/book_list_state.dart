import 'package:equatable/equatable.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';

sealed class BookListState extends Equatable {
  const BookListState();

  @override
  List<Object?> get props => [];
}

final class BookListInitial extends BookListState {
  const BookListInitial();
}

final class BookListLoading extends BookListState {
  const BookListLoading({this.previousBooks = const []});

  final List<Book> previousBooks;

  @override
  List<Object?> get props => [previousBooks];
}

final class BookListLoaded extends BookListState {
  const BookListLoaded({
    required this.books,
    this.searchQuery = '',
  });

  final List<Book> books;
  final String searchQuery;

  @override
  List<Object?> get props => [books, searchQuery];
}

final class BookListError extends BookListState {
  const BookListError({
    required this.message,
    this.previousBooks = const [],
    this.searchQuery = '',
  });

  final String message;
  final List<Book> previousBooks;
  final String searchQuery;

  @override
  List<Object?> get props => [message, previousBooks, searchQuery];
}
