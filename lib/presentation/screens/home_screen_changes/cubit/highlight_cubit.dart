import 'package:bloc/bloc.dart';

class HighlightCubit extends Cubit<String?> {
  HighlightCubit() : super(null);

  void highlight(String taskId) => emit(taskId);
  void clear() => emit(null);
}
