--single army version of script
local function srw_this_army_upkeep(force)

  if force:faction():is_human() and not force:general_character():character_subtype("wh2_main_def_black_ark") then

    srw_calculate_upkeep(force)
  end; -- of local faction

end;
