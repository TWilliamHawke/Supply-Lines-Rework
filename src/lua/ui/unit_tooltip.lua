local function set_unit_tooltip(component, text)
  SRWLOGDEBUG("--------");
  SRWLOGDEBUG("SET UNIT TOOLTIP FUNCTION IS STARTED");

  local component_name = component:Id();
  local unit_name = string.gsub(component_name, text, "")
  local old_text = component:GetTooltipText();
  local unit_cost = get_unit_supply(unit_name)
  local is_basic_cost = true

  local selected_char = tostring(SRW_selected_character:character_subtype_key())

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

  SRWLOGDEBUG("SET SUPPLY TEXT FUNCTION IS STARTED");
  local supply_text
  if unit_cost == nil then
    supply_text = get_unknown_text()
  else
    supply_text = set_supply_text(unit_cost, is_basic_cost)
  end
  SRWLOGDEBUG("SET SUPPLY TEXT FUNCTION IS FINISHED");


  if string.find(old_text, supply_text) then return end
  local final_text = string.gsub(old_text, "\n", "\n[[col:yellow]]"..supply_text.."[[/col]]\n", 1)
  if is_uicomponent(component) then 
    component:SetTooltipText(final_text, true)
  end;
  SRWLOGDEBUG("SET UNIT TOOLTIP FUNCTION IS FINISHED");
end;
