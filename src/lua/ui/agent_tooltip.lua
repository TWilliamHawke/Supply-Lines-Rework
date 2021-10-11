local function set_agent_tooltip(component)
  if not SRW_selected_character then return end;
  if not SRW_selected_character:faction():is_human()  then return end;

  local agent_supply_cost = 0;

  if basic_agent_supply == 0 then
    return
  end;

  if SRW_selected_character:has_military_force() then 
    local charlist = SRW_selected_character:military_force():character_list()
    local agent_number = component:Id():match("(%d+)")
    if(tonumber(agent_number) >= charlist:num_items()) then return end;

    local character = charlist:item_at(tonumber(agent_number));

    if not character then return end;
    SRWLOGDEBUG("Character # "..tostring(agent_number).." is "..tostring(character:character_subtype_key()))
    agent_supply_cost = get_this_agent_supply(character);
  else
    SRWLOGDEBUG("Selected agent rank is "..tostring(SRW_selected_character:rank()))
    agent_supply_cost = get_this_agent_supply(SRW_selected_character);
  end;


  local supply_text = helpers.localizator("SRW_agent_supply_cost")
  supply_text = string.gsub(supply_text, "SRW_Cost", agent_supply_cost);


  helpers.finalize_unit_tooltip(component, supply_text, "\n")

end;