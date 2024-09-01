function removeHash(t) -- I swear that if I don't put this, people will complain about why it doesn't work
    if string.sub(t, 1, 1) == "#" then
        return string.sub(t, 2)
    else
        return t
    end
end

function onEvent(name, v1, v2)
    if name == "Change Timebar Color" then
		newColor = removeHash(v1)
		setProperty('utilBarFill.color', getColorFromHex(newColor))   
    end
end
