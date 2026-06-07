# dropdown_textfield_plus

[![pub package](https://img.shields.io/pub/v/dropdown_textfield_plus.svg)](https://pub.dev/packages/dropdown_textfield_plus)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.27.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart SDK](https://img.shields.io/badge/dart-%5E3.12.0-0175C2?logo=dart)](https://dart.dev)

A powerful, customizable dropdown text field for Flutter with single and multi-selection, real-time search filtering, tooltips.

---

## Features

- **Single & Multi Selection** — Two named constructors (`DropDownTextField` / `DropDownTextField.multiSelection`)
- **Search Filtering** — Real-time search with custom decoration, keyboard type, and autofocus
- **Dark Mode** — Uses `surfaceContainerHighest` from Material 3 color scheme automatically
- **Form Integration** — `autovalidateMode`, `FormFieldValidator`, `onChanged` callback for seamless form use
- **Controllers** — `SingleValueDropDownController` & `MultiValueDropDownController` with programmatic control and change notification
- **Tooltips** — Per-item info tooltips in multi-selection mode
- **Customizable** — Dropdown color, icons, clear button, checkbox properties, submit button, list padding
---

## Screenshots

| Home | Search |
|:---:|:---:|
| ![Home](https://raw.githubusercontent.com/GhamdanDev/dropdown_textfield_plus/master/screenshots/Screenshot_home.jpg) | ![Search](https://raw.githubusercontent.com/GhamdanDev/dropdown_textfield_plus/master/screenshots/Screenshot_searching.jpg) |

---

## Installation
```bash
flutter pub add dropdown_textfield_plus
```

Or manually add to your `pubspec.yaml`:

```yaml
dependencies:
  dropdown_textfield_plus: ^1.0.0
```

Then import:

```dart
import 'package:dropdown_textfield_plus/dropdown_textfield_plus.dart';
```

---

## Quick Start

### Single Selection

```dart
DropDownTextField(
  dropDownList: const [
    DropDownValueModel(name: 'Option 1', value: '1'),
    DropDownValueModel(name: 'Option 2', value: '2'),
    DropDownValueModel(name: 'Option 3', value: '3'),
  ],
  onChanged: (val) {
    print('Selected: $val');
  },
)
```

### Multi Selection

```dart
DropDownTextField.multiSelection(
  dropDownList: const [
    DropDownValueModel(name: 'Item A', value: 'a'),
    DropDownValueModel(name: 'Item B', value: 'b'),
  ],
  onChanged: (val) {
    print('Selected: $val');
  },
)
```

### With Controller

```dart
final controller = SingleValueDropDownController(
  data: DropDownValueModel(name: 'Default', value: '0'),
);

DropDownTextField(
  controller: controller,
  dropDownList: const [
    DropDownValueModel(name: 'Option 1', value: '1'),
    DropDownValueModel(name: 'Option 2', value: '2'),
  ],
)

// Programmatic control:
controller.setDropDown(newValue);
controller.clearDropDown();
```

---

## API Reference

### DropDownTextField

The main widget. Use the default constructor for **single selection** and `DropDownTextField.multiSelection` for **multi selection**.

#### Constructor Parameters (Single Selection)

| Parameter              | Type                             | Default      | Description                                                                                               |
| ---------------------- | -------------------------------- | ------------ | --------------------------------------------------------------------------------------------------------- |
| `dropDownList`         | `List<DropDownValueModel>`       | **required** | The list of items to display in the dropdown                                                              |
| `controller`           | `SingleValueDropDownController?` | `null`       | Controller for programmatic access                                                                        |
| `initialValue`         | `dynamic`                        | `null`       | Initial selected value (string name). Mutually exclusive with `controller`                                |
| `onChanged`            | `ValueSetter<dynamic>?`          | `null`       | Called when the selection changes                                                                         |
| `validator`            | `FormFieldValidator<String>?`    | `null`       | Form validator callback                                                                                   |
| `isEnabled`            | `bool`                           | `true`       | Whether the text field is enabled                                                                         |
| `readOnly`             | `bool`                           | `true`       | Whether the text field is read-only. Set to `false` with `enableSearch: true` for auto-sort editable mode |
| `enableSearch`         | `bool`                           | `false`      | Enable search filtering in the dropdown                                                                   |
| `dropdownRadius`       | `double`                         | `12`         | Border radius of the dropdown overlay                                                                     |
| `dropdownColor`        | `Color?`                         | `null`       | Background color of the dropdown. Falls back to `surfaceContainerHighest`                                 |
| `textFieldDecoration`  | `InputDecoration?`               | `null`       | Decoration for the text field                                                                             |
| `textStyle`            | `TextStyle?`                     | `null`       | Text style for the input field                                                                            |
| `padding`              | `EdgeInsets?`                    | `null`       | Padding around the text field                                                                             |
| `dropDownIconProperty` | `IconProperty?`                  | `null`       | Properties for the dropdown arrow icon                                                                    |
| `dropDownItemCount`    | `int`                            | `6`          | Maximum visible items before scrolling                                                                    |
| `listSpace`            | `double`                         | `0`          | Extra space between the text field and the dropdown list                                                  |
| `listPadding`          | `ListPadding?`                   | `null`       | Padding for list items (`top` / `bottom`, default `15`)                                                   |
| `listTextStyle`        | `TextStyle?`                     | `null`       | Text style for list items (defaults to `titleMedium`)                                                     |
| `clearOption`          | `bool`                           | `true`       | Show clear button when a value is selected                                                                |
| `clearIconProperty`    | `IconProperty?`                  | `null`       | Properties for the clear icon                                                                             |
| `keyboardType`         | `TextInputType?`                 | `null`       | Keyboard type for the text field                                                                          |
| `autovalidateMode`     | `AutovalidateMode?`              | `null`       | Auto-validation mode for form integration                                                                 |
| `searchDecoration`     | `InputDecoration?`               | `null`       | Decoration for the search text field                                                                      |
| `searchTextStyle`      | `TextStyle?`                     | `null`       | Text style for the search field                                                                           |
| `searchKeyboardType`   | `TextInputType?`                 | `null`       | Keyboard type for the search field                                                                        |
| `searchFocusNode`      | `FocusNode?`                     | `null`       | Focus node for the search field                                                                           |
| `textFieldFocusNode`   | `FocusNode?`                     | `null`       | Focus node for the main text field                                                                        |
| `searchAutofocus`      | `bool`                           | `false`      | Auto-focus the search field when the dropdown opens                                                       |
| `searchShowCursor`     | `bool?`                          | `null`       | Whether to show the cursor in the search field                                                            |

> **Note:** `initialValue` and `controller` are mutually exclusive. Use the controller's `data` parameter to set an initial value when using a controller.

#### Constructor Parameters (Multi Selection — `.multiSelection`)

All parameters from the single selection apply **except** `enableSearch`, `readOnly`, `search*`, and `keyboardType`. The following additional parameters are available:

| Parameter               | Type                            | Default        | Description                                                                             |
| ----------------------- | ------------------------------- | -------------- | --------------------------------------------------------------------------------------- |
| `controller`            | `MultiValueDropDownController?` | `null`         | Controller for programmatic access                                                      |
| `initialValue`          | `dynamic`                       | `null`         | Initial selected items as `List<String>` of names. Mutually exclusive with `controller` |
| `displayCompleteItem`   | `bool`                          | `false`        | If `true`, shows comma-separated item names instead of "N item selected"                |
| `submitButtonColor`     | `Color?`                        | `Colors.green` | Background color of the submit button                                                   |
| `submitButtonText`      | `String?`                       | `'Ok'`         | Text of the submit button                                                               |
| `submitButtonTextStyle` | `TextStyle?`                    | `null`         | Text style for the submit button                                                        |
| `checkBoxProperty`      | `CheckBoxProperty?`             | `null`         | Properties for the selection checkboxes                                                 |

---

### DropDownValueModel

Represents a single item in the dropdown list.

```dart
const DropDownValueModel({
  required String name,      // Display text
  required dynamic value,   // Associated value
  String? toolTipMsg,       // Tooltip message (shown in multi-selection mode)
});
```

**Properties:**

| Property     | Type      | Description                                                                                 |
| ------------ | --------- | ------------------------------------------------------------------------------------------- |
| `name`       | `String`  | Display text shown in the dropdown                                                          |
| `value`      | `dynamic` | Associated value (returned in callbacks)                                                    |
| `toolTipMsg` | `String?` | Tooltip message — shows an info icon in multi-selection mode that users can tap for details |

**Serialization:**

```dart
// From JSON
final model = DropDownValueModel.fromJson(json);

// To JSON
final json = model.toJson();
```

---

### SingleValueDropDownController

Controller for single selection mode. Extends `ChangeNotifier`.

```dart
final controller = SingleValueDropDownController(
  data: DropDownValueModel(name: 'Default', value: '0'),
);
```

**Methods:**

| Method                                   | Description                                |
| ---------------------------------------- | ------------------------------------------ |
| `setDropDown(DropDownValueModel? model)` | Set the selected value. Notifies listeners |
| `clearDropDown()`                        | Clear the selection. Notifies listeners    |

**Properties:**

| Property        | Type                  | Description                 |
| --------------- | --------------------- | --------------------------- |
| `dropDownValue` | `DropDownValueModel?` | The currently selected item |

---

### MultiValueDropDownController

Controller for multi selection mode. Extends `ChangeNotifier`.

```dart
final controller = MultiValueDropDownController(
  data: [
    DropDownValueModel(name: 'Item A', value: 'a'),
  ],
);
```

**Methods:**

| Method                                             | Description                                                             |
| -------------------------------------------------- | ----------------------------------------------------------------------- |
| `setDropDown(List<DropDownValueModel>? modelList)` | Set the selected items. Notifies listeners (deduplicates automatically) |
| `clearDropDown()`                                  | Clear all selections. Notifies listeners                                |

**Properties:**

| Property            | Type                        | Description                  |
| ------------------- | --------------------------- | ---------------------------- |
| `dropDownValueList` | `List<DropDownValueModel>?` | The currently selected items |

---

### IconProperty

Configures icon appearance throughout the widget.

```dart
const IconProperty({
  IconData? icon,    // Icon to display
  Color? color,      // Icon tint color
  double? size,      // Icon size
});
```

Used by:

- `dropDownIconProperty` — the dropdown arrow icon (default: `Icons.arrow_drop_down_outlined`)
- `clearIconProperty` — the clear/close icon (default: `Icons.clear` / `Icons.close`)

---

### CheckBoxProperty

Configures checkbox appearance in multi-selection mode. Wraps Flutter's native `Checkbox` properties.

```dart
const CheckBoxProperty({
  bool tristate = false,
  MouseCursor? mouseCursor,
  Color? activeColor,
  WidgetStateProperty<Color?>? fillColor,
  Color? checkColor,
  bool autofocus = false,
  Color? focusColor,
  Color? hoverColor,
  WidgetStateProperty<Color?>? overlayColor,
  double? splashRadius,
  MaterialTapTargetSize? materialTapTargetSize,
  VisualDensity? visualDensity,
  FocusNode? focusNode,
  OutlinedBorder? shape,
  BorderSide? side,
});
```

Refer to the [Flutter Checkbox documentation](https://api.flutter.dev/flutter/material/Checkbox-class.html) for detailed property descriptions.

---

### ListPadding

Controls the vertical padding of dropdown list items.

```dart
const ListPadding({
  double top = 15,    // Top padding for each list item
  double bottom = 15, // Bottom padding for each list item
});
```

---

## Customization

### Styling the Dropdown

```dart
DropDownTextField(
  dropdownColor: Colors.white,
  dropdownRadius: 8,
  dropDownIconProperty: const IconProperty(
    icon: Icons.expand_more,
    color: Colors.grey,
    size: 28,
  ),
  textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
  listTextStyle: const TextStyle(fontSize: 14),
  listPadding: const ListPadding(top: 12, bottom: 12),
  // ...
)
```

### Icons & Clear Button

```dart
DropDownTextField(
  clearOption: true,
  clearIconProperty: const IconProperty(
    icon: Icons.close_rounded,
    color: Colors.red,
    size: 20,
  ),
  // ...
)
```

### Search Configuration

```dart
DropDownTextField(
  enableSearch: true,
  searchAutofocus: true,
  searchDecoration: const InputDecoration(
    hintText: 'Search items...',
    prefixIcon: Icon(Icons.search),
  ),
  searchKeyboardType: TextInputType.text,
  searchShowCursor: true,
  // ...
)
```

### Checkbox Properties (Multi Selection)

```dart
DropDownTextField.multiSelection(
  checkBoxProperty: const CheckBoxProperty(
    activeColor: Colors.teal,
    checkColor: Colors.white,
    shape: CircleBorder(),
    side: BorderSide(color: Colors.teal, width: 2),
  ),
  // ...
)
```

### Submit Button (Multi Selection)

```dart
DropDownTextField.multiSelection(
  submitButtonText: 'Apply',
  submitButtonColor: Colors.blue,
  submitButtonTextStyle: const TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  // ...
)
```

### Display Mode (Multi Selection)

Control how selected items appear in the text field:

```dart
// Shows "3 item selected" (default)
DropDownTextField.multiSelection(
  displayCompleteItem: false,
  // ...
)

// Shows "Item A,Item B,Item C"
DropDownTextField.multiSelection(
  displayCompleteItem: true,
  // ...
)
```

### Tooltips (Multi Selection)

Provide per-item tooltips using the `toolTipMsg` field on `DropDownValueModel`. An info icon appears next to items that have a tooltip.

```dart
DropDownValueModel(
  name: 'Premium Plan',
  value: 'premium',
  toolTipMsg: 'Includes unlimited ad plays and priority support',
)
```

### Form Integration

```dart
Form(
  key: _formKey,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  child: DropDownTextField(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select an option';
      }
      return null;
    },
    autovalidateMode: AutovalidateMode.onUserInteraction,
    // ...
  ),
)
```

---

## Material 3 & Dark Mode

The dropdown automatically adapts to the current theme using `Theme.of(context).colorScheme.surfaceContainerHighest` for the dropdown background. No additional configuration is needed for dark mode support.

```dart
// Your MaterialApp with dark theme:
MaterialApp(
  themeMode: ThemeMode.dark,
  theme: ThemeData(...),
  darkTheme: ThemeData.dark(...),
)
```

The widget will automatically render with the appropriate colors.

---

## Roadmap

- [ ] Custom search filtering logic / debouncing
- [ ] Async data loading (streams / futures)
- [ ] Custom list item builder
- [ ] Grouped list sections
- [ ] Accessibility improvements

Contributions and feature requests are welcome!

---

## Troubleshooting

### "you cannot add both initialValue and singleController"

These two parameters are mutually exclusive. Use the controller's `data` parameter instead:

```dart
// ❌ Incorrect
DropDownTextField(
  initialValue: 'Option 1',
  controller: myController, // Conflict!
)

// ✅ Correct
final controller = SingleValueDropDownController(
  data: DropDownValueModel(name: 'Option 1', value: '1'),
);
DropDownTextField(controller: controller);
```

### "readOnly!=true or enableSearch=true both condition does not work"

These two parameters cannot be combined. Search filtering is only available when `readOnly` is `true`.

---

## Contributing

### [Star the repo if this saved your sprint ⭐](https://github.com/GhamdanDev/dropdown_textfield_plus)

Found a bug? (Impossible, it’s an undocumented feature). Want to add something cool? Contributions are always welcome! Please follow these sacred rituals to contribute:

1. Clone the repository (`git clone https://github.com/GhamdanDev/dropdown_textfield_plus`)
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT License — see the [LICENSE](LICENSE) file for details.
