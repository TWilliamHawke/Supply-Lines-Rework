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
  local logTimeStamp = os.date("%d, %m %Y %X")

  local popLog = io.open("twill_no_ai_conf.txt","w+")
  popLog :write("NEW LOG ["..logTimeStamp.."] \n")
  popLog :flush()
  popLog :close() 
end
NCAISNEWLOG()

local no_conf_subcultures = {
  "wh_main_sc_emp_empire",
  "wh_main_sc_brt_bretonnia",
  "wh2_main_sc_def_dark_elves",
  "wh2_main_sc_hef_high_elves",
  "wh2_main_sc_lzd_lizardmen",
  "wh2_main_sc_skv_skaven",
  "wh_main_sc_dwf_dwarfs",
};

local function start_locking(player_faction)
  local faction_name = player_faction:name();
  local subculture = player_faction:subculture();
  NCAISLOG("disable confederation for all, excluding "..faction_name);
  
  for i = 1, #no_conf_subcultures do
    cm:force_diplomacy("subculture:"..no_conf_subcultures[i], "subculture:"..no_conf_subcultures[i], "form confederation", false, false, false);
  end;
  cm:force_diplomacy("faction:"..faction_name, "subculture:"..subculture, "form confederation", true, false, false);
end;


core:add_listener(
  "SRW_T",
  "FactionTurnStart",
  function(context)
    local faction = context:faction();
    return faction:is_human() and cm:model():turn_number() == 2;
  end,
  function(context)
    local faction = context:faction();
    start_locking(faction)
  end,
  true
)

-- core:add_listener(
--   "SRW_T2",
--   "FactionTurnEnd",
--   function(context)
--     local faction = context:faction();
--     return faction:is_human();
--   end,
--   function(context)
--     local faction = context:faction();
--     start_locking(faction)
--   end,
--   true
-- )
