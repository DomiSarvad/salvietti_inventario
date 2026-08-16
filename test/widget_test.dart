// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:salvietti_planta/main.dart';

void main() {
  testWidgets('Salvietti app loads login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SalviettiApp());

    expect(find.text('Salvietti Planta'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
  });
}
