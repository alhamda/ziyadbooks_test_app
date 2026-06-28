import 'package:ziyadbooks_test/core/error/failures.dart';
import 'package:ziyadbooks_test/features/books/data/datasources/open_library_api.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';
import 'package:ziyadbooks_test/features/books/domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  BookRepositoryImpl({required OpenLibraryApi api}) : _api = api;

  final OpenLibraryApi _api;

  @override
  Future<List<Book>> searchChildrenBooks({String? titleQuery}) async {
    try {
      return await _api.searchChildrenBooks(titleQuery: titleQuery);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<Book> fetchWorkDetail(Book book) async {
    try {
      return await _api.fetchWorkDetail(book);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
