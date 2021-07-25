local function srw_apply_upkeep_penalty(faction)
  local supply_balance = get_supply_balance(faction)
  local supply_penalty = get_supply_penalty(faction, supply_balance)

  if faction:is_human() then
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if helpers.check_army_type(force, true) then
        SRWLOG("--------");
        SRWLOG("CHECK ARMY #"..tostring(i));
        srw_calculate_upkeep(force, supply_penalty)
      end; --of army check
    end; --of army call
  end; -- of check local faction
  
  SRWLOGDEBUG("[]CALCULATION SUPPLY FOR THIS fACTION IS FINISHED");
  Supply_lines_rework.calculate_agents_supply(faction)
end; -- of function
