core:add_listener(
    "supply_lines_MctFinalized",
    "MctFinalized",
    true,
    function(context)
      -- local mct = context:mct()
      -- local supply_lines_rw = mct:get_mod_by_key("supply_lines_rw")
      -- local ai_effect = supply_lines_rw:get_option_by_key("e_ai_effect")


      -- local settings_table = supply_lines_rw:get_settings() 
      -- bretonnia_supply = settings_table.c_bret_enable
      -- SRWLOGDEBUG("Bretonnia supply is finalized to "..tostring(bretonnia_supply));

      -- player_supply_custom_mult = settings_table.b_player_effect

      -- if not settings_table.a_player_enable then
      --   player_supply_custom_mult = 0
      -- end;

      -- ai_supply_mult = settings_table.e_ai_effect

      -- if not settings_table.d_ai_enable then
      --   ai_supply_mult = 0
      -- else
      --   ai_effect:set_uic_visibility(true)
      -- end;

      -- if settings_table.f_enable_logging then
      --   enable_logging = true
      -- end;

      -- if settings_table.g_enable_logging then
      --   enable_logging_ai = true
      -- end;
      
      -- if settings_table.h_enable_logging_debug then
      --   enable_logging = true
      --   enable_logging_ai = true
      --   enable_logging_debug = false
      --   SRWLOGDEBUG("Debug mode is enable");
      -- end;
      
      -- SRWLOGDEBUG("Ai supply set to "..tostring(ai_supply_mult));
      
      
      -- finalize_mct_srw()
      init_mcm(context)
    end,
    true
)

