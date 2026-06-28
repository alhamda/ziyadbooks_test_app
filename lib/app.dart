import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziyadbooks_test/app/main_shell.dart';
import 'package:ziyadbooks_test/core/di/injection.dart';
import 'package:ziyadbooks_test/features/books/domain/repositories/book_repository.dart';
import 'package:ziyadbooks_test/features/books/presentation/cubit/book_detail_cubit.dart';
import 'package:ziyadbooks_test/features/books/presentation/cubit/book_list_cubit.dart';
import 'package:ziyadbooks_test/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:ziyadbooks_test/features/favorites/presentation/cubit/favorites_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BookListCubit(repository: getIt<BookRepository>()),
        ),
        BlocProvider(
          create: (_) => BookDetailCubit(repository: getIt<BookRepository>()),
        ),
        BlocProvider(
          create: (_) => FavoritesCubit(repository: getIt<FavoritesRepository>())
            ..loadFavorites(),
        ),
      ],
      child: MaterialApp(
        title: 'Ziyad Books',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),
          ),
        ),
        home: const MainShell(),
      ),
    );
  }
}
