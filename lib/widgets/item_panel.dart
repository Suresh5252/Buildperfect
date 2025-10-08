/*
@author     :   karthick.d    30/09/2025
@desc       :   itempanel wraps left panel widgets options (draggable)
                and center panel dragged controls list
                
*/
import 'dart:math';
import 'dart:ui';

import 'package:dashboard/types/drag_drop_types.dart';
import 'package:dashboard/widgets/lead_tab_bar.dart';
import 'package:dashboard/widgets/my_draggable_widget.dart';
import 'package:dashboard/widgets/rightpanels/panel_header.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ItemPanel extends StatefulWidget {
  final double width;
  final List<PlaceholderWidgets> items;
  final int crossAxisCount;
  final double spacing;
  final Function(PanelLocation) onDragStart;
  final Panel panel;
  final PanelLocation? dragStart;
  final PanelLocation? dropPreview;
  final PlaceholderWidgets? hoveringData;
  const ItemPanel({
    super.key,
    required this.width,
    required this.items,
    required this.crossAxisCount,
    required this.spacing,
    required this.onDragStart,
    required this.panel,
    required this.dragStart,
    required this.dropPreview,
    required this.hoveringData,
  });

  @override
  State<ItemPanel> createState() => _ItemsPanelState();
}

class _ItemsPanelState extends State<ItemPanel> {
  String searchText = '';
  List<PlaceholderWidgets> itemsCopy = [];
  List<PlaceholderWidgets> filteredItems = [];
  List<PlaceholderWidgets> displayList = [];
  TextEditingController searchBarController = TextEditingController();
  bool searchOpt = false;
  @override
  void initState() {
    super.initState();
    itemsCopy = widget.items;
    filteredItems = List.from(itemsCopy);
  }

  /// function return the corresponding formcontrol widgets
  /// which serves as visual placeholders which are dragged from
  /// left widgets panels

  Widget getWidgetPlaceholders(PlaceholderWidgets controlName) {
    return switch (controlName) {
      PlaceholderWidgets.Textfield => TextField(
        enabled: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Textbox',
        ),
      ),
      PlaceholderWidgets.Dropdown => DropdownMenu(
        dropdownMenuEntries: [],
        enabled: false,
        hintText: 'DropDownField',
        width: 300,
      ),
      PlaceholderWidgets.Checkbox => Row(
        children: [
          Checkbox(
            value: true,
            onChanged: (value) {},
            semanticLabel: 'Checkbox',
          ),
          Text('Checkbox'),
        ],
      ),
      PlaceholderWidgets.Radio => Row(
        children: [
          Radio(
            toggleable: false,
            value: '',
            groupValue: '',
            onChanged: (value) {},
          ),
          Text('Radio'),
        ],
      ),
      PlaceholderWidgets.Button => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ElevatedButton(onPressed: () {}, child: Text('Save'))],
      ),
      PlaceholderWidgets.Label => Text('Label Field'),
    };
  }

  //Icon(Icons.text_fields, color: Colors.white),
  Widget renderIconsForFormControlsCard(PlaceholderWidgets controlName) {
    return switch (controlName) {
      PlaceholderWidgets.Textfield => Icon(
        Icons.text_fields,
        color: Colors.white,
      ),
      PlaceholderWidgets.Dropdown => Icon(Icons.menu, color: Colors.white),
      PlaceholderWidgets.Checkbox => Icon(Icons.check_box, color: Colors.white),
      PlaceholderWidgets.Radio => Icon(
        Icons.radio_button_checked,
        color: Colors.white,
      ),
      PlaceholderWidgets.Button => Icon(Icons.touch_app, color: Colors.white),
      PlaceholderWidgets.Label => Icon(Icons.label, color: Colors.white),
    };
  }

  @override
  Widget build(BuildContext context) {
    /// have a copy of dragstartCopy to keep the local copy
    /// so
    if (widget.panel == Panel.upper) {
      return ListView(
        padding: const EdgeInsets.all(4),
        children:
            itemsCopy.asMap().entries.map<Widget>((e) {
              Widget child = Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 380,

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: getWidgetPlaceholders(e.value)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          itemsCopy.removeAt(e.key);
                        });
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              );
              // }
              return Padding(
                padding: const EdgeInsets.only(
                  left: 100,
                  bottom: 6.0,
                  right: 100,
                ),
                child: child,
              );
            }).toList(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 20),
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              searchOpt == false
                  ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: PanelHeader(
                            panelWidth: widget.width,
                            title: 'Widget List',
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              searchOpt = true;
                            });
                          },
                          icon: Icon(Icons.search),
                        ),
                      ],
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 40,
                      child: SearchBar(
                        leading: Icon(Icons.search, size: 18),
                        hintText: "Search Widget",
                        controller: searchBarController,
                        trailing: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                searchOpt = false;
                                searchBarController.clear();
                                filteredItems = List.from(itemsCopy);
                              });
                            },
                            icon: Icon(Icons.close, size: 15),
                          ),
                        ],
                        onChanged:
                            (value) => {
                              setState(() {
                                searchText = value.toLowerCase();
                                filteredItems =
                                    itemsCopy.where((item) {
                                      return item.name.toLowerCase().contains(
                                        searchText,
                                      );
                                    }).toList();
                              }),
                            },
                      ),
                    ),
                  ),

              Expanded(
                child: GridView.count(
                  crossAxisCount: widget.crossAxisCount,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  padding: const EdgeInsets.all(4),
                  children:
                      filteredItems.asMap().entries.map<Widget>((e) {
                        int index = -1;
                        if (filteredItems.length < itemsCopy.length) {
                          index = itemsCopy.indexWhere(
                            (item) => item == filteredItems[0],
                          );
                        }

                        Color textColor = Colors.white;
                        Widget child = Card(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.teal.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                renderIconsForFormControlsCard(e.value),

                                Text(
                                  e.value.name,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        return Draggable(
                          feedback: child,
                          child: MyDraggableWidget(
                            data: e.value.name,
                            onDragStart:
                                () => widget.onDragStart((
                                  index != -1 ? index : e.key,
                                  widget.panel,
                                )),
                            child: child,
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
