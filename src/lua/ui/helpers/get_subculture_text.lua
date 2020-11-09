local function get_subculture_text(culture)
  local dummy_text = "SRW_dummy_text"
  local lord_text_key = SRW_Subculture_Text[culture] or dummy_text
  local subculture_text = localizator(lord_text_key)

  for k=1, #supported_mods_prefix do
    local path = supported_mods_prefix[k][1]
    local prefix = supported_mods_prefix[k][2]

    if vfs.exists(path) then
      local string_key = modded_subculture_text[prefix..culture] or dummy_text
      subculture_text = subculture_text..localizator(string_key)
    end;
  end;

  return subculture_text
end;