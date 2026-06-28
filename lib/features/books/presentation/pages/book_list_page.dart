import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziyadbooks_test/core/widgets/error_view.dart';
import 'package:ziyadbooks_test/core/widgets/loading_indicator.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';
import 'package:ziyadbooks_test/features/books/presentation/cubit/book_list_cubit.dart';
import 'package:ziyadbooks_test/features/books/presentation/cubit/book_list_state.dart';
import 'package:ziyadbooks_test/features/books/presentation/pages/book_detail_page.dart';
import 'package:ziyadbooks_test/features/books/presentation/widgets/book_list_tile.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<BookListCubit>().loadBooks();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<BookListCubit>().searchBooks(value);
    });
  }

  void _openDetail(Book book) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookDetailPage(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku Anak'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan judul...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: BlocBuilder<BookListCubit, BookListState>(
                  builder: (context, state) {
                    if (state is BookListLoading &&
                        state.previousBooks.isNotEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    if (_searchController.text.isNotEmpty) {
                      return IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: const Icon(Icons.clear),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<BookListCubit, BookListState>(
              builder: (context, state) {
                return switch (state) {
                  BookListInitial() || BookListLoading(previousBooks: []) =>
                    const LoadingIndicator(message: 'Memuat daftar buku...'),
                  BookListLoading(:final previousBooks) when previousBooks.isNotEmpty =>
                    _BookListView(
                      books: previousBooks,
                      onBookTap: _openDetail,
                      isRefreshing: true,
                    ),
                  BookListLoaded(:final books, :final searchQuery) =>
                    books.isEmpty
                        ? _EmptySearchView(query: searchQuery)
                        : _BookListView(
                            books: books,
                            onBookTap: _openDetail,
                          ),
                  BookListError(:final message, :final previousBooks) =>
                    previousBooks.isEmpty
                        ? ErrorView(
                            message: message,
                            onRetry: () => context
                                .read<BookListCubit>()
                                .searchBooks(_searchController.text),
                          )
                        : Column(
                            children: [
                              MaterialBanner(
                                content: Text(message),
                                actions: [
                                  TextButton(
                                    onPressed: () => context
                                        .read<BookListCubit>()
                                        .searchBooks(_searchController.text),
                                    child: const Text('Coba lagi'),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: _BookListView(
                                  books: previousBooks,
                                  onBookTap: _openDetail,
                                ),
                              ),
                            ],
                          ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BookListView extends StatelessWidget {
  const _BookListView({
    required this.books,
    required this.onBookTap,
    this.isRefreshing = false,
  });

  final List<Book> books;
  final ValueChanged<Book> onBookTap;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return BookListTile(
              book: book,
              onTap: () => onBookTap(book),
            );
          },
        ),
        if (isRefreshing)
          const Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}

class _EmptySearchView extends StatelessWidget {
  const _EmptySearchView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 56,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              query.isEmpty
                  ? 'Tidak ada buku ditemukan.'
                  : 'Tidak ada buku dengan judul "$query".',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
