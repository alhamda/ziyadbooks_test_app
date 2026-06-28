import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ziyadbooks_test/core/constants/api_constants.dart';
import 'package:ziyadbooks_test/core/error/failures.dart';
import 'package:ziyadbooks_test/features/books/data/models/book_model.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';

class OpenLibraryApi {
  OpenLibraryApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<BookModel>> searchChildrenBooks({String? titleQuery}) async {
    final queryParameters = <String, String>{
      'subject': ApiConstants.childrenSubject,
      'limit': ApiConstants.defaultLimit.toString(),
    };

    if (titleQuery != null && titleQuery.trim().isNotEmpty) {
      queryParameters['title'] = titleQuery.trim();
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchPath}')
        .replace(queryParameters: queryParameters);

    final response = await _client.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw ServerFailure(
        'Gagal memuat buku (kode ${response.statusCode}). Silakan coba lagi.',
      );
    }

    try {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final docs = jsonMap['docs'] as List<dynamic>? ?? [];

      return docs
          .map((doc) => BookModel.fromSearchJson(doc as Map<String, dynamic>))
          .where((book) => book.id.isNotEmpty)
          .toList();
    } catch (_) {
      throw const ParseFailure();
    }
  }

  Future<BookModel> fetchWorkDetail(Book book) async {
    final workKey = book.id.startsWith('/') ? book.id : '/${book.id}';
    final uri = Uri.parse('${ApiConstants.baseUrl}$workKey.json');

    final response = await _client.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw ServerFailure(
        'Gagal memuat detail buku (kode ${response.statusCode}).',
      );
    }

    try {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return BookModel.fromWorkJson(jsonMap, baseBook: book);
    } catch (_) {
      throw const ParseFailure();
    }
  }
}
