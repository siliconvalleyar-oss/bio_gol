import 'package:flutter_test/flutter_test.dart';
import 'package:biogol/main.dart';

void main() {
  testWidgets('App loads home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BioGolApp());
    await tester.pump();
    expect(find.text('BioGol'), findsOneWidget);
  });
}
