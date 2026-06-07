import 'package:dropdown_textfield_plus/dropdown_textfield_plus.dart';
import 'package:flutter/material.dart';

/// The dropdown list widget used in single-selection mode.
///
/// Displays a scrollable list of [DropDownValueModel] items. When
/// [enableSearch] is true, a search text field is shown above the list
/// to filter options by name. Selecting an item calls [onChanged] and
/// closes the dropdown.
class SingleSelection extends StatefulWidget {
  /// Creates a [SingleSelection] widget.
  ///
  /// The [dropDownList], [onChanged], [height], [enableSearch],
  /// [searchHeight], [searchFocusNode], [mainFocusNode], [mainController],
  /// [autoSort], [listTileHeight], and [listPadding] parameters are required.
  const SingleSelection({
    super.key,
    required this.dropDownList,
    required this.onChanged,
    required this.height,
    required this.enableSearch,
    required this.searchHeight,
    this.searchTextStyle,
    required this.searchFocusNode,
    required this.mainFocusNode,
    this.searchKeyboardType,
    required this.searchAutofocus,
    this.searchShowCursor,
    required this.mainController,
    required this.autoSort,
    required this.listTileHeight,
    this.onSearchTap,
    this.onSearchSubmit,
    this.listTextStyle,
    this.searchDecoration,
    required this.listPadding,
    this.clearIconProperty,
  });

  /// The list of dropdown items to display.
  final List<DropDownValueModel> dropDownList;

  /// Callback invoked when a dropdown item is selected.
  final ValueSetter onChanged;

  /// The total height of the dropdown list area.
  final double height;

  /// The height of each list tile in the dropdown.
  final double listTileHeight;

  /// Whether the search field is enabled above the list.
  final bool enableSearch;

  /// The height of the search widget area.
  final double searchHeight;

  /// The text style applied to the search input.
  final TextStyle? searchTextStyle;

  /// The [FocusNode] for the search text field.
  final FocusNode searchFocusNode;

  /// The [FocusNode] for the main dropdown text field.
  final FocusNode mainFocusNode;

  /// The keyboard type for the search input.
  final TextInputType? searchKeyboardType;

  /// Whether the search field should autofocus when the dropdown opens.
  final bool searchAutofocus;

  /// Whether to show the cursor in the search field.
  final bool? searchShowCursor;

  /// The controller for the main text field, used for auto-sort filtering.
  final TextEditingController mainController;

  /// Whether to auto-sort/filter the list when the main controller text changes.
  final bool autoSort;

  /// Callback invoked when the search field is tapped.
  final Function? onSearchTap;

  /// Callback invoked when the search field submits a value.
  final Function? onSearchSubmit;

  /// The text style applied to list items.
  final TextStyle? listTextStyle;

  /// Padding configuration for list items.
  final ListPadding listPadding;

  /// The decoration for the search input field.
  final InputDecoration? searchDecoration;

  /// Properties for the clear icon shown in the search field.
  final IconProperty? clearIconProperty;

  @override
  State<SingleSelection> createState() => _SingleSelectionState();
}

class _SingleSelectionState extends State<SingleSelection> {
  late List<DropDownValueModel> newDropDownList;
  late TextEditingController _searchCnt;
  late FocusScopeNode _focusScopeNode;
  late InputDecoration _inpDec;
  void Function()? _mainControllerListener;
  void onItemChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        newDropDownList = List.from(widget.dropDownList);
      } else {
        newDropDownList = widget.dropDownList
            .where(
              (item) => item.name.toLowerCase().contains(value.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  void initState() {
    _focusScopeNode = FocusScopeNode();
    _inpDec = widget.searchDecoration ?? InputDecoration();
    if (widget.searchAutofocus) {
      widget.searchFocusNode.requestFocus();
    }
    _focusScopeNode.requestFocus();
    newDropDownList = List.from(widget.dropDownList);
    _searchCnt = TextEditingController();
    if (widget.autoSort) {
      onItemChanged(widget.mainController.text);
      _mainControllerListener = () {
        if (mounted) {
          onItemChanged(widget.mainController.text);
        }
      };
      widget.mainController.addListener(_mainControllerListener!);
    }
    super.initState();
  }

  @override
  void dispose() {
    // Remove listener if it was added
    if (widget.autoSort && _mainControllerListener != null) {
      widget.mainController.removeListener(_mainControllerListener!);
    }
    _focusScopeNode.dispose();
    _searchCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.enableSearch)
          SizedBox(
            height: widget.searchHeight,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 13.0,
                bottom: 13.0,
              ),
              child: TextField(
                style: widget.searchTextStyle,
                focusNode: widget.searchFocusNode,
                showCursor: widget.searchShowCursor,
                keyboardType: widget.searchKeyboardType,
                controller: _searchCnt,
                onTap: () {
                  if (widget.onSearchTap != null) {
                    widget.onSearchTap!();
                  }
                },
                decoration: _inpDec.copyWith(
                  hintText: _inpDec.hintText ?? 'Search Here...',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      widget.mainFocusNode.requestFocus();
                      _searchCnt.clear();
                      onItemChanged("");
                    },
                    child: widget.searchFocusNode.hasFocus
                        ? InkWell(
                            child: Icon(
                              widget.clearIconProperty?.icon ?? Icons.close,
                              size: widget.clearIconProperty?.size,
                              color: widget.clearIconProperty?.color,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                onChanged: onItemChanged,
                onSubmitted: (val) {
                  widget.mainFocusNode.requestFocus();
                  if (widget.onSearchSubmit != null) {
                    widget.onSearchSubmit!();
                  }
                },
              ),
            ),
          ),
        SizedBox(
          height: widget.height,
          child: Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: newDropDownList.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: widget.listTileHeight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                      left: 10,
                      bottom: widget.listPadding.bottom,
                      top: widget.listPadding.top,
                    ),
                    child: InkWell(
                      onTap: () {
                        widget.onChanged(newDropDownList[index]);
                      },
                      child: Text(
                        newDropDownList[index].name,
                        style: widget.listTextStyle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
