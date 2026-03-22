import 'package:flutter_test/flutter_test.dart';
import 'package:web/main.dart';

void main() {
  testWidgets('renders target time label', (tester) async {
    await tester.pumpWidget(const TimerWebApp());
    expect(find.text('목표 시각'), findsOneWidget);
  });
}
