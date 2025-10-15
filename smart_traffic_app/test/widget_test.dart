// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_traffic_app/main.dart';
import 'package:smart_traffic_app/theme_manager.dart';

void main() {
  testWidgets('SafeRoute Pro smoke test', (WidgetTester tester) async {
    // Build our app with ThemeManager
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeManager(),
        child: MyApp(),
      ),
    );

    // Verify app title appears
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.traffic), findsOneWidget);
    expect(find.byIcon(Icons.local_hospital), findsOneWidget);
    expect(find.byIcon(Icons.map), findsOneWidget);

    // Verify theme toggle button exists
    expect(find.byIcon(Icons.light_mode), findsOneWidget);

    // Tap Traffic tab
    await tester.tap(find.byIcon(Icons.traffic));
    await tester.pumpAndSettle();

    // Verify Traffic screen title
    expect(find.text('Traffic'), findsOneWidget);

    // Tap Emergency tab
    await tester.tap(find.byIcon(Icons.local_hospital));
    await tester.pumpAndSettle();

    // Verify Emergency screen title
    expect(find.text('Emergency'), findsOneWidget);

    // Tap Map tab
    await tester.tap(find.byIcon(Icons.map));
    await tester.pumpAndSettle();

    // Verify Map screen (GoogleMap widget)
    expect(find.byType(GoogleMap), findsOneWidget);

    // Tap theme toggle
    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pumpAndSettle();

    // Verify dark mode toggle
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });
}