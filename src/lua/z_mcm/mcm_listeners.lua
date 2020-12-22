core:add_listener(
    "supply_lines_mct",
    "MctInitialized",
    true,
    function(context)
      init_mcm(context)
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
    end,
    true
)

