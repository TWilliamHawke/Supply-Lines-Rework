function set_value_from_mcm(name, variable)
  local mct = context:mct()
  local supply_lines_rw = mct:get_mod_by_key("supply_lines_rw")

  local mcm_setting = supply_lines_rw:get_option_by_key(name)
  variable =  mcm_setting:get_finalized_setting()

  return mcm_setting
end