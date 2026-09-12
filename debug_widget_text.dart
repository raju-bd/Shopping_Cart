import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/main.dart';

void main() {
  testWidgets('debug widget texts', (tester) async {
    await tester.pumpWidget(const MyApp());
    final texts = tester.widgetList<Text>(find.byType(Text)).map((w) => w.data ?? '').toList();
    print('TEXT_COUNT=${texts.length}');
    for (final text in texts) {
      if (text.isNotEmpty) print('TEXT: $text');
    }
    expect(find.text('T-Shirt'), findsOneWidget);
    expect(find.text('Shoes'), findsOneWidget);
  });
}
