--if unit not found in SRW_Supply_Cost
function helpers.calculate_unit_supply(unit)
  local uclass = unit:unit_class();
  --local ucat = unit:unit_category();
  local ucost = unit:get_unit_custom_battle_cost()
  if uclass == "com" then
    return 0
  elseif ucost == 0 then
    return 1 + basic_unit_supply
  elseif ucost >= 1800 then
    return 4 + basic_unit_supply
  elseif ucost >= 1400 then
    return 3 + basic_unit_supply
  elseif ucost >= 1000 then
    return 2 + basic_unit_supply
  elseif ucost >= 600 then
    return 1 + basic_unit_supply
  end;
  return basic_unit_supply;
end; 

function helpers.get_unit_supply(key)
  if SRW_Supply_Cost[key] ~= nil then
    return basic_unit_supply + SRW_Supply_Cost[key]
  else
    return nil
  end
end

