import 'package:flutter_test/flutter_test.dart';
import 'package:hazard_report_app/main.dart';
import 'package:hazard_report_app/screens/login_page.dart';

void main() {
  testWidgets('Shows LoginPage when not logged in', (tester) async {
    await tester.pumpWidget(const MyApp(isLoggedIn: false));
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
