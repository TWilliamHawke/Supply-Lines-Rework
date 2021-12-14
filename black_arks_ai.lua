local function add_upkeep_for_black_arc(faction)
  local force_list = faction:military_force_list();
    
  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() then
    local character = force:general_character():character_subtype_key();

    end; --of army check
  end; --of army call

end;