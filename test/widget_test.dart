import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziyadbooks_test/app.dart';
import 'package:ziyadbooks_test/core/di/injection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
    await setupServiceLocator();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('App menampilkan halaman beranda', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Buku Anak'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Favorit'), findsOneWidget);
  });
}
