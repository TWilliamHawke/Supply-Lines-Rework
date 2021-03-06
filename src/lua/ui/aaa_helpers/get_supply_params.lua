function helpers.get_supply_params(unit_name)
  local selected_char = tostring(SRW_selected_character:character_subtype_key())
  local is_basic_cost = true
  local unit_cost = helpers.get_unit_supply(unit_name)


  if SRW_Free_Units[unit_name.."-"..selected_char] ~= nil then
    unit_cost = SRW_Free_Units[unit_name.."-"..selected_char] + basic_unit_supply  
    is_basic_cost = false
  end
  if SRW_Lord_Group[selected_char] then

    local name = SRW_Lord_Group[selected_char]
    if SRW_Lord_Skills_Cost[unit_name.."-"..name] ~= nil then
      
      local bonus_skill = SRW_Lord_Skills_Cost[unit_name.."-"..name][1]
      local bonus_skill2 = SRW_Lord_Skills_Cost[unit_name.."-"..name][3] or "srw_skill"
      if SRW_selected_character:has_skill(bonus_skill) or SRW_selected_character:has_skill(bonus_skill2) then
        is_basic_cost = false
        unit_cost = SRW_Lord_Skills_Cost[unit_name.."-"..name][2] + basic_unit_supply;      
      end
    end
  end

  if (selected_char == "wh2_main_def_black_ark" or selected_char == "wh2_main_def_black_ark_blessed_dread") and unit_cost ~= 0 then
    is_basic_cost = false
    unit_cost = 0
  end

  return unit_cost, is_basic_cost
end