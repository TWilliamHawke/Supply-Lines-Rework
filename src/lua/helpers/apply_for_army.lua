local function apply_effect(effect_strength, force, hide_log)
  local effect_bundle = "srw_bundle_force_upkeep_" .. effect_strength;

  cm:apply_effect_bundle_to_characters_force(effect_bundle, force:general_character():cqi(), -1, true);

  if not hide_log then
    SRWLOG("APPLY EFFECT: +"..tostring(effect_strength).."% TO UPKEEP");
  end
end;

local function remove_effect(force, hide_log)
  for k = 1, max_supply_per_army do
    local effect = "srw_bundle_force_upkeep_" .. k

    if force:has_effect_bundle(effect) then

      if not hide_log then
        SRWLOG("this army had "..tostring(effect));
      end;

      cm:remove_effect_bundle_from_characters_force(effect, force:general_character():cqi());
    end;

  end;
end;

