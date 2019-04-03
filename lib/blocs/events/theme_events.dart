abstract class ThemeEvent { }
class InitializeThemeEvent extends ThemeEvent { }
class ChangeThemeEvent extends ThemeEvent {
  final bool darkTheme;

  ChangeThemeEvent(this.darkTheme);
}