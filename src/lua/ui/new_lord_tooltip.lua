local function set_new_lord_tooltip(component, faction)
  if not enable_supply_balance then
    return
  end;

  local supply_balance = get_supply_balance(faction)

  local force_list = faction:military_force_list();
  local new_army_cost = get_army_count(force_list)

  local negative_balance = new_army_cost
  if supply_balance > 0 then
    negative_balance = new_army_cost - supply_balance
  end
  
  local num_of_armies = new_army_cost + 1
  local upkeep = math.ceil(negative_balance/math.sqrt(num_of_armies))*num_of_armies*srw_get_diff_mult()/24

  local tooltip_text = "Current supply balance is "..supply_balance.."\nNew army will decreace it by "..new_army_cost.."\nYour army upkeep will be increase by "..math.floor(upkeep)

  if is_uicomponent(component) then 
    component:SetTooltipText(tooltip_text, true)
  end;

end

