import 'package:dashboard/bloc/bpwidgetprops/model/bpwidget_props.dart';
import 'package:dashboard/types/drag_drop_types.dart';

class BPWidget {
  final PlaceholderWidgets widgetType;
  final BpwidgetProps? bpwidgetProps;
  BPWidget({required this.bpwidgetProps, required this.widgetType});

  BPWidget copyWith({
    PlaceholderWidgets? widgetType,
    BpwidgetProps? bpwidgetProps,
  }) {
    return BPWidget(
      widgetType: widgetType ?? this.widgetType,
      bpwidgetProps: bpwidgetProps ?? this.bpwidgetProps,
    );
  }
}
