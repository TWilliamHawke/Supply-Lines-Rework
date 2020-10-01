local function set_supply_text(cost, is_basic_value)

  if is_basic_value then
    if cost <= 0 then
      return localizator("SRW_unit_supply_cost_zero")
    elseif cost == 1 then
      return localizator("SRW_unit_supply_cost_one")
    else
      local imported_text = localizator("SRW_unit_supply_cost_many")
      return string.gsub(imported_text, "SRW_Cost", tostring(cost))    
    end
  else
    if cost <= 0 then
      return localizator("SRW_unit_supply_cost_lord")
    elseif cost == 1 then
      return localizator("SRW_unit_supply_cost_lord_one")
    else
      local imported_text = localizator("SRW_unit_supply_cost_lord_many")
      return string.gsub(imported_text, "SRW_Cost", tostring(cost))    
    end
  end
  return get_unknown_text()
end
