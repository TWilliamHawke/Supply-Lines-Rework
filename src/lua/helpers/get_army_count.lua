function helpers.get_army_count(force_list)
  local army_count = 0

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
      army_count = army_count + 1
    end; --of army check
  end; --of army call

  return army_count
end;