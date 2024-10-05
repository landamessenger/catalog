/// AUTOGENERATED FILE.
///
/// Use this file to test the widget FabWidget
///

import 'package:catalog/catalog.dart';

import '../dummy/fab_widget.dummy.dart';
import '../preview/fab_widget.preview.dart';

class FabWidgetIntegrationTest {
  void main() {
    group(
      'FabWidget - IntegrationTest Tests',
      () {
        testWidgets(
          'Lorem text not found',
          (tester) async {
            final dummy = FabWidgetDummy().dummies.first;
            final widget = buildFabWidget(dummy);
            await tester.test(widget);

            expect(find.text('lorem ipsu'), findsNothing);
          },
        );

        testWidgets(
          'Other lorem text not found',
          (tester) async {
            final dummy = FabWidgetDummy().dummies.first;
            final widget = buildFabWidget(dummy);
            await tester.test(widget);

            expect(find.text('ipsu lorem'), findsNothing);
          },
        );
      },
    );
  }
}