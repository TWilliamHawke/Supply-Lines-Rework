local function get_armies_total_cost(faction)
  local force_list = faction:military_force_list();
  local armies_total_cost = 0
  local army_cost = 0

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    local character_subtype = force:general_character():character_subtype_key()
    
    
    if not force:is_armed_citizenry() and force:has_general() and character_subtype ~= "wh2_main_def_black_ark" and character_subtype ~= "wh2_pro08_neu_gotrek" then
      armies_total_cost = armies_total_cost + army_cost

      if army_cost < max_balance_per_army then
        army_cost = army_cost + 1
      end;
    end; --of army check
  end; --of force list loop

  return armies_total_cost
end;
