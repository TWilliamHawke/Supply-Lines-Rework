-------------------------------------------------------------------------------
---------------------- GUARANTEED MAJOR FACTION EMPIRES -----------------------
-------------------------------------------------------------------------------
----------------------------- CREATED BY MITCH --------------------------------
-------------------------------------------------------------------------------
module(..., package.seeall);

local scripting = require "lua_scripts.EpisodicScripting"
local debugLog = true;
local logPath = "EmpiresLog.txt";

----------------------------------------------------
-- Function called when a new campaign is started --
----------------------------------------------------

local major_factions = {
	"rom_rome",
	"rom_carthage",
	"rom_iceni",
	"rom_macedon",
	"rom_ptolemaics",
	"rom_seleucid",
	"rom_sparta",
	"rom_ardiaei",
	"rom_arevaci",
	"rom_armenia",
	"rom_arverni",
	"rom_athens",
	"rom_baktria",
	"rom_boii",
	"rom_cimmeria",
	"rom_colchis",
	"rom_epirus",
	"rom_galatia",
	"rom_getae",
	"rom_lusitani",
	"rom_masaesyli",
	"rom_massagetae",
	"rom_massilia",
	"rom_nabatea",
	"rom_nervii",
	"rom_odryssia",
	"rom_parthia",
	"rom_pergamon",
	"rom_pontus",
	"rom_roxolani",
	"rom_saba",
	"rom_scythia",
	"rom_suebi",
	"rom_tylis",
	"rom_syracuse",
	"pro_rome",
	"pro_rome",
	"pro_rome",
	-- "gaul_arverni",
	-- "gaul_rome",
	-- "gaul_nervii",
	-- "gaul_suebi",
	-- "pun_carthage",
	-- "pun_rome",
	-- "pun_syracuse",
	-- "pun_lusitani",
	-- "pun_arevaci",
	"emp_octavian",
	"emp_antony",
	"emp_armenia",
	"emp_dacia",
	"emp_egypt",
	"emp_iceni",
	"emp_lepidus",
	"emp_marcomanni",
	"emp_parthia",
	"emp_pompey",
	-- "pel_athenai",
	-- "pel_sparta",
	-- "pel_boiotia",
	-- "pel_korinthos",
	"3c_rome",
	"3c_armenia",
	"3c_palmyra",
	"3c_gallicemp",
	"3c_sassanid",
	"3c_alani",
	"3c_caledoni",
	"3c_gothi",
	"3c_marcomanni",
	"3c_saxoni",
	"rom_kush",
	-- "inv_insubres",
	-- "inv_iolei",
	-- "inv_rome",
	-- "inv_samnites",
	-- "inv_senones",
	-- "inv_syracuse",
	-- "inv_taranto",
	-- "inv_tarchuna",
	-- "inv_veneti"
};

local far_esat = {
	"rom_aria",
	"rom_arachosia",
	"rom_parthava",
	"rom_sagartia",
	"rom_ardhan",
	"rom_drangiana",
}

local function player_is_major(player_name)
	for _, faction_name in pairs(major_factions) do
		if (player_name == faction_name) then
			return true;
		end
	end;
	return false;
end;

local function apply_effect_for_player()
	local faction_list = scripting.game_interface:model():world():faction_list();
	for i = 0, faction_list:num_items() - 1 do
		local curr_faction = faction_list:item_at(i);

		if (curr_faction:is_human() == true) then
			local player_name = curr_faction:name();

			if (not player_is_major(player_name)) then
				scripting.game_interface:apply_effect_bundle("great_faction", player_name, -1)
				Log("apply effect for "..player_name);
			end
		end
	end
end;

-----------------------------------------------
---- Creates a log file in the data folder ----
-----------------------------------------------
function CreateLog()
	if debugLog == true then
    local logTimeStamp = os.date("%d, %m %Y %X")

		local logInterface = io.open(logPath,"w");
		logInterface:write("##########################################\n");
    logInterface :write("NEW LOG ["..logTimeStamp.."] \n")
		logInterface:flush();
		logInterface:close();
	end
end;

-----------------------------------------------------
---- Appends passed text to an existing log file ----
-----------------------------------------------------
function Log(text)
	if debugLog == true then
		local logInterface = io.open(logPath,"a");
		logInterface:write(text.."\n");
		logInterface:flush();
		logInterface:close();
	end
end;

local function OnNewCampaignStarted()
  --if scripting.game_interface:model():turn_number() ~= 1 then return end;
	CreateLog();
	
  for _, faction_name in pairs(major_factions) do
    scripting.game_interface:apply_effect_bundle("great_faction", faction_name, -1)
  end;
	
	apply_effect_for_player();

end



-- Event call backs
scripting.AddEventCallBack("NewCampaignStarted", OnNewCampaignStarted)
