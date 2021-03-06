--========================
-- Helpers for listeners
--========================

local function factionChecker(faction)
  local culture = faction:culture()
  local subculture = faction:subculture()

  if not faction:is_human() then
    return false
  end
  if helpers.srw_faction_is_horde(faction) then
    return false
  end
  if culture == "wh_main_brt_bretonnia" then
    return false
  end
  if subculture == "wh_main_sc_nor_warp" then
    return false
  end
  if subculture == "wh_main_sc_nor_troll" then
    return false
  end
  if culture == "wh2_dlc09_tmb_tomb_kings" then
    return false
  end
  return true
end;

local function uiFactionChecker()
  if ui_faction_check ~= nil then --from cache
    return ui_faction_check
  end

  local faction = cm:model():world():whose_turn_is_it()
  ui_faction_check = factionChecker(faction)
  return ui_faction_check
end;