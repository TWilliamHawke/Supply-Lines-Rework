local function get_base_agent_supply(character)
  if basic_agent_supply == -1 then
    local char_rank = character:rank();
    if char_rank < 10 then
      return 1;
    elseif char_rank < 20 then
      return 2;
    else
      return 3;
    end
  else
    return basic_agent_supply
  end;

end;


local function get_this_agent_supply(character)
  local base_agent_supply_cost = get_base_agent_supply(character)
  local agent_type = character:character_subtype_key();

  if SRW_Free_agents[agent_type] then
    return 0;
  end;

  if agent_type == "wh_dlc05_vmp_vampire_shadow" or agent_type == "vmp_vampire" then
    if character:is_embedded_in_military_force() then
      local force = character:embedded_in_military_force();
      local lord_type = force:general_character():character_subtype_key();

      if lord_type == "pro02_vmp_isabella_von_carstein" then
        SRWLOG("Vampire in Isabella army")
        return math.max(0, base_agent_supply_cost - 2)
      end;

    end;
  end;

  return base_agent_supply_cost;
end;


local function get_agents_supply(faction)

  if basic_agent_supply == 0 then
    return 0;
  end;


  local char_list = faction:character_list();

  local agents_supply = 0;

  for i = 0, char_list:num_items() - 1 do
    local character = char_list:item_at(i);
    if cm:char_is_agent(character) then
      local char_supply = get_this_agent_supply(character)
      agents_supply = agents_supply + char_supply;
    end;
  end

  return agents_supply

end;

function Supply_lines_rework.calculate_agents_supply(faction)
  local effects_bundle_id = "SRW_upkeep_global"
  local effect_key = "wh_main_effect_force_all_campaign_upkeep";
  local faction_name = faction:name()
  local dif_mod = helpers.srw_get_diff_mult();

  if faction:has_effect_bundle(effects_bundle_id) then
    SRWLOGDEBUG("remove old effect")
    cm:remove_effect_bundle(effects_bundle_id, faction_name);
  end;

  SRWLOGDEBUG("start work with agents")

  local agents_supply = get_agents_supply(faction);
  local agents_upkeep_pct = helpers.get_upkeep_from_supply(agents_supply, dif_mod);

  if agents_upkeep_pct == 0 then return end;
  SRWLOGDEBUG("agents pct > 0")

  local effect_bundle = cm:create_new_custom_effect_bundle(effects_bundle_id);
	effect_bundle:add_effect(effect_key, "force_to_force_own_factionwide", agents_upkeep_pct);
  effect_bundle:set_duration(0);

  cm:apply_custom_effect_bundle_to_faction(effect_bundle, faction);
  SRWLOG("apply new effect for agents, effect power is "..tostring(agents_upkeep_pct))



end;