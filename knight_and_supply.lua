local enable_logging = true

local function KNASLOGCORE(text)
  local logText = tostring(text)
  local popLog = io.open("supply_rework_log.txt","a")
  popLog :write("SRW: "..logText .. "  \n")
  popLog :flush();
  popLog :close();
end

local function KNASLOG(text)
  if not enable_logging then
    return;
  end
  KNASLOGCORE(text)
end


local function KNASNEWLOG()
  local logTimeStamp = os.date("%d, %m %Y %X")

  local popLog = io.open("supply_rework_log.txt","w+")
  popLog :write("NEW LOG ["..logTimeStamp.."] \n")
  popLog :flush();
  popLog :close();
end
KNASNEWLOG()

local function set_bretonnia_army_supply(force)
  local knas_supply_balance = 0

  local unit_list = force:unit_list();
  local character = force:general_character();

end

local function set_bretonnia_faction_supply(faction)
  local force_list = faction:military_force_list();

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() then
      KNASLOG("--------");
      KNASLOG("CHECK ARMY #"..tostring(i));
      set_bretonnia_army_supply(force)
    end; --of army check
  end; --of force_list loop

end

core:add_listener(
  "KNAS_FactionTurnStart",
  "FactionTurnStart",
  function(context)
    local faction = context:faction()
    return faction:culture() == "wh_main_brt_bretonnia" and faction:is_human()
  end,  
  -- true,
  function(context) 
    local faction = context:faction();
    KNASLOG("======================");
    KNASLOG("APPLY UPKEEP (TURN START)");
    set_bretonnia_faction_supply(faction);
  end,
  true
);

core:add_listener(
  "KNAS_FactionTurnEnd",
  "FactionTurnEnd",
  function(context)
    local faction = context:faction()
    return faction:culture() == "wh_main_brt_bretonnia" and faction:is_human()
  end,  
  -- true,
  function(context) 
    local faction = context:faction();
    KNASLOG("======================");
    KNASLOG("APPLY UPKEEP (TURN END)");
    set_bretonnia_faction_supply(faction);
  end,
  true
);
