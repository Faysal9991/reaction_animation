import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animation_test/main.dart';

void main() {
  testWidgets('person cards support multiple selection', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Person 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Person 3'));
    await tester.pumpAndSettle();

    expect(_isPersonSelected(tester, 'Person 1'), isTrue);
    expect(_isPersonSelected(tester, 'Person 2'), isTrue);
    expect(_isPersonSelected(tester, 'Person 3'), isTrue);
    expect(_isPersonSelected(tester, 'Person 4'), isFalse);
  });
}

bool _isPersonSelected(WidgetTester tester, String label) {
  final cardFinder = find.ancestor(
    of: find.text(label),
    matching: find.byType(AnimatedContainer),
  );
  final card = tester.widget<AnimatedContainer>(cardFinder);
  final decoration = card.decoration! as BoxDecoration;
  final border = decoration.border! as Border;

  return border.top.color == Colors.blueAccent;
}
