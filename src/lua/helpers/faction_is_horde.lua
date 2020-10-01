--version from hunter & beast patch
local function srw_faction_is_horde(faction)
	return faction:is_allowed_to_capture_territory() == false;
end;
