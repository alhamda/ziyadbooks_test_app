import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziyadbooks_test/core/widgets/error_view.dart';
import 'package:ziyadbooks_test/core/widgets/loading_indicator.dart';
import 'package:ziyadbooks_test/features/books/domain/entities/book.dart';
import 'package:ziyadbooks_test/features/books/presentation/pages/book_detail_page.dart';
import 'package:ziyadbooks_test/features/books/presentation/widgets/book_list_tile.dart';
import 'package:ziyadbooks_test/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:ziyadbooks_test/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  void _openDetail(BuildContext context, Book book) {
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
        title: const Text('Favorit'),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          return switch (state) {
            FavoritesInitial() || FavoritesLoading() =>
              const LoadingIndicator(message: 'Memuat favorit...'),
            FavoritesError(:final message) => ErrorView(
                message: message,
                onRetry: () => context.read<FavoritesCubit>().loadFavorites(),
              ),
            FavoritesLoaded(:final favorites) => favorites.isEmpty
                ? const _EmptyFavoritesView()
                : ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final book = favorites[index];
                      return BookListTile(
                        book: book,
                        onTap: () => _openDetail(context, book),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }
}

class _EmptyFavoritesView extends StatelessWidget {
  const _EmptyFavoritesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 56,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada buku favorit.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap ikon hati pada detail buku untuk menambahkannya ke sini.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
