local enable_logging = true

local function NCAILOGCORE(text)
  local logText = tostring(text)
  local popLog = io.open("twill_no_ai_conf.txt","a")
  popLog :write("SRW: "..logText .. "  \n")
  popLog :flush()
  popLog :close()
end

local function NCAISLOG(text)
  if not enable_logging then
    return;
  end
  NCAILOGCORE(text)
end


local function NCAISNEWLOG()
  local logTimeStamp = os.date("%d, %m %Y %X");

  local popLog = io.open("twill_no_ai_conf.txt","w+");
  popLog :write("NEW LOG ["..logTimeStamp.."] \n");
  popLog :flush();
  popLog :close();
end
NCAISNEWLOG()

local no_conf_subcultures = {
  ["wh_main_sc_emp_empire"] = "all",
  ["wh_main_sc_brt_bretonnia"] = "all",
  ["wh2_main_sc_def_dark_elves"] = "all",
  ["wh2_main_sc_hef_high_elves"] = "all",
  ["wh2_main_sc_lzd_lizardmen"] = "all",
  ["wh2_main_sc_skv_skaven"] = "all",
  ["wh_main_sc_dwf_dwarfs"] = "all",
  ["wh_dlc05_sc_wef_wood_elves"] = "all",
  ["wh_main_sc_grn_greenskins"] = "all",
  ["wh_main_sc_nor_norsca"] = "all",
  ["wh_main_sc_vmp_vampire_counts"] = "all",
};

local no_conf_main_factions = {
  ["wh_main_sc_emp_empire"] = { "wh_main_emp_empire", "wh2_dlc13_emp_the_huntmarshals_expedition", "wh_main_emp_middenland" },
  ["wh_main_sc_brt_bretonnia"] = { "wh_main_brt_bretonnia", "wh2_dlc14_brt_chevaliers_de_lyonesse" },
  ["wh2_main_sc_def_dark_elves"] = { "wh2_main_def_dark_elves", "wh2_main_def_cult_of_pleasure", "wh2_main_def_hag_graef", "wh2_dlc11_def_the_blessed_dread", "wh2_main_def_har_ganeth" },
  ["wh2_main_sc_hef_high_elves"] = { "wh2_main_hef_avelorn", "wh2_main_hef_nagarythe", "wh2_main_hef_yvresse", "wh2_dlc15_hef_imrik", "wh2_main_hef_order_of_loremasters", "wh2_main_hef_eataine" },
  ["wh2_main_sc_lzd_lizardmen"] = { "wh2_dlc12_lzd_cult_of_sotek", "wh2_main_lzd_itza", "wh2_dlc13_lzd_spirits_of_the_jungle", "wh2_main_lzd_last_defenders", "wh2_main_lzd_hexoatl" },
  ["wh2_main_sc_skv_skaven"] = { "wh2_main_skv_clan_skyre", "wh2_main_skv_clan_eshin", "wh2_main_skv_clan_pestilens", "wh2_main_skv_clan_mors", "wh2_main_skv_clan_moulder" },
  ["wh_main_sc_dwf_dwarfs"] = { "wh_main_dwf_karak_izor", "wh_main_dwf_dwarfs", "wh_main_dwf_karak_kadrin" },
  ["wh_dlc05_sc_wef_wood_elves"] = { "wh_dlc05_wef_wood_elves", "wh2_dlc16_wef_drycha", "wh2_dlc16_wef_sisters_of_twilight" },
  ["wh_main_sc_grn_greenskins"] = { "wh2_dlc15_grn_broken_axe", "wh2_dlc15_grn_bonerattlaz", "wh_main_grn_crooked_moon", "wh_main_grn_greenskins", "wh_main_grn_orcs_of_the_bloody_hand" },
  ["wh_main_sc_nor_norsca"] = { "wh_dlc08_nor_norsca", "wh_dlc08_nor_wintertooth" },
  ["wh_main_sc_vmp_vampire_counts"] = { "wh2_dlc11_vmp_the_barrow_legion", "wh_main_vmp_vampire_counts", "wh_main_vmp_schwartzhafen", "wh_main_vmp_mousillon", "wh_main_vmp_schwartzhafen" },
};

local function set_player_subcultures()
  local human_factions = cm:get_human_factions();
	for i = 1, #human_factions do
		local faction = cm:get_faction(human_factions[i]);
    no_conf_subcultures[faction:subculture()] = "player";
  end;

end;

--removed from major
--"wh2_dlc13_emp_golden_order",
--"wh_main_brt_carcassonne", "wh_main_brt_bordeleaux", 
--"wh2_main_lzd_tlaqua",
--"wh2_dlc09_skv_clan_rictus", 
--"wh_dlc05_wef_argwylon",

local function start_locking()
  set_player_subcultures()

  for subculture, permission in pairs(no_conf_subcultures) do

    NCAISLOG(subculture.." -- "..permission)

    if permission == "none" then
      cm:force_diplomacy("subculture:"..subculture, "subculture:"..subculture, "form confederation", false, false, false);

    elseif permission == "minor" then
      --enable conf for all
      cm:force_diplomacy("subculture:"..subculture, "subculture:"..subculture, "form confederation", true, true, false);

      --disable conf for major factions
      local major_factions = no_conf_main_factions[subculture];
      for i = 1, #major_factions do
        cm:force_diplomacy("subculture:"..subculture, "faction:"..major_factions[i], "form confederation", false, false, false);
      end
    elseif permission == "minor" then
      cm:force_diplomacy("subculture:"..subculture, "subculture:"..subculture, "form confederation", true, true, false);

    end; --of permission check
  end; --of first loope

  
  --Scripted lockings
  cm:force_diplomacy("faction:wh_main_vmp_rival_sylvanian_vamps", "faction:wh_main_vmp_vampire_counts", "form confederation", false, false, true);
	cm:force_diplomacy("faction:wh_main_vmp_rival_sylvanian_vamps", "faction:wh_main_vmp_schwartzhafen", "form confederation", false, false, true);
	cm:force_diplomacy("faction:wh2_dlc16_wef_drycha", "culture:wh_dlc05_wef_wood_elves", "form confederation", false, false);
	cm:force_diplomacy("faction:wh2_dlc16_wef_drycha", "faction:wh_dlc05_wef_argwylon", "form confederation", true, true);


end;

local function lock_major_confederation_again(faction_name)
  NCAISLOG("Start force block after confederation with minor faction")

  local faction = cm:get_faction(faction_name);
  local subculture = faction:subculture();

  set_player_subcultures()

  if no_conf_subcultures[subculture] == "minor" then

    local major_factions = no_conf_main_factions[subculture];
    for i = 1, #major_factions do
      if faction_name ~= major_factions[i] then
        NCAISLOG("Block confederation between "..faction_name.." and "..major_factions[i])
        cm:force_diplomacy("faction:" .. faction_name, "faction:"..major_factions[i], "form confederation", false, false, false);
      end;
    end

  elseif no_conf_subcultures[subculture] == "none" then

    NCAISLOG("Block confederation between "..faction_name.." and "..subculture)
    cm:force_diplomacy("faction:"..faction_name, "subculture:"..subculture, "form confederation", false, false, false);

  end;

end;



local function init_mcm(context)
  local mct = context:mct()
  local conf_conf = mct:get_mod_by_key("conf_conf")
  local prefix = "conf_conf_"

  for key, _ in pairs(no_conf_subcultures) do
    local option = conf_conf:get_option_by_key(prefix..key)
    no_conf_subcultures[key] = option:get_finalized_setting();
  end;
end;

core:add_listener(
  "confederation_expired",
  "ScriptEventConfederationExpired",
  function(context)    
    return true;
  end,
  function(context)
    local faction_name = context.string;
    cm:callback(function()
      NCAISLOG("======================");
      NCAISLOG("NEW BLOCK FOR "..faction_name);
      lock_major_confederation_again(faction_name) 
    end, 0.1);

  end,
  true
);


core:add_listener(
  "Conf_conf_joins_confederation",
  "FactionJoinsConfederation",
  function(context)    
    return true;
  end,
  function(context)
    local faction_name = context:faction():name();
    local confederation_name = context:confederation():name();
    NCAISLOG("Confederation between "..confederation_name.." and "..faction_name)
  end,
  true
);




core:add_listener(
  "Conf_conf_turn2",
  "FactionTurnStart",
  function(context)
    local faction = context:faction();
    return faction:is_human() and cm:model():turn_number() == 2;
  end,
  function(context)
    start_locking()
  end,
  true
)

core:add_listener(
    "Conf_conf_mct",
    "MctInitialized",
    true,
    function(context)
      init_mcm(context)
    end,
    true
)

core:add_listener(
    "Conf_conf_MctFinalized",
    "MctFinalized",
    true,
    function(context)
      init_mcm(context)
      start_locking()
    end,
    true
)
