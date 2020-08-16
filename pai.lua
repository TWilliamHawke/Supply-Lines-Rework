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

local function pai_culture_check(faction, this_turn)
  PAILOG("-------------");
  PAILOG("CURRENT FACTION IS "..tostring(faction:name()));
  local subculture = faction:subculture();
  local player_faction = cm:get_local_faction();
  local player_subculture = cm:get_faction(player_faction):subculture();
  --IN ENGAME ALL AI FACTION GIVE FULL BONUS
  if this_turn >= 150 then
    PAILOG("WARHAMMER: ENDGAME");
    return true
  end;
  --  dont give bonus if AI has same culture as player
  if player_subculture == subculture then
      PAILOG("SAME CULTURE AS PLAYER "..tostring(player_faction));
      return false
  end;
  PAILOG("NOT SAME CULTURE AS PLAYER");
  return true
end;

local function apply_bonus(faction, turn, this_turn)
  if this_turn < turn then 
    return
  end

  local subculture = faction:subculture();
  local effect_name = ("pai_bonus_"..tostring(turn))
  
  if subculture == "wh2_dlc09_sc_tmb_tomb_kings" then
    effect_name = ("pai_bonus_"..tostring(turn).."_tmb")
  end
  
  if not faction:has_effect_bundle(effect_name) then
    local faction_name = faction:name()
    cm:apply_effect_bundle(effect_name, faction_name, 0)
    PAILOG("APPLY "..effect_name.." TO FACTION "..tostring(faction_name));
  end;

end

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
    local pai_culture_check = pai_culture_check(faction, this_turn);
    
    if pai_culture_check then
      apply_bonus(faction, 30, this_turn)
      apply_bonus(faction, 60, this_turn)
      apply_bonus(faction, 90, this_turn)
      apply_bonus(faction, 120, this_turn)
    end;
  end,
  true
);

if not not SRW_Free_Units then
  PAILOG("supply lines rework")
end