local game_lang = nil

local function get_game_language()
  if game_lang then return game_lang end;

  local langfile, err = io.open("data/language.txt","r")

  if langfile then
    game_lang = langfile:read()
    langfile:close()
  else
    game_lang = "EN"
  end
  
  return game_lang
end