local function finalize_mcm()

  local faction = cm:model():world():whose_turn_is_it()
  if not factionChecker(faction) then
    player_supply_custom_mult = 0
  else
    srw_apply_upkeep_penalty(faction);
    calculate_supply_balance(faction);
  end
  
  SRWLOGDEBUG("Player supply now is "..tostring(player_supply_custom_mult));
end;