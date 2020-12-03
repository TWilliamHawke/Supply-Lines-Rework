function helpers.get_num_of_agents(unit_list)
  local num_of_agents = 0

  for j = 1, unit_list:num_items() - 1 do
    local unit = unit_list:item_at(j);
    local uclass = unit:unit_class();

    if uclass ~= "com" then break end;
    
    num_of_agents = num_of_agents + 1
  end;

  return num_of_agents
end