/// AUTOGENERATED FILE.
///
/// Use this file to test the widget MainScreen
///

import 'package:catalog/catalog.dart';
import 'package:example/r.dart';
import 'package:stringcare/stringcare.dart';

import '../dummy/main_screen.dummy.dart';
import '../preview/main_screen.preview.dart';

class MainScreenIntegrationTest {
  void main() {
    group(
      'MainScreen - IntegrationTest Tests',
      () {
        testWidgets(
          'Finds title and info text',
          (tester) async {
            await tester.setupIntegrationTestContext();
            final dummy = MainScreenDummy().dummies.first;
            final widget = buildMainScreen(dummy);
            await tester.test(widget);

            expect(find.text(R.strings.title_app.string()), findsAny);
            expect(find.text(R.strings.info_text.string()), findsAny);
          },
        );

        testWidgets(
          'Web title not displayed on widget',
          (tester) async {
            await tester.setupIntegrationTestContext();

            final dummy = MainScreenDummy().dummies.first;
            final widget = buildMainScreen(dummy);
            await tester.test(widget);

            expect(find.text(R.strings.title.string()), findsNothing);
          },
        );
      },
    );
  }
}
