local function srw_remove_upkeep_penalty(faction)
  if faction:is_human() then
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if not force:is_armed_citizenry() and force:has_general() then
        SRWLOG("--------");
        SRWLOG("CHECK ARMY #"..tostring(i));
        remove_effect(force)
      end; --of army check

    end; --of army call

  end; -- of local faction
  
  SRWLOGDEBUG("[]REMOVE SUPPLY FOR THIS fACTION IS FINISHED");
end; -- of function

