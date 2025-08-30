import 'dart:developer';

import 'package:bloc/bloc.dart';

class BottomBarCubit extends Cubit<bool> {
  BottomBarCubit() : super(true);

  void show() => emit(true);
  void hide() => emit(false);

  @override
  void onChange(Change<bool> change) {
    super.onChange(change);
    log(change.toString());
  }
}
