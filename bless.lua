local CHAOS_FACTION = {
	["wh2_main_chs_chaos_incursion_def"] = true,
	["wh2_main_chs_chaos_incursion_hef"] = true,
	["wh2_main_chs_chaos_incursion_lzd"] = true,
	["wh2_main_chs_chaos_incursion_skv"] = true,
	["wh2_main_nor_hung_incursion_def"] = true,
	["wh2_main_nor_hung_incursion_hef"] = true,
	["wh2_main_nor_hung_incursion_lzd"] = true,
	["wh2_main_nor_hung_incursion_skv"] = true,
  ["wh_main_chs_chaos"] = true,
  ["wh_main_nor_bjornling"] = true,
  ["wh_dlc03_bst_beastmen_chaos"] = true
};


local SKAVEN_FACTION = {
	["wh2_main_skv_unknown_clan_def"] = true,
	["wh2_main_skv_unknown_clan_hef"] = true,
	["wh2_main_skv_unknown_clan_lzd"] = true,
	["wh2_main_skv_unknown_clan_skv"] = true
}


--logging function.
local function BLESSLOG(text)
  if not __write_output_to_logfile then
    return;
  end

  local logText = tostring(text)
  local logTimeStamp = os.date("%d, %m %Y %X")
  local popLog = io.open("blessed_ai_armies.txt","a")
  --# assume logTimeStamp: string
  popLog :write("PROGRESSIVE AI BONUS:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
  popLog :flush()
  popLog :close()
end

local function BLESSNEWLOG()
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
  BLESSLOG("-------------");
  BLESSLOG("CURRENT FACTION IS "..tostring(faction:name()));
  local subculture = faction:subculture();
  local this_turn = cm:model():turn_number();
  local player_faction = cm:get_local_faction();
  local player_subculture = cm:get_faction(player_faction):subculture();
  --IN ENGAME ALL AI FACTION GIVE FULL BONUS
  if this_turn >= 150 then
    BLESSLOG("WARHAMMER: ENDGAME");
    return true
  end;
  --  dont give bonus if AI has same culture as player
  if player_subculture == subculture then
    BLESSLOG("SAME CULTURE AS PLAYER "..tostring(player_faction));
      return false
  end;
  BLESSLOG("NOT SAME CULTURE AS PLAYER");
  return true
end;

core:add_listener(
  "Bless_FactionTurnStart",
  "FactionTurnStart",
  function(context)
    local name = faction:name()
    if faction:is_human() then
      return false
    end
    if CHAOS_FACTION[name] then
      return true
    end
    if SKAVEN_FACTION[name] then
      return true
    end
    return false  
  end,  
  -- true,
  function(context)
    local faction = context:faction();
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if not force:is_armed_citizenry() and force:has_general() then
        BLESSLOG("Select bless")
      end; --of army check
    end; --of army call
  end,
  true
);
