import 'package:equatable/equatable.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';

sealed class BookDetailState extends Equatable {
  const BookDetailState();

  @override
  List<Object?> get props => [];
}

final class BookDetailInitial extends BookDetailState {
  const BookDetailInitial();
}

final class BookDetailLoading extends BookDetailState {
  const BookDetailLoading({required this.book});

  final Book book;

  @override
  List<Object?> get props => [book];
}

final class BookDetailLoaded extends BookDetailState {
  const BookDetailLoaded({required this.book});

  final Book book;

  @override
  List<Object?> get props => [book];
}

final class BookDetailError extends BookDetailState {
  const BookDetailError({
    required this.book,
    required this.message,
  });

  final Book book;
  final String message;

  @override
  List<Object?> get props => [book, message];
}
