function fish_greeting --description 'Write out the greeting prompt'
	if test -f ~/greeting.txt
		cat ~/greeting.txt
	end
end