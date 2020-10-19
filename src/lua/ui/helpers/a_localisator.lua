local function localizator(string)
  local langfile, err = io.open("data/language.txt","r")
  if langfile then
    local lang = langfile:read()
    langfile:close()
    local local_string = string
    if lang == "RU" then 
      local_string = string.."_ru"
    end
    return effect.get_localised_string(local_string)
  else
    return effect.get_localised_string(string)
  end
end;

