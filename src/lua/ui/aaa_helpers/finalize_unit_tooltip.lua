function helpers.finalize_unit_tooltip(component, supply_text, regexp)
  local old_text = component:GetTooltipText();

  if string.find(old_text, supply_text) then return end

  local final_text = string.gsub(old_text, regexp, regexp.."[[col:yellow]]"..supply_text.."[[/col]]\n", 1)
  
  if is_uicomponent(component) then 
    component:SetTooltipText(final_text, true)
  end;

end;