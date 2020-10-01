local function get_supply_balance(faction)

  if not enable_supply_balance then
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

