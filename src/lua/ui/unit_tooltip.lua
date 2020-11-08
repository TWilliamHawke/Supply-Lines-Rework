local function set_unit_tooltip(component, text)
  SRWLOGDEBUG("--------");
  SRWLOGDEBUG("SET UNIT TOOLTIP FUNCTION IS STARTED");

  local component_name = component:Id();
  local unit_name = string.gsub(component_name, text, "")
  local unit_cost , is_basic_cost = get_supply_params(unit_name)

  SRWLOGDEBUG("SET SUPPLY TEXT FUNCTION IS STARTED");
  local supply_text
  if unit_cost == nil then
    supply_text = get_unknown_text()
  else
    supply_text = set_supply_text(unit_cost, is_basic_cost)
  end
  SRWLOGDEBUG("SET SUPPLY TEXT FUNCTION IS FINISHED");


  finalize_unit_tooltip(component, supply_text, "\n")

  SRWLOGDEBUG("SET UNIT TOOLTIP FUNCTION IS FINISHED");
end;
