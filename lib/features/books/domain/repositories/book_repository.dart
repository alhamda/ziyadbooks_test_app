import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> searchChildrenBooks({String? titleQuery});

  Future<Book> fetchWorkDetail(Book book);
}
