on run input
	set cd_cmd to "cd ~" & input & "; clear;"
	tell application "Terminal"
		activate
		do script (cd_cmd)
	end tell
end run