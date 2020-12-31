local tomb_king_max_crafted_agents = 25;
local enable_log = false;
local ritual_cost_increace = 100;
--logging function.
local function TKARLOG(text)
  if not enable_log then
    return;
  end

  local logText = tostring(text)
  local logTimeStamp = os.date("%d, %m %Y %X")
  local popLog = io.open("tk_aggents_ritual.txt","a")

  popLog :write("TK AGENTS RITUAL:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
  popLog :flush()
  popLog :close()
end

local function TKARNEWLOG()
  if not enable_log then
    return;
  end

  local logTimeStamp = os.date("%d, %m %Y %X")

  local popLog = io.open("tk_aggents_ritual.txt","w+")
  popLog :write("NEW LOG ["..logTimeStamp.."] \n")
  popLog :flush()
  popLog :close() 
end
TKARNEWLOG()

local function tmb_agent_craft(faction, agent, is_mct)
  local faction_name = faction:name()
  local saved_value_id = faction_name.."_craft_number_"..agent
  local count = cm:get_saved_value(saved_value_id) or 1;

  -- if mct then use count from prev ritual
  -- and repeat prev ritual with new settings
  if is_mct then
    count = count - 1
    if count == 0 then return end;
  end;

  if count > tomb_king_max_crafted_agents then
    return;
  end;

  TKARLOG("ritual for "..agent..", ritual count is "..count);

  local effect_id = "tmb_agents_ritual_"..agent.."_scripted"

  if faction:has_effect_bundle(effect_id) then
    TKARLOG("remove old effect")
    cm:remove_effect_bundle(effect_id, faction_name);
  end;

  local effect_bundle = cm:create_new_custom_effect_bundle(effect_id);
  local cost_increase = math.min(count * ritual_cost_increace, 1900);  --100% + 19*100% = 20x base cost
	effect_bundle:add_effect("wh2_dlc09_effect_agent_cap_increase_tmb_"..agent, "faction_to_faction_own_unseen", count);
	effect_bundle:add_effect("tmb_agents_ritual_"..agent.."_cost_increase", "faction_to_faction_own_unseen", cost_increase);
  effect_bundle:set_duration(0);

  TKARLOG("new effect has been created")

  if count == tomb_king_max_crafted_agents then
    TKARLOG("cap is reached")
	  effect_bundle:add_effect("tmb_agents_ritual_"..agent.."_disable", "faction_to_faction_own_unseen", 1);
  end;

  cm:apply_custom_effect_bundle_to_faction(effect_bundle, faction);

  --save count for next ritual
  cm:set_saved_value(saved_value_id, count + 1);
  TKARLOG("applying effect is success")

end;

core:add_listener(
  "TMB_Agent_ritual_listener",
  "RitualCompletedEvent",
  function(context)
    return context:succeeded();
  end,
  function(context)
    local faction = context:performing_faction();
    local ritual_name = context:ritual():ritual_key();

    if ritual_name == "tmb_agents_ritual_liche_priest" then
      tmb_agent_craft(faction, "liche_priest")
    elseif ritual_name == "tmb_agents_ritual_tomb_prince" then
      tmb_agent_craft(faction, "tomb_prince")
    elseif ritual_name == "tmb_agents_ritual_necrotect" then
      tmb_agent_craft(faction, "necrotect")
    end;
  end,
  true
);

local function init_mcm(context)
  local mct = context:mct()
  local tmb_agents_rituals = mct:get_mod_by_key("tmb_agents_rituals")


  local max_crafted_agents_cfg = tmb_agents_rituals:get_option_by_key("max_agents_count")
  tomb_king_max_crafted_agents = tonumber(max_crafted_agents_cfg:get_finalized_setting())

  local ritual_cost_increace_cfg = tmb_agents_rituals:get_option_by_key("ritual_cost_increase")
  ritual_cost_increace = tonumber(ritual_cost_increace_cfg:get_finalized_setting())

  TKARLOG("tomb_king_max_crafted_agents now is "..tomb_king_max_crafted_agents)
  TKARLOG("ritual_cost_increace now is "..ritual_cost_increace)

end;

local function finalize_mcm()
  local faction = cm:model():world():whose_turn_is_it()
  tmb_agent_craft(faction, "liche_priest", true)
  tmb_agent_craft(faction, "tomb_prince", true)
  tmb_agent_craft(faction, "necrotect", true)
  if enable_log then
    cm:faction_add_pooled_resource(faction:name(), "tmb_canopic_jars", "wh2_main_resource_factor_other", 5000)
    cm:treasury_mod(faction:name(), 100000)
  end;
end;

core:add_listener(
    "tmb_agents_mct",
    "MctInitialized",
    true,
    function(context)
      init_mcm(context)
    end,
    true
)

core:add_listener(
    "tmb_agents_MctFinalized",
    "MctFinalized",
    true,
    function(context)
      init_mcm(context)
      finalize_mcm()
    end,
    true
)