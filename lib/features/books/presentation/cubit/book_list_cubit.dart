import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziyadbooks_test/core/error/failures.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';
import 'package:ziyadbooks_test/features/books/domain/repositories/book_repository.dart';
import 'package:ziyadbooks_test/features/books/presentation/cubit/book_list_state.dart';

class BookListCubit extends Cubit<BookListState> {
  BookListCubit({required BookRepository repository})
      : _repository = repository,
        super(const BookListInitial());

  final BookRepository _repository;

  Future<void> loadBooks() => searchBooks('');

  Future<void> searchBooks(String query) async {
    final trimmedQuery = query.trim();
    final previousBooks = _currentBooks;

    emit(BookListLoading(previousBooks: previousBooks));

    try {
      final books = await _repository.searchChildrenBooks(
        titleQuery: trimmedQuery.isEmpty ? null : trimmedQuery,
      );
      emit(BookListLoaded(books: books, searchQuery: trimmedQuery));
    } on Failure catch (failure) {
      emit(
        BookListError(
          message: failure.message,
          previousBooks: previousBooks,
          searchQuery: trimmedQuery,
        ),
      );
    }
  }

  List<Book> get _currentBooks {
    final currentState = state;
    return switch (currentState) {
      BookListLoaded(:final books) => books,
      BookListLoading(:final previousBooks) => previousBooks,
      BookListError(:final previousBooks) => previousBooks,
      _ => const [],
    };
  }
}
