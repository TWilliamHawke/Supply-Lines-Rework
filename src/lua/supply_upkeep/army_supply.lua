--====================================
-- Main script section start
--====================================

local function calculate_army_supply(unit_list, commander)
  local this_army_supply = basic_lord_supply;
  local character = commander:character_subtype_key()
  SRWLOG("--------");
  SRWLOG("Lord of this army is "..tostring(character));

  for j = 0, unit_list:num_items() - 1 do
    local unit = unit_list:item_at(j);
    local key = unit:unit_key();
    local val = helpers.get_unit_supply(key);

    if val == nil then
      val = helpers.calculate_unit_supply(unit)
    end;

    if SRW_Free_Units[key.."-"..character] ~= nil then
      val = SRW_Free_Units[key.."-"..character] + basic_unit_supply;
      SRWLOG(tostring(key).." REQUIRES "..val.."SP IN ARMY OF "..tostring(character));
    end

    if SRW_Lord_Group[character] then
      local name = SRW_Lord_Group[character]

      if SRW_Lord_Skills_Cost[key.."-"..name] ~= nil then
        local bonus_skill = SRW_Lord_Skills_Cost[key.."-"..name][1]
        local bonus_skill2 = SRW_Lord_Skills_Cost[key.."-"..name][3] or "srw_skill"

        if commander:has_skill(bonus_skill) or commander:has_skill(bonus_skill2) then
          val = SRW_Lord_Skills_Cost[key.."-"..name][2] + basic_unit_supply;
          SRWLOG(tostring(name).." HAS "..tostring(bonus_skill).." SO "..tostring(key).." REQUIRES "..val);
        end

      end --of skill in db check
    end --of lord in db check

    if val < 0 then
      val = 0
    end

    this_army_supply = this_army_supply + val;
  end; --of units circle
  
  SRWLOGDEBUG("[]CALCULATION SUPPLY FOR THIS ARMY IS FINISHED");
  return this_army_supply
end;

