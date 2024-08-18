import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/providers/quiz_provider.dart';

void main() {
  testWidgets('Quiz App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => QuizProvider(),
        child: MyApp(),
      ),
    );

    // Verify that the app title is displayed.
    expect(find.text('Quiz App'), findsOneWidget);

    // Verify that the initial state shows loading or no quizzes available.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump the widget tree again to allow for any async operations to complete.
    await tester.pump(const Duration(seconds: 1));

    // After pumping, we should either see the list of quizzes or a message indicating no quizzes.
    expect(
      anyOf([
        find.byType(ListView),
        find.text('No quizzes available'),
        find.text('Error: Failed to load quizzes'), // In case of network error
      ]),
      findsOneWidget,
    );
  });
}