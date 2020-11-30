local function get_supply_balance(faction)
  local culture = faction:subculture();

  if not enable_supply_balance or culture == "wh_dlc05_sc_wef_wood_elves" then
    return 0
  end;

  local army_supply = get_armies_total_cost(faction)
  local region_supply = get_building_var(faction)
  
  return region_supply - army_supply
end

local function calculate_supply_balance(faction)
  remove_supply_balance_effect(faction)

  local supply_balance = get_supply_balance(faction)

  if supply_balance > 0 then
    apply_supply_balance_effect(faction, supply_balance)
  end
end

local function get_supply_penalty(faction, supply_balance)

  if supply_balance >= 0 then
    return 0
  end

  local force_list = faction:military_force_list();
  local num_of_armies = get_army_count(force_list)
  --supply_balance = 0 - supply_balance

  return calculate_supply_penalty(0 - supply_balance, num_of_armies)

end