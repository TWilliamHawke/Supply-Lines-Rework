local subculture_text = nil;

function helpers.get_subculture_text(culture)
  if subculture_text then
    return subculture_text
  end

  local dummy_text = "SRW_dummy_text"
  local lord_text_key = SRW_Subculture_Text[culture] or dummy_text
  subculture_text = helpers.localizator(lord_text_key)

  for k=1, #supported_mods_prefix do
    local path = supported_mods_prefix[k][1]
    local prefix = supported_mods_prefix[k][2]

    if vfs.exists(path) then
      local string_key = modded_subculture_text[prefix..culture] or dummy_text
      subculture_text = subculture_text..helpers.localizator(string_key)
    end;
  end;

  return subculture_text
end;

