local function srw_calculate_upkeep(force, supply_penalty)
  local multiplier = helpers.srw_get_diff_mult();
  local unit_list = force:unit_list();
  local character = force:general_character();

  helpers.remove_effect(force)

  local supply_demand_this_army = calculate_army_supply(unit_list, character) + supply_penalty;
  SRWLOG("THIS ARMY REQUIRED "..tostring(supply_demand_this_army).." SUPPLY POINTS");
  local effect_strength = helpers.get_upkeep_from_supply(supply_demand_this_army, multiplier);

  if effect_strength > 0 then
    helpers.apply_effect(effect_strength, force)
  end;

  SRWLOGDEBUG("[]CALCULATION UPKEEP FOR THIS ARMY IS FINISHED");
  
end;
