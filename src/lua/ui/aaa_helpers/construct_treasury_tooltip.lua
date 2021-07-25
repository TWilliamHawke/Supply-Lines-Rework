function helpers.construct_treasury_tooltip(faction)
  SRWLOGDEBUG("Constructor IS STARTED");

  local culture = faction:subculture();
  local global_supply = 0
  local upkeep_percent = -1
  local dif_mod = helpers.srw_get_diff_mult();
  local force_list = faction:military_force_list();
  local lord_text = helpers.get_subculture_text(culture)
  local supply_balance = get_supply_balance(faction)
  local supply_penalty = get_supply_penalty(faction, supply_balance)
  

  -- calculate supply and upkeep
  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if helpers.check_army_type(force, true) then
      local unit_list = force:unit_list();
      local character = force:general_character();

      local army_supply = calculate_army_supply(unit_list, character) + supply_penalty;
      global_supply = global_supply + army_supply

      upkeep_percent = upkeep_percent + helpers.get_upkeep_from_supply(army_supply, dif_mod) + 1
    end; --of army check
  end; --of army call

  if upkeep_percent < 0 then upkeep_percent = 0 end;

  local agents_supply = get_agents_supply(faction)
  global_supply = global_supply + agents_supply;
  upkeep_percent = upkeep_percent + helpers.get_upkeep_from_supply(agents_supply, dif_mod);


  local supply_text = helpers.localizator("SRW_treasury_tooltip_supply")
  supply_text = string.gsub(supply_text, "SRW_supply", tostring(global_supply))
  
  local supply_balance_text = ""

  if enable_supply_balance and not (culture == "wh_dlc05_sc_wef_wood_elves") then
    supply_balance_text = helpers.localizator("SRW_supply_balance_text")..supply_balance
  end

  local tooltip_text = helpers.localizator("SRW_treasury_tooltip_main")..lord_text..supply_text..helpers.localizator("SRW_treasury_tooltip_upkeep")..tostring(upkeep_percent).."%"..supply_balance_text

  SRWLOGDEBUG("Constructor IS FINISHED");
  return tooltip_text
end;