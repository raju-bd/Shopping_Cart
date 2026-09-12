import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopping_cart/main.dart';

void main() {
  testWidgets('product cards render and quantity updates total',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Simple Shopping Cart'), findsOneWidget);
    expect(find.text('T-Shirt'), findsOneWidget);
    expect(find.text('Shoes'), findsOneWidget);

    final addButtons = find.byIcon(Icons.add);
    expect(addButtons, findsWidgets);

    await tester.tap(addButtons.first);
    await tester.pump();

    expect(find.text('Total Items: 1'), findsOneWidget);
    expect(find.text('Subtotal: ৳500'), findsOneWidget);
    expect(find.text('Grand Total: ৳500'), findsOneWidget);
  });

  testWidgets('search and category filter work together',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), 'sh');
    await tester.pump();

    expect(find.text('Shoes'), findsOneWidget);
    expect(find.text('T-Shirt'), findsNothing);

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fashion').last);
    await tester.pumpAndSettle();

    expect(find.text('Shoes'), findsOneWidget);
    expect(find.text('T-Shirt'), findsNothing);
  });

  testWidgets('quantity cannot go below zero and discount applies',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final itemCard = find.widgetWithText(Card, 'T-Shirt');
    expect(itemCard, findsOneWidget);

    final minusButton = find.descendant(
      of: itemCard,
      matching: find.byIcon(Icons.remove),
    );

    await tester.tap(minusButton);
    await tester.pump();

    expect(find.textContaining('Quantity: 0'), findsWidgets);
    expect(find.text('Subtotal: ৳0'), findsOneWidget);

    final addButton = find.descendant(
      of: itemCard,
      matching: find.byIcon(Icons.add),
    );

    for (var i = 0; i < 6; i++) {
      await tester.tap(addButton);
      await tester.pump();
    }

    expect(find.text('Total Items: 6'), findsOneWidget);
    expect(find.text('Subtotal: ৳3000'), findsOneWidget);
    expect(find.text('Discount: ৳300'), findsOneWidget);
    expect(find.text('Grand Total: ৳2700'), findsOneWidget);
  });
}
