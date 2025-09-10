
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('Work Hour Calculator UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TimeTrackerApp());

    // Verify that the title is rendered.
    expect(find.text('Work Hour Calculator'), findsOneWidget);

    // Verify that the "Select In-Time" button is present.
    expect(find.text('Select In-Time'), findsOneWidget);

    // Verify that the "Calculate" button is present.
    expect(find.text('Calculate'), findsOneWidget);

    // Verify that the effective hours and minutes fields are present.
    expect(find.byWidgetPredicate((widget) => widget is TextField && widget.decoration?.labelText == 'Effective Hours'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is TextField && widget.decoration?.labelText == 'Effective Minutes'), findsOneWidget);
  });

  testWidgets('Work Hour Calculator Calculation Test - Extra Hours', (WidgetTester tester) async {
    await tester.pumpWidget(const TimeTrackerApp());

    // Manually set the in-time to 9:00 AM.
    final state = tester.state<TimeTrackerHomePageState>(find.byType(TimeTrackerHomePage));
    state.setState(() {
      state.inTime = const TimeOfDay(hour: 9, minute: 0);
    });
    await tester.pump();

    // Enter effective hours and minutes.
    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextField && widget.decoration?.labelText == 'Effective Hours'), '2');
    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextField && widget.decoration?.labelText == 'Effective Minutes'), '0');

    // Tap the "Calculate" button.
    await tester.tap(find.text('Calculate'));
    await tester.pump();

    // Verify that the total work time and extra time are displayed.
    expect(find.text('Total work time by 6:30 PM: 11 hours and 30 minutes'), findsOneWidget);
    expect(find.text('You have worked 3 hours and 30 minutes extra.'), findsOneWidget);
  });

  testWidgets('Work Hour Calculator Calculation Test - Remaining Hours', (WidgetTester tester) async {
    await tester.pumpWidget(const TimeTrackerApp());

    // Manually set the in-time to 11:00 AM.
    final state = tester.state<TimeTrackerHomePageState>(find.byType(TimeTrackerHomePage));
    state.setState(() {
      state.inTime = const TimeOfDay(hour: 11, minute: 0);
    });
    await tester.pump();

    // Enter effective hours and minutes.
    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextField && widget.decoration?.labelText == 'Effective Hours'), '1');
    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextField && widget.decoration?.labelText == 'Effective Minutes'), '0');

    // Tap the "Calculate" button.
    await tester.tap(find.text('Calculate'));
    await tester.pump();

    // Verify that the total work time and remaining time are displayed.
    expect(find.text('Total work time by 6:30 PM: 8 hours and 30 minutes'), findsOneWidget);
    expect(find.text('You have worked 0 hours and 30 minutes extra.'), findsOneWidget);
  });

  testWidgets('Work Hour Calculator In-Time Validation Test', (WidgetTester tester) async {
    await tester.pumpWidget(const TimeTrackerApp());

    // Manually set a time after 6:30 PM.
    final state = tester.state<TimeTrackerHomePageState>(find.byType(TimeTrackerHomePage));
    state.setState(() {
      state.inTime = const TimeOfDay(hour: 19, minute: 0);
    });
    await tester.pump();

    // Tap the "Calculate" button.
    await tester.tap(find.text('Calculate'));
    await tester.pump();

    // Verify that the validation message is displayed.
    expect(find.text('In-time must be before 6:30 PM'), findsOneWidget);
  });
}
