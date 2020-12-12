local function set_new_lord_tooltip(component)
  if not enable_supply_balance or (max_balance_per_army == 0) then
    return
  end;
  
  local faction = cm:model():world():whose_turn_is_it()
  local culture = faction:subculture();

  if culture == "wh_dlc05_sc_wef_wood_elves" then return end;

  local supply_balance = get_supply_balance(faction)

  local force_list = faction:military_force_list();
  local current_army_count = helpers.get_army_count(force_list)
  local future_army_count = current_army_count + 1
  local supply_decreasing = math.min(current_army_count, max_balance_per_army)

  local current_supply_penalty = 0
  if supply_balance < 0 then
    current_supply_penalty = calculate_supply_penalty(supply_balance*-1, current_army_count)*current_army_count
  end
  
  local negative_balance = supply_decreasing - supply_balance
  

  if negative_balance < 0 then
    negative_balance = 0
  end;


  local future_supply_penalty = calculate_supply_penalty(negative_balance, future_army_count)*future_army_count
  SRWLOGDEBUG("future supply penalty is "..tostring(future_supply_penalty))


  local tooltip_text = helpers.localizator("SRW_new_lord_supply_balance")..supply_balance..helpers.localizator("SRW_new_lord_decrease")..supply_decreasing..helpers.localizator("SRW_new_lord_consumption")..tostring(future_supply_penalty - current_supply_penalty)

  SRWLOGDEBUG("tooltip text finished")
  SRWLOGDEBUG("---------------------")

  if future_supply_penalty > 20 then
    tooltip_text = tooltip_text..helpers.localizator("SRW_new_lord_suggestion")
  end;

  if is_uicomponent(component) then 
    component:SetTooltipText(tooltip_text, true)
  end;

end

