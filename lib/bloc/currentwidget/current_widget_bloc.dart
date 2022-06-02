import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentWidgetCubit extends Cubit<Widget> {
  CurrentWidgetCubit() : super(Container());
  void changeWidget(Widget widget) => emit(widget);
}
