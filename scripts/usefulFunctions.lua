local actualSetObjectCamera = setObjectCamera

function setObjectCamera(object,camera) -- this will be used until there is a psych engine hotfix for the function
	-- thank you Tiphy03 for the function :D
    if string.lower(camera) == "game" then camera = "camGame" end
    if string.lower(camera) == "camgame" then camera = "camGame" end

    if string.lower(camera) == "hud" then camera = "camHUD" end
    if string.lower(camera) == "camhud" then camera = "camHUD" end

    if string.lower(camera) == "other" then camera = "camOther" end
    if string.lower(camera) == "camother" then camera = "camOther" end

    if (camera == "camGame") or (camera == "camHUD") or (camera == "camOther") then
        return setProperty(object..'.camera',instanceArg(camera),false,true)
    end
end

function formatNumberWithCommas(number)
    number = math.floor(number)
    
    local formatted = tostring(number)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end