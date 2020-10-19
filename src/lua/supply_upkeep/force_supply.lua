local function srw_calculate_upkeep(force, supply_penalty)
  local multiplier = srw_get_diff_mult();
  local unit_list = force:unit_list();
  local character = force:general_character();

  remove_effect(force)

  local effect_strength = calculate_army_supply(unit_list, character) + supply_penalty;
  SRWLOG("THIS ARMY REQUIRED "..tostring(effect_strength).." SUPPLY POINTS");
  effect_strength = math.floor(effect_strength*multiplier/24);

  if effect_strength > 0 then
    apply_effect(effect_strength, force)
  end;

  SRWLOGDEBUG("[]CALCULATION UPKEEP FOR THIS ARMY IS FINISHED");
  
end;
