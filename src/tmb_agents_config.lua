local loc_prefix = "mct_tmb_agents_"


local tmb_agents_rituals = mct:register_mod("tmb_agents_rituals")
tmb_agents_rituals:set_title(loc_prefix.."mod_title", true)
tmb_agents_rituals:set_author("TWilliam")
tmb_agents_rituals:set_description(loc_prefix.."mod_desc", true)

local max_agents_count = tmb_agents_rituals:add_new_option("max_agents_count", "dropdown")
max_agents_count:set_text("mct_tmb_agents_max_agents_count_text", true)
max_agents_count:set_tooltip_text("mct_tmb_agents_max_agents_count_tt", true)
max_agents_count:add_dropdown_values({
  {key = "25", text = "25", tt = "You can perform each ritual 25 times", is_default = true},
  {key = "50", text = "50", tt = "You can perform each ritual 50 times", is_default = false},
  {key = "75", text = "75", tt = "You can perform each ritual 50 times", is_default = false},
  {key = "100", text = "100", tt = "You can perform each ritual 100 times", is_default = false},
})

local ritual_cost_increase = tmb_agents_rituals:add_new_option("ritual_cost_increase", "dropdown")
ritual_cost_increase:set_text("mct_tmb_agents_ritual_cost_increase_text", true)
ritual_cost_increase:set_tooltip_text("mct_tmb_agents_ritual_cost_increase_tt", true)
ritual_cost_increase:add_dropdown_values({
  {key = "100", text = "100%", tt = "Ritual cost will increase by 100% for each ritual", is_default = true},
  {key = "50", text = "50%", tt = "Ritual cost will increase by 50% for each ritual", is_default = false},
  {key = "25", text = "25%", tt = "Ritual cost will increase by 25% for each ritual", is_default = false},
  {key = "0", text = "0%", tt = "Ritual cost will not increase", is_default = false},
})