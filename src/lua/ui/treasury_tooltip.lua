local function set_tooltip_text_treasury(faction, component_name)
  SRWLOGDEBUG("--------");
  SRWLOGDEBUG("SET TREASURY TOOLTIP FUNCTION IS STARTED");

  local culture = faction:subculture();
  local component = find_uicomponent(core:get_ui_root(), component_name)
  local global_supply = 0
  local upkeep_percent = -1
  local dif_mod = srw_get_diff_mult();
  local force_list = faction:military_force_list();
  local dummy_text = "SRW_dummy_text"
  local lord_text_key = SRW_Subculture_Text[culture] or dummy_text
  local lord_text = localizator(lord_text_key)
  local supply_balance = get_supply_balance(faction)

  -- calculate supply and upkeep
  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
      local unit_list = force:unit_list();
      local character = force:general_character();

      local army_supply = calculate_army_supply(unit_list, character);
      local army_upkeep_effect = math.floor(army_supply*dif_mod/24)
      global_supply = global_supply + army_supply
      upkeep_percent = upkeep_percent + math.min(army_upkeep_effect, max_supply_per_army) + 1
    end; --of army check
  end; --of army call
  if upkeep_percent < 0 then upkeep_percent = 0 end;

  --generate text

  if vfs.exists("script/campaign/main_warhammer/mod/mixu_le_bruckner.lua") then
    local mixu1_text = Mixu1_Subculture_Text[culture] or dummy_text
    lord_text = lord_text..localizator(mixu1_text)
  end;

  if vfs.exists("script/campaign/mod/mixu_darkhand.lua") then
    local mixu2_text = Mixu2_Subculture_Text[culture] or dummy_text
    lord_text = lord_text..localizator(mixu2_text)
  end;

  if vfs.exists("script/campaign/mod/cataph_kraka.lua") then
    local kraka_text = Kraka_Subculture_Text[culture] or dummy_text
    lord_text = lord_text..localizator(kraka_text)
  end;

  if vfs.exists("script/campaign/main_warhammer/mod/thom_vulkan.lua") then
    local vulcan_text = Vulcan_Subculture_Text[culture] or dummy_text
    lord_text = lord_text..localizator(vulcan_text)
  end;

  local supply_text = localizator("SRW_treasury_tooltip_supply")
  supply_text = string.gsub(supply_text, "SRW_supply", tostring(global_supply))
  local supply_balance_text = "Your supply balance is "..supply_balance
  if not enable_supply_balance then
    supply_balance_text = ""
  end
  local tooltip_text = localizator("SRW_treasury_tooltip_main")..lord_text..supply_text..localizator("SRW_treasury_tooltip_upkeep")..tostring(upkeep_percent).."%\n"..supply_balance_text

  if srw_faction_is_horde(faction) then
    tooltip_text = localizator("SRW_Subculture_Text_hordes")
  elseif culture == "wh2_dlc09_sc_tmb_tomb_kings" then
    tooltip_text = localizator("SRW_Subculture_Text_tomb_kings")
  elseif culture == "wh_main_sc_brt_bretonnia" then
    tooltip_text = localizator("SRW_Subculture_Text_bretonnia")
  elseif player_supply_custom_mult == 0 then
    tooltip_text = "Your units doesn`t need addition supply"
  end;

  --apply text
  component:SetTooltipText(tooltip_text, true)
  SRWLOGDEBUG("SET TREASURY TOOLTIP FUNCTION IS FINISHED");

end;

