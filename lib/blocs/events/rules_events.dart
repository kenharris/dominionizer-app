abstract class RulesEvent { }
class InitializeRulesEvent extends RulesEvent { }
class UpdateRulesCategoryEvent extends RulesEvent {
  final int categoryId;
  final bool newValue;

  UpdateRulesCategoryEvent(this.categoryId, this.newValue);
}