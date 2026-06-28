import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziyadbooks_test/core/error/failures.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';
import 'package:ziyadbooks_test/features/books/domain/repositories/book_repository.dart';
import 'package:ziyadbooks_test/features/books/presentation/cubit/book_detail_state.dart';

class BookDetailCubit extends Cubit<BookDetailState> {
  BookDetailCubit({required BookRepository repository})
      : _repository = repository,
        super(const BookDetailInitial());

  final BookRepository _repository;

  Future<void> loadDetail(Book book) async {
    emit(BookDetailLoading(book: book));

    try {
      final detailedBook = await _repository.fetchWorkDetail(book);
      emit(BookDetailLoaded(book: detailedBook));
    } on Failure catch (failure) {
      emit(BookDetailError(book: book, message: failure.message));
    }
  }
}
