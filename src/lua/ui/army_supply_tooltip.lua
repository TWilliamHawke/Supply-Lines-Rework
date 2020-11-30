local function set_army_supply_tooltip(component)
  if not SRW_selected_character then return end;
  if not SRW_selected_character:has_military_force() then return end;

  local faction = SRW_selected_character:faction()
  local supply_balance = get_supply_balance(faction)
  local supply_penalty = get_supply_penalty(faction, supply_balance)
  local force = SRW_selected_character:military_force()
  local unit_list = force:unit_list();

  local army_supply = calculate_army_supply(unit_list, SRW_selected_character) + supply_penalty;

  local text = "its ok"..army_supply

  if is_uicomponent(component) then 
    component:SetTooltipText(text, true)
  end;

end;