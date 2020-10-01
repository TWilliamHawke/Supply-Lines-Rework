function get_main_building_cost(building, faction)
  local main_building_level = building:building_level()
  local main_building_superchain = building:superchain()
  local culture = faction:culture()

  if gates_superchain[main_building_superchain] then
    return 1
  end;

  if culture == "wh_dlc05_wef_wood_elves" then
    if wood_elves_trees[main_building_superchain] then
      return 1
    else
      return 0
    end
  end;

  if main_building_level == 5 then
    return 3
  elseif main_building_level == 4 then
    return 2
  else
    return 1
  end
end