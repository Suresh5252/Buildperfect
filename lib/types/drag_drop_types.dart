/*
@author     : karthick.d    24/09/2025
@desc       : custom types required for drag and drag panel behaviour

*/
enum Panel { upper, lower }

typedef PanelLocation = (int, Panel);

extension CopyPanelLocation on PanelLocation {
  PanelLocation copyWith(int? index, Panel? panel) => (
    index ?? this.$1,
    panel ?? this.$2,
  );
}

enum PlaceholderWidgets { Textfield, Dropdown, Checkbox, Radio, Button, Label }

// enum PlaceholderWidgets { Textfield, Dropdown, Checkbox, Radio, Button, Label , Currency , Numeric , AlphaNumeric , SearchableDropdowm , Calender}
