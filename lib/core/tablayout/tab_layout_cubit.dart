import 'package:flutter_bloc/flutter_bloc.dart';

class TabLayoutCubit extends Cubit<int> {
  TabLayoutCubit(super.initialState);

  void setState(int page) => emit(page);
}
