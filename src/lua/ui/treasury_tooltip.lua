local function set_tooltip_text_treasury(faction, component_name)
  SRWLOGDEBUG("--------");
  SRWLOGDEBUG("SET TREASURY TOOLTIP FUNCTION IS STARTED");

  local culture = faction:subculture();
  local component = find_uicomponent(core:get_ui_root(), component_name)

  local tooltip_text = ""

  if helpers.srw_faction_is_horde(faction) or culture == "wh_main_sc_nor_warp" or culture == "wh_main_sc_nor_troll" then
    tooltip_text = helpers.localizator("SRW_Subculture_Text_hordes")
  elseif culture == "wh2_dlc09_sc_tmb_tomb_kings" then
    tooltip_text = helpers.localizator("SRW_Subculture_Text_tomb_kings")
  elseif culture == "wh_main_sc_brt_bretonnia" then
    tooltip_text = helpers.localizator("SRW_Subculture_Text_bretonnia")
  elseif player_supply_custom_mult == 0 then
    tooltip_text = "Your units doesn`t need addition supply"
  else
    tooltip_text = helpers.construct_treasury_tooltip(faction)
  end;


  --apply text
  if is_uicomponent(component) then 
    component:SetTooltipText(tooltip_text, true)
  end;
  SRWLOGDEBUG("SET TREASURY TOOLTIP FUNCTION IS FINISHED");

end;

