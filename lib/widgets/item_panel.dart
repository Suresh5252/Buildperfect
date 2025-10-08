/*
@author     :   karthick.d    30/09/2025
@desc       :   itempanel wraps left panel widgets options (draggable)
                and center panel dragged controls list
                
*/
import 'dart:math';
import 'dart:ui';

import 'package:dashboard/appstyles/global_styles.dart';
import 'package:dashboard/bloc/bpwidgetprops/model/bpwidget_props.dart';
import 'package:dashboard/types/drag_drop_types.dart';
import 'package:dashboard/widgets/containers/dragged_holder.dart';
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
  final Function(BpwidgetProps item)? onItemClicked;
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
    this.onItemClicked,
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

  int selectedIndex = 0;

  Widget getWidgetPlaceholders(
    PlaceholderWidgets controlName, {
    int index = 0,
  }) {
    return switch (controlName) {
      PlaceholderWidgets.Textfield => DraggedHolder(
        onTapDraggedControl: () {
          /// when draggedholder is selected , selected formcontrol
          /// label and other properties should be autopopulate
          /// props panel
          ///
          selectedIndex = index;

          BpwidgetProps bpWidgetPropsObj = getWidgetProps(
            widget.items[selectedIndex],
          );
          widget.onItemClicked!(bpWidgetPropsObj);
          setState(() {});
        },
        labelText: 'label ${index + 1}',
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                selectedIndex == index
                    ? Border.all(width: 2, color: Colors.teal)
                    : Border.all(width: 2, color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  enabled:
                      false, // enabled: selectedIndex == index ? true : false,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.transparent),
                    // ),
                    hintText: 'Textbox',
                    label: Text('TextField'),
                    floatingLabelStyle: TextStyle(fontSize: 14),

                    // disabledBorder:
                    //     selectedIndex == index
                    //         ? OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(10),
                    //           borderSide: GlobalStyles.selectedBorderStyle,
                    //         )
                    //         : OutlineInputBorder(
                    //           borderSide: GlobalStyles.unselectedBorderStyle,
                    //         ),
                  ),
                ),
              ),
              selectedIndex == index
                  ? Row(
                    children: [
                      GlobalStyles.selectedIcon,
                     SizedBox(width: 5,),
                      IconButton(onPressed: (){
                        setState(() {
                          itemsCopy.removeAt(selectedIndex);
                        });
                      }, 
                      icon: GlobalStyles.deleteIcon)
                    ],
                  )
                  : GlobalStyles.fillerSizedBox50,
            ],
          ),
        ),
      ),
      PlaceholderWidgets.Dropdown => DraggedHolder(
        onTapDraggedControl: () {
          selectedIndex = index;

          BpwidgetProps bpWidgetPropsObj = getWidgetProps(
            widget.items[selectedIndex],
          );
          widget.onItemClicked!(bpWidgetPropsObj);
          setState(() {});
        },
        labelText: 'label ${index + 1}',
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                selectedIndex == index
                    ? Border.all(width: 2, color: Colors.teal)
                    : Border.all(width: 2, color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              SizedBox(
                width: 300,
                child: DropdownMenu(
                  dropdownMenuEntries: [],
                  enabled: false,
                  hintText: 'DropDownField',
                  width: 300,
                  inputDecorationTheme: InputDecorationTheme(
                    disabledBorder: InputBorder.none,
                  ),
                  // inputDecorationTheme: InputDecorationTheme(
                  //   disabledBorder:
                  //       selectedIndex == index
                  //           ? OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             borderSide: GlobalStyles.selectedBorderStyle,
                  //           )
                  //           : OutlineInputBorder(
                  //             borderSide: GlobalStyles.unselectedBorderStyle,
                  //           ),
                  // ),
                ),
              ),
               selectedIndex == index
                  ? Row(
                    children: [
                      GlobalStyles.selectedIcon,
                     SizedBox(width: 5,),
                      IconButton(onPressed: (){
                        setState(() {
                          itemsCopy.removeAt(selectedIndex);
                        });
                      }, 
                      icon: GlobalStyles.deleteIcon)
                    ],
                  )
                  : GlobalStyles.fillerSizedBox50,
            ],
          ),
        ),
      ),
      PlaceholderWidgets.Checkbox => DraggedHolder(
        onTapDraggedControl: () {
          selectedIndex = index;

          BpwidgetProps bpWidgetPropsObj = getWidgetProps(
            widget.items[selectedIndex],
          );
          widget.onItemClicked!(bpWidgetPropsObj);
          setState(() {});
        },

        labelText: 'label ${index + 1}',
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                selectedIndex == index
                    ? Border.all(width: 2, color: Colors.teal)
                    : Border.all(width: 2, color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              SizedBox(
                width: 200,
                height: 70,
                child: Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      semanticLabel: 'Checkbox',
                    ),
                    Text('Checkbox'),
                  ],
                ),
              ),
              GlobalStyles.fillerSizedBox50,
               selectedIndex == index
                  ? Row(
                    children: [
                      GlobalStyles.selectedIcon,
                      SizedBox(width: 5,),
                      IconButton(onPressed: (){
                        setState(() {
                          itemsCopy.removeAt(selectedIndex);
                        });
                      }, 
                      icon: GlobalStyles.deleteIcon)
                    ],
                  )
                  : GlobalStyles.fillerSizedBox50,
            ],
          ),
        ),
      ),
      PlaceholderWidgets.Radio => DraggedHolder(
        labelText: 'label ${index + 1}',
        child: Row(
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
      ),
      PlaceholderWidgets.Button => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ElevatedButton(onPressed: () {}, child: Text('Save'))],
      ),
      PlaceholderWidgets.Label => Text('label ${index + 1}'),
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
    final itemsCopy = List<PlaceholderWidgets>.from(widget.items);
    print('itemscopy => $itemsCopy');
    if (widget.panel == Panel.upper) {
      return ListView(
        padding: const EdgeInsets.all(4),
        children:
            itemsCopy.asMap().entries.map<Widget>((e) {
              Widget child = SizedBox(
                height: 50,
                width: 0,

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: getWidgetPlaceholders(e.value, index: e.key),
                  ),
                ),
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

  BpwidgetProps getWidgetProps(PlaceholderWidgets wdg) {
    return switch (wdg) {
      PlaceholderWidgets.Textfield => BpwidgetProps(
        label: 'label ${selectedIndex + 1}',
        controlName: 'page1_',
        controlType: 'Textbox',
      ),
      PlaceholderWidgets.Dropdown => BpwidgetProps(
        label: 'label ${selectedIndex + 1}',
        controlName: 'page1_',
        controlType: 'Dropdown',
      ),
      PlaceholderWidgets.Checkbox => BpwidgetProps(
        label: 'label ${selectedIndex + 1}',
        controlName: 'page1_',
        controlType: 'Checkbox',
      ),
      PlaceholderWidgets.Radio => BpwidgetProps(
        label: 'label ${selectedIndex + 1}',
        controlName: 'page1_',
        controlType: 'Radio',
      ),
      PlaceholderWidgets.Button => BpwidgetProps(
        label: 'label ${selectedIndex + 1}',
        controlName: 'page1_',
        controlType: 'Button',
      ),
      PlaceholderWidgets.Label => BpwidgetProps(
        label: 'label ${selectedIndex + 1}',
        controlName: 'page1_',
        controlType: 'Textfield',
      ),
    };
  }
}
