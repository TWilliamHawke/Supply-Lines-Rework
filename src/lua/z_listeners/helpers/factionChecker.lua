local function factionChecker(faction)
  local culture = faction:culture()
  if not faction:is_human() then
    return false
  end
  if srw_faction_is_horde(faction) then
    return false
  end
  if culture == "wh_main_brt_bretonnia" and not bretonnia_supply then
    return false
  end
  if culture == "wh2_dlc09_tmb_tomb_kings" then
    return false
  end
  return true
end;

