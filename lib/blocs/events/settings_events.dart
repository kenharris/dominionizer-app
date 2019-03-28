abstract class SettingsEvent { }
class InitializeAppEvent extends SettingsEvent { }
class ChangeAllSettingsEvent extends SettingsEvent {
  final bool darkTheme;
  final bool autoBlacklist;
  final int shuffleSize;

  ChangeAllSettingsEvent(this.shuffleSize, this.autoBlacklist, this.darkTheme);
}