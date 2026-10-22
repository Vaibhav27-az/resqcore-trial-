import 'package:flutter_test/flutter_test.dart';
import 'package:rescue_core/main.dart';

void main() {
  testWidgets('ResQCore smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ResQCoreApp());
    expect(find.text('ResQCore'), findsWidgets);
  });
}
