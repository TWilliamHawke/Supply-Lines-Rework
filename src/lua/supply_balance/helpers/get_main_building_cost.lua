local function get_main_building_cost(building, faction)
  local main_building_level = building:building_level()
  local main_building_superchain = building:superchain()
  --local culture = faction:culture()

  if gates_superchain[main_building_superchain] then
    return 1
  end;

  if main_building_level == 5 then
    return 2 * big_city_penalty + 1;
  elseif main_building_level == 4 then
    return big_city_penalty + 1;
  else
    return 1
  end
end