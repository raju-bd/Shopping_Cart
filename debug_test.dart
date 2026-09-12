import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/main.dart';

void main() {
  testWidgets('debug print all text', (tester) async {
    await tester.pumpWidget(const MyApp());
    final texts = tester.widgetList<Text>(find.byType(Text)).toList();
    for (final text in texts) {
      print('TEXT: ${text.data}');
    }
    print('CARDS: ${tester.widgetList<Card>(find.byType(Card)).length}');
  });
}
