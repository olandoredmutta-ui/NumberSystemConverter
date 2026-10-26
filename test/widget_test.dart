import 'package:flutter_test/flutter_test.dart';
import 'package:number_system_converter/main.dart';

void main() {
  testWidgets('Number converter app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const NumberConverterApp());

    expect(find.text('Number Converter'), findsOneWidget);
  });
}