import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopping_cart/main.dart';

void main() {
  testWidgets('debug search and dropdown', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField), 'sh');
    await tester.pump();
    print('AFTER SEARCH');
    final texts1 = tester.widgetList<Text>(find.byType(Text)).toList();
    for (final item in texts1) {
      print('TEXT: ${item.data}');
    }

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    print('AFTER OPEN');
    final texts2 = tester.widgetList<Text>(find.byType(Text)).toList();
    for (final item in texts2) {
      print('TEXT: ${item.data}');
    }

    await tester.tap(find.text('Fashion').last);
    await tester.pumpAndSettle();
    print('AFTER SELECT FASHION');
    final texts3 = tester.widgetList<Text>(find.byType(Text)).toList();
    for (final item in texts3) {
      print('TEXT: ${item.data}');
    }
  });
}
