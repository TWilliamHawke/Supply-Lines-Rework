--version from hunter & beast patch
function helpers.srw_faction_is_horde(faction)
	return faction:is_allowed_to_capture_territory() == false;
end;
