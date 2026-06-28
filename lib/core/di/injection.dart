import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziyadbooks_test/features/books/data/datasources/open_library_api.dart';
import 'package:ziyadbooks_test/features/books/data/repositories/book_repository_impl.dart';
import 'package:ziyadbooks_test/features/books/domain/repositories/book_repository.dart';
import 'package:ziyadbooks_test/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:ziyadbooks_test/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:ziyadbooks_test/features/favorites/domain/repositories/favorites_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerLazySingleton<OpenLibraryApi>(OpenLibraryApi.new);

  getIt.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(api: getIt<OpenLibraryApi>()),
  );

  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSource(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      localDataSource: getIt<FavoritesLocalDataSource>(),
    ),
  );
}
