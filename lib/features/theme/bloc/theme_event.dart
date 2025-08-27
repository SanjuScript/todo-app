part of 'theme_bloc.dart';

 sealed class ThemeEvent {}

//Change Theme
class ChangeThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;
  ChangeThemeEvent(this.themeMode);
}
