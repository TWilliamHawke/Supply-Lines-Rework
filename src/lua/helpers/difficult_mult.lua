--calculate upkeep modificator
local function srw_get_diff_mult()
  if player_supply_custom_mult == "disabled" then
    local difficulty = cm:model():combined_difficulty_level();
    local mod = 2;				-- easy
    
    if difficulty == 0 then
      mod = 3;				-- normal
    elseif difficulty == -1 then
      mod = 5;					-- hard
    elseif difficulty == -2 then
      mod = 8;			-- very hard
    elseif difficulty == -3 then
      mod = 8;			-- legendary
    end;

    return mod;

  else
    return player_supply_custom_mult
  end
end;

