local function srw_apply_upkeep_penalty(faction)
  if faction:is_human() then
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
        SRWLOG("--------");
        SRWLOG("CHECK ARMY #"..tostring(i));
        srw_calculate_upkeep(force)
      end; --of army check

    end; --of army call

  end; -- of check local faction
  
  SRWLOGDEBUG("[]CALCULATION SUPPLY FOR THIS fACTION IS FINISHED");
end; -- of function
