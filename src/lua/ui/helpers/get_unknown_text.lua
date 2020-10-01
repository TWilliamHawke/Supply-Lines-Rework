local function get_unknown_text()
  local unknown_text = localizator("SRW_unit_supply_cost_unknown")
  for n = 0, 4 do
    local this_price_supply = n + basic_unit_supply
    if this_price_supply < 0 then
      this_price_supply = 0
    end
    unknown_text = string.gsub(unknown_text, "SRW_Cost_"..n, tostring(this_price_supply))
  end;
  return unknown_text
end;

