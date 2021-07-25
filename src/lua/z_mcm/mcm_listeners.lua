core:add_listener(
    "supply_lines_mct",
    "MctInitialized",
    true,
    function(context)
      init_mcm(context)
      subculture_text = nil;
    end,
    true
)



core:add_listener(
    "supply_lines_MctFinalized",
    "MctFinalized",
    true,
    function(context)
      init_mcm(context)
      finalize_mcm()
      subculture_text = nil;
    end,
    true
)

