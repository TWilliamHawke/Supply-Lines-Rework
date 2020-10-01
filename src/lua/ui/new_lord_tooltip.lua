local function set_new_lord_tooltip(component, faction)
  if not enable_supply_balance then
    return
  end;

  local supply_balance = get_supply_balance(faction)

  local force_list = faction:military_force_list();
  local army_cost = 0

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
      army_cost = army_cost + 1
    end; --of army check
  end; --of army call

  local negative_balance = army_cost
  if supply_balance > 0 then
    negative_balance = army_cost - supply_balance
  end
  local num_of_armies = army_cost + 1
  local upkeep = math.ceil(negative_balance/math.sqrt(num_of_armies))*num_of_armies*srw_get_diff_mult()/24

  local tooltip_text = "Current supply balance is "..supply_balance.."\nNew army will decreace it by "..army_cost.."\nYour army upkeep will be increase by "..math.floor(upkeep)

  if is_uicomponent(component) then 
    component:SetTooltipText(tooltip_text, true)
  end;

end

