import 'package:flutter_bloc/flutter_bloc.dart';

class DropDownListCubit<T> extends Cubit<T?> {
  DropDownListCubit({T? initialValue}) : super(initialValue);

  void updateState(T? value) => emit(value);
}
