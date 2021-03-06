--return upkeep percent
function helpers.get_upkeep_from_supply(supply, dif_mod)
  local army_upkeep = math.floor(supply*dif_mod/24)

  return math.min(army_upkeep, max_supply_per_army)
end;