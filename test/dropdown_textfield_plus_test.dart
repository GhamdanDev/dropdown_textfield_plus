import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dropdown_textfield_plus/dropdown_textfield_plus.dart';

void main() {
  group('Widget smoke test', () {
    testWidgets('DropDownTextField renders without error', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DropDownTextField(
            dropDownList: const [
              DropDownValueModel(name: 'Option 1', value: '1'),
              DropDownValueModel(name: 'Option 2', value: '2'),
            ],
          ),
        ),
      ));
      expect(find.byType(DropDownTextField), findsOneWidget);
    });

    testWidgets('DropDownTextField.multiSelection renders without error',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DropDownTextField.multiSelection(
            dropDownList: const [
              DropDownValueModel(name: 'Option A', value: 'a'),
              DropDownValueModel(name: 'Option B', value: 'b'),
            ],
          ),
        ),
      ));
      expect(find.byType(DropDownTextField), findsOneWidget);
    });

    testWidgets('DropDownTextField opens dropdown on tap', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DropDownTextField(
            dropDownList: const [
              DropDownValueModel(name: 'Option 1', value: '1'),
              DropDownValueModel(name: 'Option 2', value: '2'),
            ],
          ),
        ),
      ));

      // Options should not be visible before opening the dropdown
      expect(find.text('Option 1'), findsNothing);
      expect(find.text('Option 2'), findsNothing);

      // Tap the text field to open the dropdown
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Dropdown options should now be visible in the overlay
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('DropDownTextField.multiSelection opens dropdown on tap',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DropDownTextField.multiSelection(
            dropDownList: const [
              DropDownValueModel(name: 'Item A', value: 'a'),
              DropDownValueModel(name: 'Item B', value: 'b'),
            ],
          ),
        ),
      ));

      // Options should not be visible before opening the dropdown
      expect(find.text('Item A'), findsNothing);
      expect(find.text('Item B'), findsNothing);

      // Tap the text field to open the dropdown
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Dropdown options should now be visible in the overlay
      expect(find.text('Item A'), findsOneWidget);
      expect(find.text('Item B'), findsOneWidget);
    });

    testWidgets('DropDownTextField selects item from dropdown', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DropDownTextField(
            dropDownList: const [
              DropDownValueModel(name: 'Option 1', value: '1'),
              DropDownValueModel(name: 'Option 2', value: '2'),
            ],
          ),
        ),
      ));

      // Open the dropdown
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Tap on 'Option 2' in the dropdown list
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      // The text field should now display 'Option 2'
      expect(find.text('Option 2'), findsOneWidget);
      // 'Option 1' should no longer be visible (overlay closed)
      expect(find.text('Option 1'), findsNothing);
    });
  });

  group('SingleValueDropDownController', () {
    test('clearDropDown() when already null does NOT notify', () {
      final controller = SingleValueDropDownController();
      int count = 0;
      controller.addListener(() => count++);
      controller.clearDropDown();
      expect(count, 0);
    });

    test('setDropDown() with same value does NOT notify', () {
      final model = DropDownValueModel(name: 'test', value: '1');
      final controller = SingleValueDropDownController(data: model);
      int count = 0;
      controller.addListener(() => count++);
      controller.setDropDown(model);
      expect(count, 0);
    });

    test('setDropDown() with different value DOES notify', () {
      final model1 = DropDownValueModel(name: 'a', value: '1');
      final model2 = DropDownValueModel(name: 'b', value: '2');
      final controller = SingleValueDropDownController(data: model1);
      int count = 0;
      controller.addListener(() => count++);
      controller.setDropDown(model2);
      expect(count, 1);
    });

    test('clearDropDown() with value DOES notify', () {
      final model = DropDownValueModel(name: 'test', value: '1');
      final controller = SingleValueDropDownController(data: model);
      int count = 0;
      controller.addListener(() => count++);
      controller.clearDropDown();
      expect(count, 1);
    });
  });

  group('MultiValueDropDownController', () {
    test('clearDropDown() when already null does NOT notify', () {
      final controller = MultiValueDropDownController();
      int count = 0;
      controller.addListener(() => count++);
      controller.clearDropDown();
      expect(count, 0);
    });

    test('setDropDown() with same list does NOT notify', () {
      final list = [
        DropDownValueModel(name: 'a', value: '1'),
        DropDownValueModel(name: 'b', value: '2'),
      ];
      final controller = MultiValueDropDownController(data: list);
      int count = 0;
      controller.addListener(() => count++);
      controller.setDropDown(list);
      expect(count, 0);
    });

    test('setDropDown() with different list DOES notify', () {
      final list1 = [DropDownValueModel(name: 'a', value: '1')];
      final list2 = [DropDownValueModel(name: 'b', value: '2')];
      final controller = MultiValueDropDownController(data: list1);
      int count = 0;
      controller.addListener(() => count++);
      controller.setDropDown(list2);
      expect(count, 1);
    });
  });

  group('DropDownValueModel', () {
    test('equality works', () {
      final a = DropDownValueModel(name: 'x', value: '1');
      final b = DropDownValueModel(name: 'x', value: '1');
      expect(a, b);
    });

    test('inequality works', () {
      final a = DropDownValueModel(name: 'x', value: '1');
      final b = DropDownValueModel(name: 'y', value: '1');
      expect(a, isNot(b));
    });

    test('fromJson/toJson round trip', () {
      final original = DropDownValueModel(
        name: 'test',
        value: 'val',
        toolTipMsg: 'tip',
      );
      final json = original.toJson();
      final restored = DropDownValueModel.fromJson(json);
      expect(restored, original);
    });
  });
}
