local function apply_supply_balance_effect(faction, effect_strength)
  local effect_name = "srw_bundle_supply_balance_"..math.min(effect_strength, 25)
  cm:apply_effect_bundle(effect_name, faction:name(), -1)
end

local function remove_supply_balance_effect(faction)
  for i = 1, 25 do
    local effect_name = "srw_bundle_supply_balance_"..i
    
    if faction:has_effect_bundle(effect_name) then
      cm:remove_effect_bundle(effect_name, faction:name());
    end;

  end;
  
end;
