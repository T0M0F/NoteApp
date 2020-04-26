import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveChild.dart';
import 'package:boostnote_mobile/presentation/widgets/responsive/ResponsiveWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
  
void main() {

  testWidgets('Test responsive widget on small screen and portrait mode with default breakpoint', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: Size(600, 800)), 
          child: ResponsiveWidget(
            widgets: <ResponsiveChild> [
            ResponsiveChild(
              child: Container(color: Colors.red, key: Key('Container1')),
              largeFlex: 1,
              smallFlex: 1
            ), 
            ResponsiveChild(
              child: Container(color: Colors.blue, key: Key('Container2')),
              largeFlex: 2,
              smallFlex: 0
            ), 
          ])
        )
      ),
    ));

    final Finder container1Finder = find.byKey(Key('Container1'));
    final Finder container2Finder = find.byKey(Key('Container2'));

    expect(container1Finder, findsOneWidget);
    expect(container2Finder, findsNothing);
  });

  testWidgets('Test responsive widget on small screen and landscape mode with default breakpoint', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: Size(800, 600)), 
          child: ResponsiveWidget(
            widgets: <ResponsiveChild> [
            ResponsiveChild(
              child: Container(color: Colors.red, key: Key('Container1')),
              largeFlex: 1,
              smallFlex: 1
            ), 
            ResponsiveChild(
              child: Container(color: Colors.blue, key: Key('Container2')),
              largeFlex: 2,
              smallFlex: 0
            ), 
          ])
        )
      ),
    ));

    final Finder container1Finder = find.byKey(Key('Container1'));
    final Finder container2Finder = find.byKey(Key('Container2'));

    expect(container1Finder, findsOneWidget);
    expect(container2Finder, findsNothing);
  });

  testWidgets('Test responsive widget on big screen and portrait mode with default breakpoint', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: Size(800, 1200)), 
          child: ResponsiveWidget(
            widgets: <ResponsiveChild> [
            ResponsiveChild(
              child: Container(color: Colors.red, key: Key('Container1')),
              largeFlex: 1,
              smallFlex: 1
            ), 
            ResponsiveChild(
              child: Container(color: Colors.blue, key: Key('Container2')),
              largeFlex: 2,
              smallFlex: 0
            ), 
          ])
        )
      ),
    ));

    final Finder container1Finder = find.byKey(Key('Container1'));
    final Finder container2Finder = find.byKey(Key('Container2'));

    expect(container1Finder, findsOneWidget);
    expect(container2Finder, findsNothing);
  });

   testWidgets('Test responsive widget on big screen and landscape mode with default breakpoint', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: Size(1200, 800)), 
          child: ResponsiveWidget(
            widgets: <ResponsiveChild> [
            ResponsiveChild(
              child: Container(color: Colors.red, key: Key('Container1')),
              largeFlex: 1,
              smallFlex: 1
            ), 
            ResponsiveChild(
              child: Container(color: Colors.blue, key: Key('Container2')),
              largeFlex: 2,
              smallFlex: 0
            ), 
          ])
        )
      ),
    ));

    final Finder container1Finder = find.byKey(Key('Container1'));
    final Finder container2Finder = find.byKey(Key('Container2'));

    expect(container1Finder, findsOneWidget);
    expect(container2Finder, findsOneWidget);
  });

  testWidgets('Test responsive widget on small screen and landscape mode with breakpoint at 800', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: Size(800, 600)), 
          child: ResponsiveWidget(
            breakPoint: 700,
            widgets: <ResponsiveChild> [
            ResponsiveChild(
              child: Container(color: Colors.red, key: Key('Container1')),
              largeFlex: 1,
              smallFlex: 1
            ), 
            ResponsiveChild(
              child: Container(color: Colors.blue, key: Key('Container2')),
              largeFlex: 2,
              smallFlex: 0
            ), 
          ])
        )
      ),
    ));

    final Finder container1Finder = find.byKey(Key('Container1'));
    final Finder container2Finder = find.byKey(Key('Container2'));

    expect(container1Finder, findsOneWidget);
    expect(container2Finder, findsOneWidget);
  });

  testWidgets('Test if divider is present', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: Size(1200, 800)), 
          child: ResponsiveWidget(
            showDivider: true,
            divider: Container(
              key: Key('Divider'),
              width: 1,
              color: Colors.black,
            ),
            widgets: <ResponsiveChild> [
            ResponsiveChild(
              child: Container(color: Colors.red, key: Key('Container1')),
              largeFlex: 1,
              smallFlex: 1
            ), 
            ResponsiveChild(
              child: Container(color: Colors.blue, key: Key('Container2')),
              largeFlex: 2,
              smallFlex: 0
            ), 
          ])
        )
      ),
    ));

    final Finder dividerFinder = find.byKey(Key('Divider'));

    expect(dividerFinder, findsOneWidget);
  });
}