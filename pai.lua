local EARLY_GAME_BOOST = {
	["wh_main_sc_chs_chaos"] = true,
	["wh_main_sc_nor_norsca"] = true,
	["wh_main_sc_dwf_dwarfs"] = false,
	["wh_main_sc_grn_greenskins"] = true,
	["wh_main_sc_grn_savage_orcs"] = true,
	["wh_main_sc_emp_empire"] = false,
	["wh_main_sc_ksl_kislev"] = false,
	["wh_main_sc_brt_bretonnia"] = false,
	["wh_main_sc_teb_teb"] = false,
	["wh_main_sc_vmp_vampire_counts"] = true,
	["wh_dlc03_sc_bst_beastmen"] = true,
	["wh_dlc05_sc_wef_wood_elves"] = false,
	["wh2_main_sc_def_dark_elves"] = true,
	["wh2_main_sc_hef_high_elves"] = true,
	["wh2_main_sc_lzd_lizardmen"] = false,
	["wh2_main_sc_skv_skaven"] = true,
	["wh2_dlc09_sc_tmb_tomb_kings"] = true,
	["wh2_dlc11_sc_cst_vampire_coast"] = true
};

local EVIL_FACTIONS = {
	["wh_main_sc_chs_chaos"] = true,
	["wh_main_sc_nor_norsca"] = true,
	["wh_main_sc_grn_greenskins"] = true,
	["wh_main_sc_grn_savage_orcs"] = true,
	["wh_main_sc_vmp_vampire_counts"] = true,
	["wh_dlc03_sc_bst_beastmen"] = true,
	["wh2_main_sc_def_dark_elves"] = true,
	["wh2_main_sc_skv_skaven"] = true,
	["wh2_dlc11_sc_cst_vampire_coast"] = true
};

local IGNORE_SAME_CULTURE = {
  ["wh_main_sc_grn_greenskins"] = true,
	["wh2_dlc11_sc_cst_vampire_coast"] = true,
	["wh_main_sc_vmp_vampire_counts"] = true,
	["wh2_main_sc_skv_skaven"] = true,
	["wh2_dlc09_sc_tmb_tomb_kings"] = true,
	["wh_dlc03_sc_bst_beastmen"] = true
};



--logging function.
local function PAILOG(text)
  if not __write_output_to_logfile then
    return;
  end

  local logText = tostring(text)
  local logTimeStamp = os.date("%d, %m %Y %X")
  local popLog = io.open("progressive_ai_bonus.txt","a")
  --# assume logTimeStamp: string
  popLog :write("PROGRESSIVE AI BONUS:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
  popLog :flush()
  popLog :close()
end

local function PAINEWLOG()
  if not (__write_output_to_logfile or __enable_jadlog) then
    return;
  end
  local logTimeStamp = os.date("%d, %m %Y %X")
  --# assume logTimeStamp: string

  local popLog = io.open("progressive_ai_bonus.txt","w+")
  popLog :write("NEW LOG ["..logTimeStamp.."] \n")
  popLog :flush()
  popLog :close() 
end
PAINEWLOG()

local function pai_culture_check(faction)
  PAILOG("-------------");
  PAILOG("CURRENT FACTION IS "..tostring(faction:name()));
  local subculture = faction:subculture();
  local this_turn = cm:model():turn_number();
  local player_faction = cm:get_local_faction();
  local player_subculture = cm:get_faction(player_faction):subculture();
  --IN ENGAME ALL AI FACTION GIVE FULL BONUS
  if this_turn >= 150 then
    PAILOG("WARHAMMER: ENDGAME");
    return true
  end;
  -- in Marcus Wulfhart campaign all lizardmen give bonus
  if subculture == "wh2_main_sc_lzd_lizardmen" and player_faction == "wh2_dlc13_emp_the_huntmarshals_expedition" then
    PAILOG("Marcus Wulfhart VS LIZARDMEN");
    return true
  end;
  if faction:name() == "wh2_dlc13_emp_the_huntmarshals_expedition" and player_subculture == "wh2_main_sc_lzd_lizardmen" then
    PAILOG("Marcus Wulfhart VS LIZARDMEN");
    return true
  end;
  --some factions are ignore next rules
  if IGNORE_SAME_CULTURE[subculture] then
    PAILOG("this faction always give bonus");
    return true
  end;
  --  dont give bonus if AI has same culture as player
  if player_subculture == subculture then
      PAILOG("SAME CULTURE AS PLAYER "..tostring(player_faction));
      return false
  end;
  if vfs.exists("script/campaign/main_warhammer/mod/jadawin_unnatural_selection_2.lua") then
    PAILOG("UnnaturalSelection 2 is enable");
    return true
  end;

  --in Vortex all cultures give bonus
  if cm:model():campaign_name("wh2_main_great_vortex") then
    PAILOG("Vortex - all cultures give bonus");
    return true
  end;
  --give bonus to good faction if player is evil
  if EVIL_FACTIONS[player_subculture] then
    PAILOG("give bonus to good faction if player is evil");
    return true
  end;
  --if player not evil see in list
  PAILOG("if player not evil see in list");
  return EARLY_GAME_BOOST[subculture]
end;

core:add_listener(
  "PAI_FactionTurnStart",
  "FactionTurnStart",
  function(context)
    local faction = context:faction()
    return not faction:is_human()
  end,  
  -- true,
  function(context)
    local faction = context:faction();
    local this_turn = cm:model():turn_number();
    local pai_culture_check = pai_culture_check(faction);

    if this_turn >= 30 and pai_culture_check and not faction:has_effect_bundle("pai_bonus_30") then
      cm:apply_effect_bundle("pai_bonus_30", faction:name(), 0)
      PAILOG("APPLY pai_bonus_30 TO FACTION "..tostring(faction:name()));
    end;
    if this_turn >= 60 and pai_culture_check and not faction:has_effect_bundle("pai_bonus_60") then
      cm:apply_effect_bundle("pai_bonus_60", faction:name(), 0)
      PAILOG("APPLY pai_bonus_60 TO FACTION "..tostring(faction:name()));
    end;
    if this_turn >= 90 and not faction:has_effect_bundle("pai_bonus_90") then
      cm:apply_effect_bundle("pai_bonus_90", faction:name(), 0)
      PAILOG("APPLY pai_bonus_90 TO FACTION "..tostring(faction:name()));
    end;   
    if this_turn >= 120 and not faction:has_effect_bundle("pai_bonus_120") then
      cm:apply_effect_bundle("pai_bonus_120", faction:name(), 0)
      PAILOG("APPLY pai_bonus_120 TO FACTION "..tostring(faction:name()));
    end;
    end,
  true
);

if not not SRW_Free_Units then
  PAILOG("supply lines rework")
end