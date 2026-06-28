import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziyadbooks_test/core/widgets/book_cover.dart';
import 'package:ziyadbooks_test/core/widgets/error_view.dart';
import 'package:ziyadbooks_test/core/widgets/loading_indicator.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';
import 'package:ziyadbooks_test/features/books/presentation/cubit/book_detail_cubit.dart';
import 'package:ziyadbooks_test/features/books/presentation/cubit/book_detail_state.dart';
import 'package:ziyadbooks_test/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:ziyadbooks_test/features/favorites/presentation/cubit/favorites_state.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.book});

  final Book book;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookDetailCubit>().loadDetail(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookDetailCubit, BookDetailState>(
      builder: (context, state) {
        final book = _resolveBook(state);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Buku'),
            actions: [
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, favoritesState) {
                  final isFavorite = favoritesState is FavoritesLoaded &&
                      favoritesState.isFavorite(book.id);

                  return IconButton(
                    onPressed: () =>
                        context.read<FavoritesCubit>().toggleFavorite(book),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    tooltip: isFavorite
                        ? 'Hapus dari favorit'
                        : 'Tambah ke favorit',
                  );
                },
              ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Book _resolveBook(BookDetailState state) {
    return switch (state) {
      BookDetailLoading(:final book) when book.id == widget.book.id => book,
      BookDetailLoaded(:final book) when book.id == widget.book.id => book,
      BookDetailError(:final book) when book.id == widget.book.id => book,
      _ => widget.book,
    };
  }

  Widget _buildBody(BookDetailState state) {
    final isCurrentBook = switch (state) {
      BookDetailLoading(:final book) => book.id == widget.book.id,
      BookDetailLoaded(:final book) => book.id == widget.book.id,
      BookDetailError(:final book) => book.id == widget.book.id,
      _ => false,
    };

    if (!isCurrentBook) {
      return const LoadingIndicator(message: 'Memuat detail buku...');
    }

    return switch (state) {
      BookDetailInitial() || BookDetailLoading() =>
        const LoadingIndicator(message: 'Memuat detail buku...'),
      BookDetailError(:final message) => ErrorView(
          message: message,
          onRetry: () =>
              context.read<BookDetailCubit>().loadDetail(widget.book),
        ),
      BookDetailLoaded(:final book) => _BookDetailContent(book: book),
    };
  }
}

class _BookDetailContent extends StatelessWidget {
  const _BookDetailContent({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: BookCover(
              coverUrl: book.coverUrl,
              width: 180,
              height: 260,
              borderRadius: 12,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            book.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Penulis',
            value: book.authorsLabel,
          ),
          _InfoRow(
            label: 'Tahun terbit',
            value: book.publishYearLabel,
          ),
          if (book.editionCount != null)
            _InfoRow(
              label: 'Jumlah edisi',
              value: book.editionCount.toString(),
            ),
          if (book.publishers.isNotEmpty)
            _InfoRow(
              label: 'Penerbit',
              value: book.publishers.join(', '),
            ),
          if (book.languages.isNotEmpty)
            _InfoRow(
              label: 'Bahasa',
              value: book.languages.join(', '),
            ),
          if (book.firstSentence != null && book.firstSentence!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Kalimat pembuka',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(book.firstSentence!),
          ],
          if (book.description != null && book.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Deskripsi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(book.description!),
          ],
          if (book.subjects.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Subjek',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: book.subjects
                  .take(10)
                  .map(
                    (subject) => Chip(
                      label: Text(subject),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
