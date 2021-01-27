-- Configure
local SRW_selected_character = nil;
local max_supply_per_army = 38;  -- max effect number in effect_bundles_tables
local ai_supply_enabled = false;
local ai_supply_mult = 0
local player_supply_custom_mult = "disabled"
local bretonnia_supply = false
local basic_unit_supply = 0
local basic_lord_supply = 0
local enable_supply_balance = false
local max_balance_per_buildings = 3
local max_balance_per_army = 30
local big_empire_penalty_start = 999;
--Cached values
local ui_faction_check = nil;
local block_scripts = false;

local helpers = {}