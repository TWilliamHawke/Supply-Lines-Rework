--AI Section starts here



local function calculate_army_supply_AI(unit_list, character)
  local this_army_supply = basic_lord_supply;

  for j = 0, unit_list:num_items() - 1 do
    local unit = unit_list:item_at(j);
    local key = unit:unit_key();
    local val = helpers.get_unit_supply(key) or helpers.calculate_unit_supply(unit);
    if val < 0 then
      val = 0
    end;
    this_army_supply = this_army_supply + val;
  end; --units

  return this_army_supply
end;

local function srw_calculate_upkeep_AI(force)
  local unit_list = force:unit_list();
  local character = force:general_character():character_subtype_key();

  helpers.remove_effect(force, ai_supply_enabled)

  if ai_supply_mult > 0 then
    local effect_strength = calculate_army_supply_AI(unit_list, character);
    SRWLOGAI("THIS ARMY HAS "..tostring(unit_list:num_items()).." UNITS");
    SRWLOGAI("THIS ARMY REQUIRED "..tostring(effect_strength).." SUPPLY POINTS");

    local upkeep_mod = helpers.get_upkeep_from_supply(effect_strength, ai_supply_mult);
    if upkeep_mod > 0 then
      helpers.apply_effect(upkeep_mod, force, ai_supply_enabled)
    end;
  end
end;


local function srw_apply_upkeep_penalty_AI(faction)
  if not faction:is_human() then
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if not force:is_armed_citizenry() and force:has_general() then
        SRWLOGAI("--------");
        SRWLOGAI("CHECK ARMY #"..tostring(i));
        srw_calculate_upkeep_AI(force)
        SRWLOGDEBUG("CALCULATION SUPPLY FOR THIS ARMY IS FINISHED");
      end; --of army check
    end; --of army call
  end; -- of local faction
end; -- of function

