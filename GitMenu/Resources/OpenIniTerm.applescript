on run input
	set cd_cmd to "cd " & input & "; clear;"
	tell application "iTerm"
		activate
		local myWindow
		if number of windows is less than 1 then
			set myWindow to (create window with default profile)
		else
			set myWindow to (current window)
		end if
		delay 3
		tell current session of myWindow
			write text cd_cmd
		end tell
	end tell
	
end run