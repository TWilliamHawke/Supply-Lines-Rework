local function get_supply_params(unit_name)
  local selected_char = tostring(SRW_selected_character:character_subtype_key())
  local is_basic_cost = true
  local unit_cost = get_unit_supply(unit_name)


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

  return unit_cost, is_basic_cost
end