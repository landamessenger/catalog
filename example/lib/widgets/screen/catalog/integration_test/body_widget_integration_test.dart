/// AUTOGENERATED FILE.
///
/// Use this file to test the widget BodyWidget
///

import 'package:catalog/catalog.dart';
import 'package:example/r.dart';
import 'package:stringcare/stringcare.dart';

import '../dummy/body_widget.dummy.dart';
import '../preview/body_widget.preview.dart';

class BodyWidgetIntegrationTest {
  void main() {
    group(
      'BodyWidget - IntegrationTest Tests',
      () {
        testWidgets(
          'No title is found',
          (tester) async {
            await tester.setupContext();

            final dummy = BodyWidgetDummy().dummies.first;
            final widget = buildBodyWidget(dummy);
            await tester.test(widget);

            expect(find.text(R.strings.title_app.string()), findsNothing);
          },
        );

        testWidgets(
          'Info text is displayed',
          (tester) async {
            await tester.setupContext();

            final dummy = BodyWidgetDummy().dummies.first;
            final widget = buildBodyWidget(dummy);
            await tester.test(widget);

            expect(find.text('You have pushed the button this many times:'),
                findsAny);
          },
        );
      },
    );
  }
}