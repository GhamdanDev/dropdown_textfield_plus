import 'package:dropdown_textfield_plus/dropdown_textfield_plus.dart';
import 'package:flutter/material.dart';

import 'tooltip_widget.dart';

/// The dropdown list widget used in multi-selection mode.
///
/// Displays a scrollable list of [DropDownValueModel] items, each
/// accompanied by a [Checkbox]. A submit button at the bottom confirms
/// the selection and calls [onChanged]. Items with a non-null
/// [DropDownValueModel.toolTipMsg] show a [ToolTipWidget] next to
/// their label.
class MultiSelection extends StatefulWidget {
  /// Creates a [MultiSelection] widget.
  ///
  /// The [onChanged], [dropDownList], [list], [height], [listTileHeight],
  /// and [listPadding] parameters are required.
  const MultiSelection({
    super.key,
    required this.onChanged,
    required this.dropDownList,
    required this.list,
    required this.height,
    this.buttonColor,
    this.buttonText,
    this.buttonTextStyle,
    required this.listTileHeight,
    required this.listPadding,
    this.listTextStyle,
    this.checkBoxProperty,
  });

  /// The list of dropdown items to display.
  final List<DropDownValueModel> dropDownList;

  /// Callback invoked when the submit button is pressed with selected items.
  final ValueSetter onChanged;

  /// The list of boolean values representing each item's checked state.
  final List<bool> list;

  /// The total height of the dropdown list area.
  final double height;

  /// The background color of the submit button.
  final Color? buttonColor;

  /// The text displayed on the submit button.
  final String? buttonText;

  /// The text style applied to the submit button label.
  final TextStyle? buttonTextStyle;

  /// The height of each list tile in the dropdown.
  final double listTileHeight;

  /// The text style applied to list item labels.
  final TextStyle? listTextStyle;

  /// Padding configuration for list items.
  final ListPadding listPadding;

  /// Custom properties applied to each [Checkbox] in the list.
  final CheckBoxProperty? checkBoxProperty;

  @override
  MultiSelectionState createState() => MultiSelectionState();
}

/// The state class for [MultiSelection].
///
/// Manages the local copy of checkbox selection states and
/// builds the list of checkable items with a submit button.
class MultiSelectionState extends State<MultiSelection> {
  /// The local list of boolean values tracking each item's checked state.
  List<bool> multiSelectionValue = [];

  @override
  void initState() {
    multiSelectionValue = List.from(widget.list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.dropDownList.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: widget.listTileHeight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: widget.listPadding.bottom,
                      top: widget.listPadding.top,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.dropDownList[index].name,
                                    style: widget.listTextStyle,
                                  ),
                                ),
                                if (widget.dropDownList[index].toolTipMsg !=
                                    null)
                                  ToolTipWidget(
                                    msg: widget.dropDownList[index].toolTipMsg!,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Checkbox(
                          value: multiSelectionValue[index],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                multiSelectionValue[index] = value;
                              });
                            }
                          },
                          tristate: widget.checkBoxProperty?.tristate ?? false,
                          mouseCursor: widget.checkBoxProperty?.mouseCursor,
                          activeColor: widget.checkBoxProperty?.activeColor,
                          fillColor: widget.checkBoxProperty?.fillColor,
                          checkColor: widget.checkBoxProperty?.checkColor,
                          focusColor: widget.checkBoxProperty?.focusColor,
                          hoverColor: widget.checkBoxProperty?.hoverColor,
                          overlayColor: widget.checkBoxProperty?.overlayColor,
                          splashRadius: widget.checkBoxProperty?.splashRadius,
                          materialTapTargetSize:
                              widget.checkBoxProperty?.materialTapTargetSize,
                          visualDensity: widget.checkBoxProperty?.visualDensity,
                          focusNode: widget.checkBoxProperty?.focusNode,
                          autofocus:
                              widget.checkBoxProperty?.autofocus ?? false,
                          shape: widget.checkBoxProperty?.shape,
                          side: widget.checkBoxProperty?.side,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
                left: 8.0,
                top: 15,
                bottom: 10,
              ),
              child: InkWell(
                onTap: () => widget.onChanged(multiSelectionValue),
                child: Container(
                  height: widget.listTileHeight * 0.9,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: widget.buttonColor ?? Colors.green,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Align(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.buttonText ?? "Ok",
                        style:
                            widget.buttonTextStyle ??
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
