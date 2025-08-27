import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/data/mapper/theme_mapper.dart';
import 'package:todo_app/features/data/repository/theme_repository.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;
  ThemeBloc(this.themeRepository)
    : super(
        ThemeState(ThemeMapper.mapIndexToTheme(themeRepository.loadTheme())),
      ) {
    //Change theme
    on<ChangeThemeEvent>((event, emit) async {
      emit(ThemeState(event.themeMode));
      await themeRepository.saveTheme(
        ThemeMapper.mapThemeToIndex(event.themeMode),
      );
    });
  }
}
