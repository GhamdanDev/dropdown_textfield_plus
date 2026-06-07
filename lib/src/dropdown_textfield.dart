import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'multi_selection.dart';
import 'single_selection.dart';

/// Configuration for an icon's visual properties.
///
/// Used to customize icons throughout the dropdown, such as
/// the dropdown arrow and the clear (X) icon.
class IconProperty {
  /// The icon data to display. If null, a default icon is used.
  final IconData? icon;

  /// The color applied to the icon.
  final Color? color;

  /// The size of the icon in logical pixels.
  final double? size;

  /// Creates an [IconProperty] with the given [icon], [color], and [size].
  const IconProperty({this.icon, this.color, this.size});
}

/// Configuration for checkbox visual properties in multi-selection mode.
///
/// Maps directly to [Checkbox] widget properties, allowing full
/// customization of checkbox appearance including colors, shapes,
/// and interaction states.
class CheckBoxProperty {
  /// The cursor appearance when hovering over the checkbox.
  final MouseCursor? mouseCursor;

  /// The color of the checkbox when it is checked.
  final Color? activeColor;

  /// The fill color of the checkbox for each [WidgetState].
  final WidgetStateProperty<Color?>? fillColor;

  /// The color of the check mark inside the checkbox.
  final Color? checkColor;

  /// Whether the checkbox supports a third (indeterminate) state.
  final bool tristate;

  /// The target size for the checkbox's material tap area.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// The visual density of the checkbox.
  final VisualDensity? visualDensity;

  /// The color of the checkbox when it has input focus.
  final Color? focusColor;

  /// The color of the checkbox when the user hovers over it.
  final Color? hoverColor;

  /// The overlay color for each [WidgetState] of the checkbox.
  final WidgetStateProperty<Color?>? overlayColor;

  /// The splash radius of the checkbox's ink ripple effect.
  final double? splashRadius;

  /// The [FocusNode] for the checkbox.
  final FocusNode? focusNode;

  /// Whether the checkbox should autofocus.
  final bool autofocus;

  /// The shape of the checkbox.
  final OutlinedBorder? shape;

  /// The border side of the checkbox.
  final BorderSide? side;

  /// The default width of a checkbox in logical pixels.
  static const double width = 18.0;

  /// Creates a [CheckBoxProperty] with optional customization of
  /// all checkbox visual and interaction properties.
  const CheckBoxProperty({
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
  });
}

/// A Material 3 styled dropdown text field with single and multi-selection.
///
/// Features:
/// * Single selection with optional search filtering
/// * Multi-selection via checkboxes with a submit button
/// * Controller-based state management using
///   [SingleValueDropDownController] or [MultiValueDropDownController]
/// * RTL and dark mode support via Material 3 theming
/// * Tooltip messages per dropdown item
/// * Customizable icons, colors, and checkbox properties
///
/// Use the default constructor for single-selection mode:
/// ```dart
/// DropDownTextField(
///   dropDownList: dropDownList,
///   controller: SingleValueDropDownController(),
/// )
/// ```
///
/// Use [DropDownTextField.multiSelection] for multi-selection mode:
/// ```dart
/// DropDownTextField.multiSelection(
///   dropDownList: dropDownList,
///   controller: MultiValueDropDownController(),
/// )
/// ```
class DropDownTextField extends StatefulWidget {
  /// Creates a single-selection [DropDownTextField].
  ///
  /// The [dropDownList] is required. Provide either [initialValue] or a
  /// [SingleValueDropDownController] to set the initial selection, but
  /// not both.
  ///
  /// When [readOnly] is true (default) and [enableSearch] is true, an
  /// assertion error is thrown because the two modes conflict.
  const DropDownTextField({
    super.key,
    this.controller,
    this.initialValue,
    required this.dropDownList,
    this.padding,
    this.textStyle,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.enableSearch = false,
    this.readOnly = true,
    this.dropdownRadius = 12,
    this.textFieldDecoration,
    this.dropDownIconProperty,
    this.dropDownItemCount = 6,
    this.searchTextStyle,
    this.searchFocusNode,
    this.textFieldFocusNode,
    this.searchAutofocus = false,
    this.searchDecoration,
    this.searchShowCursor,
    this.searchKeyboardType,
    this.listSpace = 0,
    this.clearOption = true,
    this.clearIconProperty,
    this.listPadding,
    this.listTextStyle,
    this.keyboardType,
    this.autovalidateMode,
    this.dropdownColor,
  }) : assert(
         !(initialValue != null && controller != null),
         "you cannot add both initialValue and singleController,\nset initial value using controller\n\tEg: SingleValueDropDownController(data:initial value) ",
       ),
       assert(
         !(!readOnly && enableSearch),
         "readOnly!=true or enableSearch=true both condition does not work",
       ),
       assert(
         !(controller != null && controller is! SingleValueDropDownController),
         "controller must be type of SingleValueDropDownController",
       ),
       checkBoxProperty = null,
       isMultiSelection = false,
       singleController = controller,
       multiController = null,
       displayCompleteItem = false,
       submitButtonColor = null,
       submitButtonText = null,
       submitButtonTextStyle = null;

  /// Creates a multi-selection [DropDownTextField].
  ///
  /// The [dropDownList] is required. Provide either [initialValue] or a
  /// [MultiValueDropDownController] to set the initial selection, but
  /// not both.
  ///
  /// Multi-selection mode shows each item with a [Checkbox] and a
  /// submit button. The [checkBoxProperty] allows customizing the
  /// checkboxes, and [submitButtonColor], [submitButtonText], and
  /// [submitButtonTextStyle] customize the submit button.
  const DropDownTextField.multiSelection({
    super.key,
    this.controller,
    this.displayCompleteItem = false,
    this.initialValue,
    required this.dropDownList,
    this.padding,
    this.textStyle,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.dropdownRadius = 12,
    this.dropDownIconProperty,
    this.textFieldDecoration,
    this.dropDownItemCount = 6,
    this.searchFocusNode,
    this.textFieldFocusNode,
    this.listSpace = 0,
    this.clearOption = true,
    this.clearIconProperty,
    this.submitButtonColor,
    this.submitButtonText,
    this.submitButtonTextStyle,
    this.listPadding,
    this.listTextStyle,
    this.checkBoxProperty,
    this.autovalidateMode,
    this.dropdownColor,
  }) : assert(
         initialValue == null || controller == null,
         "you cannot add both initialValue and multiController\nset initial value using controller\n\tMultiValueDropDownController(data:initial value)",
       ),
       assert(
         !(controller != null && controller is! MultiValueDropDownController),
         "controller must be type of MultiValueDropDownController",
       ),
       multiController = controller,
       isMultiSelection = true,
       enableSearch = false,
       readOnly = true,
       searchTextStyle = null,
       searchAutofocus = false,
       searchKeyboardType = null,
       searchShowCursor = null,
       singleController = null,
       searchDecoration = null,
       keyboardType = null;

  /// The controller for the dropdown.
  ///
  /// Must be a [SingleValueDropDownController] for single-selection
  /// mode or a [MultiValueDropDownController] for multi-selection mode.
  final dynamic controller;

  /// The internal controller used for single-selection mode.
  ///
  /// This is extracted from [controller] in the default constructor.
  final SingleValueDropDownController? singleController;

  /// The internal controller used for multi-selection mode.
  ///
  /// This is extracted from [controller] in the [multiSelection] constructor.
  final MultiValueDropDownController? multiController;

  /// The border radius of the dropdown overlay.
  final double dropdownRadius;

  /// The initial value(s) for the dropdown.
  ///
  /// Should be a [String] for single-selection or a [List<String>]
  /// for multi-selection. Cannot be used together with [controller].
  final dynamic initialValue;

  /// The list of items displayed in the dropdown.
  final List<DropDownValueModel> dropDownList;

  /// Callback invoked when the dropdown value changes.
  ///
  /// Receives the selected [DropDownValueModel] for single-selection
  /// or a [List<DropDownValueModel>] for multi-selection.
  final ValueSetter? onChanged;

  /// Whether this dropdown is in multi-selection mode.
  final bool isMultiSelection;

  /// The text style applied to the text field.
  final TextStyle? textStyle;

  /// The padding around the text field content.
  final EdgeInsets? padding;

  /// The decoration for the text field.
  ///
  /// When null, a default [InputDecoration] with a hint text
  /// and suffix icon is used.
  final InputDecoration? textFieldDecoration;

  /// Custom properties for the dropdown arrow icon.
  final IconProperty? dropDownIconProperty;

  /// Whether the text field is enabled.
  final bool isEnabled;

  /// The validator function for the text field.
  final FormFieldValidator<String>? validator;

  /// Whether the search field is shown above the dropdown list.
  ///
  /// Only applies in single-selection mode. Requires [readOnly] to be
  /// false when enabled.
  final bool enableSearch;

  /// Whether the text field is read-only.
  ///
  /// When true, users can only select from the dropdown. When false,
  /// users can type custom values.
  final bool readOnly;

  /// Whether to display complete item names in multi-selection mode.
  ///
  /// When true, selected item names are joined with commas instead
  /// of showing a count string like "2 item selected".
  final bool displayCompleteItem;

  /// The maximum number of items visible in the dropdown list before scrolling.
  final int dropDownItemCount;

  /// The [FocusNode] for the search text field.
  final FocusNode? searchFocusNode;

  /// The [FocusNode] for the main text field.
  final FocusNode? textFieldFocusNode;

  /// The text style applied to the search input field.
  final TextStyle? searchTextStyle;

  /// The decoration for the search text field.
  final InputDecoration? searchDecoration;

  /// The keyboard type for the search input.
  final TextInputType? searchKeyboardType;

  /// Whether the search field should autofocus when the dropdown opens.
  final bool searchAutofocus;

  /// Whether to show the cursor in the search field.
  final bool? searchShowCursor;

  /// Whether a clear button is shown when the text field has a value.
  final bool clearOption;

  /// Custom properties for the clear icon button.
  final IconProperty? clearIconProperty;

  /// The vertical space between the text field and the dropdown list.
  final double listSpace;

  /// Padding configuration for dropdown list items.
  final ListPadding? listPadding;

  /// The text displayed on the multi-selection submit button.
  final String? submitButtonText;

  /// The background color of the multi-selection submit button.
  final Color? submitButtonColor;

  /// The text style of the multi-selection submit button label.
  final TextStyle? submitButtonTextStyle;

  /// The text style applied to dropdown list items.
  final TextStyle? listTextStyle;

  /// The keyboard type for the main text field in single-selection mode.
  final TextInputType? keyboardType;

  /// The auto-validation mode for the form field.
  final AutovalidateMode? autovalidateMode;

  /// Custom properties for the checkboxes in multi-selection mode.
  final CheckBoxProperty? checkBoxProperty;

  /// The background color of the dropdown overlay.
  final Color? dropdownColor;

  @override
  DropDownTextFieldState createState() => DropDownTextFieldState();
}

/// The state class for [DropDownTextField].
///
/// Manages the dropdown overlay lifecycle, including opening and closing
/// the list, animating expansion, handling keyboard and scroll interactions,
/// and coordinating with [SingleValueDropDownController] or
/// [MultiValueDropDownController] listeners.
class DropDownTextFieldState extends State<DropDownTextField>
    with TickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(
    curve: Curves.easeIn,
  );

  late TextEditingController _cnt;
  late String _hintText;

  late bool _isExpanded;
  OverlayEntry? _entry;
  OverlayEntry? _entry2;
  OverlayEntry? _barrierOverlay;
  final _layerLink = LayerLink();
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  List<bool> _multiSelectionValue = [];
  late double _height;
  late List<DropDownValueModel> _dropDownList;
  late int _maxListItem;
  late double _searchWidgetHeight;
  late FocusNode _searchFocusNode;
  late FocusNode _textFieldFocusNode;
  late bool _isOutsideClickOverlay;
  late bool _isScrollPadding;
  final int _duration = 150;
  late Offset _offset;
  late bool _searchAutofocus;
  late bool _isPortrait;
  late double _listTileHeight;
  late double _keyboardHeight;
  late TextStyle _listTileTextStyle;
  late ListPadding _listPadding;
  late TextDirection _currentDirection;

  /// A global key assigned to the dropdown overlay for hit-testing.
  GlobalKey overlayKey = GlobalKey();

  void Function()? _onSingleControllerChanged;
  void Function()? _onMultiControllerChanged;
  @override
  void initState() {
    _cnt = TextEditingController();
    _keyboardHeight = 450;
    _searchAutofocus = false;
    _isScrollPadding = false;
    _isOutsideClickOverlay = false;
    _searchFocusNode = widget.searchFocusNode ?? FocusNode();
    _textFieldFocusNode = widget.textFieldFocusNode ?? FocusNode();
    _isExpanded = false;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _duration),
    );
    _heightFactor = _controller.drive(_easeInTween);
    _searchWidgetHeight = 60;
    _hintText = "Select Item";
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus &&
          !_textFieldFocusNode.hasFocus &&
          _isExpanded &&
          !widget.isMultiSelection) {
        _isExpanded = !_isExpanded;
        hideOverlay();
      }
    });
    _textFieldFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus &&
          !_textFieldFocusNode.hasFocus &&
          _isExpanded) {
        _isExpanded = !_isExpanded;
        hideOverlay();
        if (!widget.readOnly &&
            widget.singleController?.dropDownValue?.name != _cnt.text) {
          setState(() {
            _cnt.clear();
          });
        }
      }
    });
    if (widget.singleController != null) {
      _onSingleControllerChanged = () {
        if (widget.singleController?.dropDownValue == null) {
          clearFun();
        }
      };
      widget.singleController!.addListener(_onSingleControllerChanged!);
    }
    if (widget.multiController != null) {
      _onMultiControllerChanged = () {
        if (widget.multiController?.dropDownValueList == null) {
          clearFun();
        }
      };
      widget.multiController!.addListener(_onMultiControllerChanged!);
    }
    for (int i = 0; i < widget.dropDownList.length; i++) {
      _multiSelectionValue.add(false);
    }

    if (widget.initialValue != null) {
      _dropDownList = List.from(widget.dropDownList);
      if (widget.isMultiSelection) {
        for (int i = 0; i < widget.initialValue.length; i++) {
          var index = _dropDownList.indexWhere(
            (element) => element.name.trim() == widget.initialValue[i].trim(),
          );
          if (index != -1) {
            _multiSelectionValue[index] = true;
          }
        }
        int count = _multiSelectionValue
            .where((element) => element)
            .toList()
            .length;

        _cnt.text = (count == 0
            ? ""
            : widget.displayCompleteItem
            ? (widget.initialValue ?? []).join(",")
            : "$count item selected");
      } else {
        var index = _dropDownList.indexWhere(
          (element) => element.name.trim() == widget.initialValue.trim(),
        );

        if (index != -1) {
          _cnt.text = widget.initialValue;
        }
      }
    }

    updateFunction();
    super.initState();
  }

  Size _textWidgetSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  /// Updates the internal state when the widget configuration changes.
  ///
  /// Called during [initState] and [didUpdateWidget] to synchronize
  /// the internal dropdown list, multi-selection values, and computed
  /// dimensions (list tile height, max list items, and total height)
  /// with the current [DropDownTextField] widget properties.
  void updateFunction({DropDownTextField? oldWidget}) {
    Function eq = const DeepCollectionEquality().equals;
    _dropDownList = List.from(widget.dropDownList);
    _listPadding = widget.listPadding ?? ListPadding();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isMultiSelection) {
        if (oldWidget != null && !eq(oldWidget.dropDownList, _dropDownList)) {
          _multiSelectionValue = [];
          _cnt.text = "";
          for (int i = 0; i < _dropDownList.length; i++) {
            _multiSelectionValue.add(false);
          }
        }

        if (widget.multiController != null) {
          if (oldWidget != null &&
              oldWidget.multiController?.dropDownValueList != null) {}
          if (widget.multiController?.dropDownValueList != null) {
            _multiSelectionValue = [];
            for (int i = 0; i < _dropDownList.length; i++) {
              _multiSelectionValue.add(false);
            }
            for (
              int i = 0;
              i < widget.multiController!.dropDownValueList!.length;
              i++
            ) {
              var index = _dropDownList.indexWhere(
                (element) =>
                    element == widget.multiController!.dropDownValueList![i],
              );
              if (index != -1) {
                _multiSelectionValue[index] = true;
              }
            }

            if (oldWidget?.displayCompleteItem != widget.displayCompleteItem) {
              List<String> names =
                  (widget.multiController?.dropDownValueList ?? [])
                      .map((dataModel) => dataModel.name)
                      .toList();

              int count = _multiSelectionValue
                  .where((element) => element)
                  .toList()
                  .length;
              _cnt.text = (count == 0
                  ? ""
                  : widget.displayCompleteItem
                  ? names.join(",")
                  : "$count item selected");
            }
          } else {
            _multiSelectionValue = [];
            _cnt.text = "";
            for (int i = 0; i < _dropDownList.length; i++) {
              _multiSelectionValue.add(false);
            }
          }
        }
      } else {
        if (widget.singleController != null) {
          if (widget.singleController!.dropDownValue != null) {
            _cnt.text = widget.singleController!.dropDownValue!.name;
          } else {
            _cnt.clear();
          }
        }
      }

      _listTileTextStyle =
          (widget.listTextStyle ?? Theme.of(context).textTheme.titleMedium)!;
      _listTileHeight =
          _textWidgetSize("dummy Text", _listTileTextStyle).height +
          _listPadding.top +
          _listPadding.bottom +
          3;
      _maxListItem = widget.dropDownItemCount;

      _height =
          (!widget.isMultiSelection
              ? (_dropDownList.length < _maxListItem
                    ? _dropDownList.length * _listTileHeight
                    : _listTileHeight * _maxListItem.toDouble())
              : _dropDownList.length < _maxListItem
              ? _dropDownList.length * _listTileHeight
              : _listTileHeight * _maxListItem.toDouble()) +
          10;
    });
  }

  @override
  void didUpdateWidget(covariant DropDownTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Remove old listeners if controllers changed
    if (oldWidget.singleController != widget.singleController) {
      if (oldWidget.singleController != null &&
          _onSingleControllerChanged != null) {
        oldWidget.singleController!.removeListener(_onSingleControllerChanged!);
      }
      if (widget.singleController != null) {
        _onSingleControllerChanged = () {
          if (widget.singleController?.dropDownValue == null) {
            clearFun();
          }
        };
        widget.singleController!.addListener(_onSingleControllerChanged!);
      } else {
        _onSingleControllerChanged = null;
      }
    }

    if (oldWidget.multiController != widget.multiController) {
      if (oldWidget.multiController != null &&
          _onMultiControllerChanged != null) {
        oldWidget.multiController!.removeListener(_onMultiControllerChanged!);
      }
      if (widget.multiController != null) {
        _onMultiControllerChanged = () {
          if (widget.multiController?.dropDownValueList == null) {
            clearFun();
          }
        };
        widget.multiController!.addListener(_onMultiControllerChanged!);
      } else {
        _onMultiControllerChanged = null;
      }
    }

    updateFunction(oldWidget: oldWidget);
  }

  @override
  void dispose() {
    // Remove controller listeners
    if (widget.singleController != null && _onSingleControllerChanged != null) {
      widget.singleController!.removeListener(_onSingleControllerChanged!);
    }
    if (widget.multiController != null && _onMultiControllerChanged != null) {
      widget.multiController!.removeListener(_onMultiControllerChanged!);
    }

    if (_entry != null && _entry!.mounted) {
      _entry?.remove();
    }
    _entry = null;
    if (_entry2 != null && _entry2!.mounted) {
      _entry2?.remove();
    }
    _entry2 = null;
    if (_barrierOverlay != null && _barrierOverlay!.mounted) {
      _barrierOverlay?.remove();
      _barrierOverlay = null;
    }

    if (widget.searchFocusNode == null) _searchFocusNode.dispose();
    if (widget.textFieldFocusNode == null) _textFieldFocusNode.dispose();
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.dispose();
    _cnt.dispose();
    super.dispose();
  }

  /// Clears the current selection and resets the dropdown state.
  ///
  /// Clears the text field, resets multi-selection values, and
  /// notifies the controller and [onChanged] callback. If the
  /// dropdown overlay is open, it is closed.
  void clearFun() {
    if (_isExpanded) {
      _isExpanded = !_isExpanded;
      hideOverlay();
    }
    _cnt.clear();
    if (widget.isMultiSelection) {
      if (widget.multiController != null) {
        widget.multiController!.clearDropDown();
      }
      if (widget.onChanged != null) {
        widget.onChanged!([]);
      }

      _multiSelectionValue = [];
      for (int i = 0; i < _dropDownList.length; i++) {
        _multiSelectionValue.add(false);
      }
    } else {
      if (widget.singleController != null) {
        widget.singleController!.clearDropDown();
      }
      if (widget.onChanged != null) {
        widget.onChanged!("");
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _currentDirection = Directionality.of(context);
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (!isKeyboardVisible && _isExpanded && _isScrollPadding) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            shiftOverlayEntry2to1();
          });
        }
        return CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: _cnt,
            focusNode: _textFieldFocusNode,
            keyboardType: widget.keyboardType,
            autovalidateMode: widget.autovalidateMode,
            style: widget.textStyle,
            enabled: widget.isEnabled,
            readOnly: widget.readOnly,
            onTapOutside: (event) {
              final renderBox =
                  overlayKey.currentContext?.findRenderObject() as RenderBox?;
              if (renderBox == null) return;
              final overlayPosition = renderBox.localToGlobal(Offset.zero);
              final overlaySize = renderBox.size;
              bool isOverlayTap =
                  (overlayPosition.dx <= event.position.dx &&
                      event.position.dx <=
                          overlayPosition.dx + overlaySize.width) &&
                  (overlayPosition.dy <= event.position.dy &&
                      event.position.dy <=
                          overlayPosition.dy + overlaySize.height);

              if (!isOverlayTap) {
                _textFieldFocusNode.unfocus();
              }
            },
            onTap: () {
              _searchAutofocus = widget.searchAutofocus;
              if (!_isExpanded) {
                if (_dropDownList.isNotEmpty) {
                  _showOverlay();
                }
              } else {
                if (widget.readOnly) hideOverlay();
              }
            },
            validator: (value) =>
                widget.validator != null ? widget.validator!(value) : null,
            decoration: widget.textFieldDecoration != null
                ? widget.textFieldDecoration!.copyWith(
                    suffixIcon: (_cnt.text.isEmpty || !widget.clearOption)
                        ? Icon(
                            widget.dropDownIconProperty?.icon ??
                                Icons.arrow_drop_down_outlined,
                            size: widget.dropDownIconProperty?.size,
                            color: widget.dropDownIconProperty?.color,
                          )
                        : widget.clearOption
                        ? InkWell(
                            onTap: clearFun,
                            child: Icon(
                              widget.clearIconProperty?.icon ?? Icons.clear,
                              size: widget.clearIconProperty?.size,
                              color: widget.clearIconProperty?.color,
                            ),
                          )
                        : null,
                  )
                : InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: _hintText,
                    hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                    suffixIcon: (_cnt.text.isEmpty || !widget.clearOption)
                        ? Icon(
                            widget.dropDownIconProperty?.icon ??
                                Icons.arrow_drop_down_outlined,
                            size: widget.dropDownIconProperty?.size,
                            color: widget.dropDownIconProperty?.color,
                          )
                        : widget.clearOption
                        ? InkWell(
                            onTap: clearFun,
                            child: Icon(
                              widget.clearIconProperty?.icon ?? Icons.clear,
                              size: widget.clearIconProperty?.size,
                              color: widget.clearIconProperty?.color,
                            ),
                          )
                        : null,
                  ),
          ),
        );
      },
    );
  }

  Future<void> _showOverlay() async {
    // Remove any stale overlay entries before creating new ones
    if (_entry != null && _entry!.mounted) {
      _entry?.remove();
    }
    _entry = null;
    if (_entry2 != null && _entry2!.mounted) {
      _entry2?.remove();
    }
    _entry2 = null;
    if (_barrierOverlay != null && _barrierOverlay!.mounted) {
      _barrierOverlay?.remove();
      _barrierOverlay = null;
    }
    overlayKey = GlobalKey();
    _controller.forward();
    _isExpanded = true;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _offset = renderBox.localToGlobal(Offset.zero);
    double posFromTop = _offset.dy;
    double posFromBot = MediaQuery.of(context).size.height - posFromTop;

    double dropdownListHeight =
        _height +
        (widget.enableSearch ? _searchWidgetHeight : 0) +
        widget.listSpace;
    double ht = dropdownListHeight + 120;
    if (_searchAutofocus &&
        !(posFromBot < ht) &&
        posFromBot < _keyboardHeight &&
        !_isScrollPadding &&
        _isPortrait) {
      _isScrollPadding = true;
    }
    _isOutsideClickOverlay =
        _isScrollPadding ||
        (widget.readOnly &&
            dropdownListHeight >
                (posFromTop - MediaQuery.of(context).padding.top - 15) &&
            posFromBot < ht);
    final double topPaddingHeight = _isOutsideClickOverlay
        ? (dropdownListHeight -
              (posFromTop - MediaQuery.of(context).padding.top - 15))
        : 0;

    final double htPos = posFromBot < ht
        ? size.height - 100 + topPaddingHeight
        : _isScrollPadding
        ? size.height - (_keyboardHeight - posFromBot)
        : size.height;
    if (_isOutsideClickOverlay) {
      _openOutSideClickOverlay(context);
    }
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          targetAnchor: posFromBot < ht
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          followerAnchor: posFromBot < ht
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
            0,
            posFromBot < ht
                ? htPos - widget.listSpace
                : htPos + widget.listSpace,
          ),
          child: AnimatedBuilder(
            animation: _controller.view,
            builder: buildOverlay,
          ),
        ),
      ),
    );
    _entry2 = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          targetAnchor: Alignment.bottomCenter,
          followerAnchor: Alignment.bottomCenter,
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, htPos),
          child: AnimatedBuilder(
            animation: _controller.view,
            builder: buildOverlay,
          ),
        ),
      ),
    );
    overlay.insert(_isScrollPadding ? _entry2! : _entry!);
  }

  void _openOutSideClickOverlay(BuildContext context) {
    final overlay2 = Overlay.of(context);
    _barrierOverlay = OverlayEntry(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return GestureDetector(
          onTap: () {
            hideOverlay();
          },
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.transparent,
          ),
        );
      },
    );
    overlay2.insert(_barrierOverlay!);
  }

  /// Hides the dropdown overlay with a reverse animation.
  ///
  /// Removes all overlay entries ([_entry], [_entry2], and the barrier
  /// overlay) after the close animation completes. Also unfocuses the
  /// text field.
  void hideOverlay() {
    _controller.reverse().then<void>((void value) {
      if (_entry != null && _entry!.mounted) {
        _entry?.remove();
        _entry = null;
      }
      if (_entry2 != null && _entry2!.mounted) {
        _entry2?.remove();
        _entry2 = null;
      }

      if (_barrierOverlay != null && _barrierOverlay!.mounted) {
        _barrierOverlay?.remove();
        _barrierOverlay = null;
        _isOutsideClickOverlay = false;
      }
      _isScrollPadding = false;
      _isExpanded = false;
    });
    _textFieldFocusNode.unfocus();
  }

  /// Shifts the dropdown overlay from entry 1 (normal positioning)
  /// to entry 2 (scroll-padded positioning).
  ///
  /// Used when the keyboard appears and the dropdown needs to be
  /// repositioned to stay visible.
  void shiftOverlayEntry1to2() {
    _entry?.remove();
    _entry = null;
    if (_barrierOverlay != null && _barrierOverlay!.mounted) {
      _barrierOverlay?.remove();
      _barrierOverlay = null;
      _isOutsideClickOverlay = false;
    }
    _isScrollPadding = true;
    _showOverlay();
    _textFieldFocusNode.requestFocus();

    Future.delayed(Duration(milliseconds: _duration), () {
      _searchFocusNode.requestFocus();
    });
  }

  /// Shifts the dropdown overlay from entry 2 (scroll-padded positioning)
  /// back to entry 1 (normal positioning).
  ///
  /// Used when the keyboard is dismissed and the dropdown can return
  /// to its original position.
  void shiftOverlayEntry2to1() {
    _searchAutofocus = false;
    _entry2?.remove();
    _entry2 = null;
    if (_barrierOverlay != null && _barrierOverlay!.mounted) {
      _barrierOverlay?.remove();
      _barrierOverlay = null;
      _isOutsideClickOverlay = false;
    }
    _controller.reset();
    _isScrollPadding = false;
    _showOverlay();
    _textFieldFocusNode.requestFocus();
  }

  /// Builds the dropdown overlay content.
  ///
  /// Wraps either a [SingleSelection] or [MultiSelection] widget
  /// inside a styled container with the dropdown color, border radius,
  /// and shadow. The overlay is clipped and animated via the expansion
  /// height factor. Respects the current text direction for RTL support.
  Widget buildOverlay(BuildContext context, Widget? child) {
    return Directionality(
      textDirection: _currentDirection,
      child: ClipRect(
        child: Align(
          heightFactor: _heightFactor.value,
          child: Material(
            key: overlayKey,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      widget.dropdownColor ??
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.dropdownRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: !widget.isMultiSelection
                    ? SingleSelection(
                        mainController: _cnt,
                        autoSort: !widget.readOnly,
                        mainFocusNode: _textFieldFocusNode,
                        searchTextStyle: widget.searchTextStyle,
                        searchFocusNode: _searchFocusNode,
                        enableSearch: widget.enableSearch,
                        height: _height,
                        listTileHeight: _listTileHeight,
                        dropDownList: _dropDownList,
                        listTextStyle: _listTileTextStyle,
                        onChanged: (item) {
                          setState(() {
                            _cnt.text = item.name;
                            _isExpanded = !_isExpanded;
                          });
                          if (widget.singleController != null) {
                            widget.singleController!.setDropDown(item);
                          }
                          if (widget.onChanged != null) {
                            widget.onChanged!(item);
                          }

                          hideOverlay();
                        },
                        searchHeight: _searchWidgetHeight,
                        searchKeyboardType: widget.searchKeyboardType,
                        searchAutofocus: _searchAutofocus,
                        searchDecoration: widget.searchDecoration,
                        searchShowCursor: widget.searchShowCursor,
                        listPadding: _listPadding,
                        clearIconProperty: widget.clearIconProperty,
                      )
                    : MultiSelection(
                        buttonTextStyle: widget.submitButtonTextStyle,
                        buttonText: widget.submitButtonText,
                        buttonColor: widget.submitButtonColor,
                        height: _height,
                        listTileHeight: _listTileHeight,
                        list: _multiSelectionValue,
                        dropDownList: _dropDownList,
                        listTextStyle: _listTileTextStyle,
                        listPadding: _listPadding,
                        onChanged: (val) {
                          _isExpanded = !_isExpanded;
                          _multiSelectionValue = val;
                          List<DropDownValueModel> result = [];
                          List completeList = [];
                          for (
                            int i = 0;
                            i < _multiSelectionValue.length;
                            i++
                          ) {
                            if (_multiSelectionValue[i]) {
                              result.add(_dropDownList[i]);
                              completeList.add(_dropDownList[i].name);
                            }
                          }
                          int count = _multiSelectionValue
                              .where((element) => element)
                              .toList()
                              .length;

                          _cnt.text = (count == 0
                              ? ""
                              : widget.displayCompleteItem
                              ? completeList.join(",")
                              : "$count item selected");
                          if (widget.multiController != null) {
                            widget.multiController!.setDropDown(
                              result.isNotEmpty ? result : null,
                            );
                          }
                          if (widget.onChanged != null) {
                            widget.onChanged!(result);
                          }

                          hideOverlay();

                          setState(() {});
                        },
                        checkBoxProperty: widget.checkBoxProperty,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A data model representing a single item in the dropdown list.
///
/// Each item has a display [name], an associated [value], and an
/// optional [toolTipMsg] shown as an info icon in multi-selection mode.
class DropDownValueModel extends Equatable {
  /// The display name shown in the dropdown list.
  final String name;

  /// The associated value for this dropdown item.
  final dynamic value;

  /// An optional tooltip message shown next to the item name
  /// in multi-selection mode.
  final String? toolTipMsg;

  /// Creates a [DropDownValueModel] with the given [name] and [value],
  /// and an optional [toolTipMsg].
  const DropDownValueModel({
    required this.name,
    required this.value,
    this.toolTipMsg,
  });

  /// Creates a [DropDownValueModel] from a JSON map.
  factory DropDownValueModel.fromJson(Map<String, dynamic> json) =>
      DropDownValueModel(
        name: json["name"],
        value: json["value"],
        toolTipMsg: json["toolTipMsg"],
      );

  /// Converts this [DropDownValueModel] to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
    "toolTipMsg": toolTipMsg,
  };
  @override
  List<Object> get props => [name, value];
}

/// A controller for single-selection dropdown state.
///
/// Extends [ChangeNotifier] so that listeners are notified when the
/// selection changes. Use with [DropDownTextField] in single-selection mode.
///
/// ```dart
/// final controller = SingleValueDropDownController(
///   data: DropDownValueModel(name: 'Option 1', value: 1),
/// );
/// ```
class SingleValueDropDownController extends ChangeNotifier {
  /// The currently selected dropdown item, or null if nothing is selected.
  DropDownValueModel? dropDownValue;

  /// Creates a [SingleValueDropDownController] with an optional
  /// initial [data] value.
  SingleValueDropDownController({DropDownValueModel? data}) {
    setDropDown(data);
  }

  /// Sets the selected [DropDownValueModel] and notifies listeners.
  ///
  /// If [model] is the same as the current value, no notification is sent.
  void setDropDown(DropDownValueModel? model) {
    if (dropDownValue != model) {
      dropDownValue = model;
      notifyListeners();
    }
  }

  /// Clears the selection and notifies listeners.
  ///
  /// If no value is currently selected, no notification is sent.
  void clearDropDown() {
    if (dropDownValue != null) {
      dropDownValue = null;
      notifyListeners();
    }
  }
}

/// A controller for multi-selection dropdown state.
///
/// Extends [ChangeNotifier] so that listeners are notified when the
/// selection changes. Duplicate values are automatically filtered out.
/// Use with [DropDownTextField] in multi-selection mode.
///
/// ```dart
/// final controller = MultiValueDropDownController(
///   data: [DropDownValueModel(name: 'Option 1', value: 1)],
/// );
/// ```
class MultiValueDropDownController extends ChangeNotifier {
  /// The list of currently selected dropdown items, or null if none selected.
  List<DropDownValueModel>? dropDownValueList;

  /// Creates a [MultiValueDropDownController] with an optional
  /// initial [data] list.
  MultiValueDropDownController({List<DropDownValueModel>? data}) {
    setDropDown(data);
  }

  /// Sets the selected list of [DropDownValueModel] items and notifies
  /// listeners.
  ///
  /// Duplicate items in [modelList] are removed. If the resulting list
  /// is equal to the current selection (using unordered deep equality),
  /// no notification is sent.
  void setDropDown(List<DropDownValueModel>? modelList) {
    List<DropDownValueModel>? lst;
    if (modelList != null && modelList.isNotEmpty) {
      List<DropDownValueModel> list = [];
      for (DropDownValueModel item in modelList) {
        if (!list.contains(item)) {
          list.add(item);
        }
      }
      lst = list;
    }
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;

    if (!unOrdDeepEq(lst, dropDownValueList)) {
      dropDownValueList = lst;
      notifyListeners();
    }
  }

  /// Clears all selections and notifies listeners.
  ///
  /// If no items are currently selected, no notification is sent.
  void clearDropDown() {
    if (dropDownValueList != null) {
      dropDownValueList = null;
      notifyListeners();
    }
  }
}

/// Configuration for vertical padding of list items in the dropdown.
class ListPadding {
  /// The top padding applied to each list tile.
  final double top;

  /// The bottom padding applied to each list tile.
  final double bottom;

  /// Creates a [ListPadding] with the given [top] and [bottom] values.
  ///
  /// Defaults to 15.0 for both.
  const ListPadding({this.top = 15, this.bottom = 15});
}

/// A widget that rebuilds when keyboard visibility changes.
///
/// Uses [WidgetsBindingObserver] to monitor [MediaQuery.viewInsets]
/// and calls the [builder] function with the current keyboard state.
/// This allows the dropdown to reposition itself when the keyboard
/// appears or disappears.
class KeyboardVisibilityBuilder extends StatefulWidget {
  /// The builder function called with the current keyboard visibility state.
  ///
  /// [isKeyboardVisible] is true when the on-screen keyboard is open.
  final Widget Function(BuildContext context, bool isKeyboardVisible) builder;

  /// Creates a [KeyboardVisibilityBuilder] with the required [builder].
  const KeyboardVisibilityBuilder({super.key, required this.builder});

  @override
  KeyboardVisibilityBuilderState createState() =>
      KeyboardVisibilityBuilderState();
}

/// The state class for [KeyboardVisibilityBuilder].
///
/// Listens to metrics changes via [WidgetsBindingObserver] and
/// updates [isKeyboardVisible] based on [MediaQuery.viewInsets.bottom].
class KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _isKeyboardVisible);
}
