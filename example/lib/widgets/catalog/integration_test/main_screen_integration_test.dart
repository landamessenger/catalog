/// AUTOGENERATED FILE.
///
/// Use this file to test the widget MainScreen
///

import 'package:catalog/catalog.dart';

import '../dummy/main_screen.dummy.dart';
import '../preview/main_screen.preview.dart';

class MainScreenIntegrationTest {
  void main() {
    group(
      'MainScreen - IntegrationTest Tests',
      () {
        testWidgets(
          'Lorem text not found',
          (tester) async {
            final dummy = MainScreenDummy().dummies.first;
            final widget = buildMainScreen(dummy);
            await tester.test(widget);

            expect(find.text('lorem ipsu'), findsNothing);
          },
        );

        testWidgets(
          'Other lorem text not found',
          (tester) async {
            final dummy = MainScreenDummy().dummies.first;
            final widget = buildMainScreen(dummy);
            await tester.test(widget);

            expect(find.text('ipsu lorem'), findsNothing);
          },
        );
      },
    );
  }
}
