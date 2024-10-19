-------------------- Time Bar --------------------

local timeTxtModern = getModSetting('moderntimetext')
local timeTxtZoomOnBeat = getModSetting('bouncingtimetext')
local timeBarStyle = getModSetting('timebarstyle')
local timeBarGradient = getModSetting('timebargradient')
local timeBarOpponentColor = getModSetting('timebaropponentcolor')
local timeBarColorR = getModSetting('timebarcolorrgbred')
local timeBarColorG = getModSetting('timebarcolorrgbgreen')
local timeBarColorB = getModSetting('timebarcolorrgbblue')

local timeBarThickness = .04
local timeBarBorder = .03
local timeBarLength = 1.965
local timeBarX = 312
local timeBarY = 12.5

local timeBarFillColor = '00ff00'
local timeBarEmptyColor = '000000'
local timeBarBorderColor = '000000'

local hasTimeTxtBefore = false
local timeTxtBefore = ''
local timeTxtX = screenWidth/2
local timeTxtY = not downscroll and 20 or screenHeight - 42
local timeTxtSize = 30
local timeTxtAlpha = 1

-------------------- Health Bar --------------------

local smoothHealthBar = getModSetting('smoothhealthbar')
local customHBColors = getModSetting('customhbcolors')
local hbP1ColorR = getModSetting('healthcolorp1rgbred')
local hbP1ColorG = getModSetting('healthcolorp1rgbgreen')
local hbP1ColorB = getModSetting('healthcolorp1rgbblue')
local hbP2ColorR = getModSetting('healthcolorp2rgbred')
local hbP2ColorG = getModSetting('healthcolorp2rgbgreen')
local hbP2ColorB = getModSetting('healthcolorp2rgbblue')

-------------------- Interface --------------------

local animatedHudEnabled = getModSetting('animatedhudenabled')
local randomBotplayText = getModSetting('randombotplaytext')
local showReasonGO = getModSetting('showreasongo')
local ratingCounterEnabled = getModSetting('ratingcounterenabled')
local fullFcName = getModSetting('fullfcname')
local scoreVisible = not getModSetting('hidescore')
local compactScore = getModSetting('compactscore')
local scoreSize = getModSetting('scoresize')
local showNPS = getModSetting('shownps')
local getBotScore = getModSetting('getbotscore')
local susNotesSplash = getModSetting('susnotessplash')
local resultScreen = getModSetting('resultscreen')
local debugPrints = getModSetting('debugprints')
local nowPlayingPopup = getModSetting('nowplayingpopup')
local nowPlayingPosition = getModSetting('nowplayingposition')
local nowPlayingDuration = getModSetting('nowplayingduration')

-------------------- Ratings --------------------

local newRatingEnabled = getModSetting('newratings')

-------------------- Gameplay --------------------

local onlyMarvelous = getModSetting('onlymarvelous')
local onlyMarvelousVolume = getModSetting('onlymarvelousvolume')
local onlyMarvelousType = getModSetting('onlymarveloustype')
local opponentPlay = getModSetting('opponentplay')

-------------------- Misc --------------------

local font = 'vcr.ttf'
local divider = ' • '

local actualSetObjectCamera = setObjectCamera
local sName = 'UH' -- do not change this, changing it will hinder the process of finding errors
local usedCheats = false

local rsPTE = false
local rsLMO = false
local rsEBA = false
local rsPT = 0
local rsGU = true

local actHighCombo = 0
local actMarvelous = 0
local actSick = 0
local actGood = 0
local actBad = 0
local actShit = 0
local actMisses = 0

local rating = ""

------------------------------------------------

function onCreate()
	local blockVersionBeforePrefixes = {'0.3', '0.4', '0.5', '0.6', '0.7'}
	local blockVersionAfterPrefixes = {'2.0'}
	local minimalVersion = '1.0'

	local versions = getVersions()

	for k, v in pairs(blockVersionAfterPrefixes) do
		if version:find('^'..v:gsub("^%s*(.-)%s*$", "%1")) ~= nil then
			debugPrint("------------------------------------------------------")
			debugPrint("We are waiting for you!")
			debugPrint("You can use Util Peaks in version "..minimalVersion)
			debugPrint("")
			debugPrint("Your Version: "..version)
			debugPrint("")
			debugPrint("we haven't ported everything to it yet!")
			debugPrint("You have a very updated version of Psych Engine,")
			debugPrint("")
			debugPrint("with Util Peaks!")
			debugPrint("Uh-oh, your version of Psych Engine is not compatible")
			debugPrint("------------------------------------------------------")
			setVar("utilEnabled", false)
			close()
			return
		end
	end

	for k, v in pairs(blockVersionBeforePrefixes) do
		if version:find('^'..v:gsub("^%s*(.-)%s*$", "%1")) ~= nil then
			debugPrint("--------------------------------------------------------")
			debugPrint("Thank you for your interest in Util Peaks!!!")
			debugPrint("")
			debugPrint("We require you to have at least version: "..minimalVersion.." or higher")
			debugPrint("Your Version: "..version)
			debugPrint("")
			debugPrint("with Util Peaks!")
			debugPrint("Uh-oh, your version of Psych Engine is not compatible")
			debugPrint("--------------------------------------------------------")
			setVar("utilEnabled", false)
			close()
			return
		end
	end

	setVar("utilEnabled", true)
	setVar("utilLoadDebug", false) -- prints debug texts to see if each script loads

	if debugPrints then
		local anyError = versions.fError
		local peVersion = versions.peVer
        local utilVersion = versions.uVer

		if anyError == false then
			debugPrint(sName..': ----------------------')
			debugPrint(sName..': In Psych Engine '..peVersion)
			debugPrint(sName..': Running Util Peaks '..utilVersion)
		else
			debugPrint(sName..': ERROR: Txt Error while trying to get Util Peaks Version!')
		end
		setVar("utilSDP", true)
	else
		setVar("utilSDP", false)
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

function onCreatePost()
	local gAA = getPropertyFromClass("ClientPrefs", "globalAntialiasing")
	scoreHitSizeEnabled = getPropertyFromClass('backend.ClientPrefs', 'data.scoreZoom')

	--// getting dad health bar color
	local dadColFinal = string.format('%02x%02x%02x', dadColR, dadColG, dadColB)

	--// creating the custom timebar
	local oldVisibleBar = getProperty('timeBar.visible') -- this tries to avoid bugs by psych settings
	local oldVisibleTxt = getProperty('timeTxt.visible')

	if timeBarStyle == 'Leather Engine' then
		if downscroll then
			timeBarY = 705
			timeTxtY = timeBarY - 25
		else
			timeBarY = 4
			timeTxtY = timeBarY + 20
		end

		hasTimeTxtBefore = true
		timeTxtBefore = songName
		timeBarLength = 1.75
		timeBarBorder = .025
		timeBarX = 345
		timeBarThickness = .035
		timeTxtSize = 16
	elseif timeBarStyle == 'Kade Engine' then
		if downscroll then
			timeBarY = 695
		end

		timeTxtBefore = songName
		timeTxtY = timeBarY - 5
		timeTxtSize = 20
	else
		if downscroll then
			timeBarY = 688
		else
			timeBarY = 31
		end

		timeBarLength = 1.18
		timeBarBorder = .023
		timeBarX = 443.5
		timeBarThickness = .033
		timeTxtY = timeBarY - 10
	end

	makeLuaSprite('utilBarBorder', 'spriteSolid', timeBarX - timeBarBorder * 175, timeBarY - timeBarBorder * 165)
	makeLuaSprite('utilBarEmpty', 'spriteSolid', timeBarX, timeBarY)

	if timeBarOpponentColor then
		timeBarFillColor = dadColFinal
	else
		timeBarFillColor = string.format('%02x%02x%02x', timeBarColorR, timeBarColorG, timeBarColorB)
	end

	if timeBarGradient then
		makeLuaSprite('utilBarFill', 'spriteGradient', timeBarX, timeBarY) -- with gradient :D
	else
		makeLuaSprite('utilBarFill', 'spriteSolid', timeBarX, timeBarY) -- without gradient :(
	end

	addLuaSprite('utilBarBorder', true)
	addLuaSprite('utilBarEmpty', true)
	addLuaSprite('utilBarFill', true)
	
	setObjectCamera('utilBarBorder', 'hud')
	setObjectCamera('utilBarEmpty', 'hud')
	setObjectCamera('utilBarFill', 'hud')

	scaleObject('utilBarBorder', timeBarLength + timeBarBorder, timeBarThickness + timeBarBorder)
	scaleObject('utilBarEmpty', timeBarLength, timeBarThickness)
	scaleObject('utilBarFill', timeBarLength, timeBarThickness)

	doTweenColor('utilBarBorderColor', 'utilBarBorder', timeBarBorderColor, 0.01)
	doTweenColor('utilBarEmptyarColor', 'utilBarEmpty', timeBarEmptyColor, 0.01)
	doTweenColor('utilBarFillColor', 'utilBarFill', timeBarFillColor, 0.01)

	setProperty('utilBarBorder.visible', oldVisibleBar)
	setProperty('utilBarEmpty.visible', oldVisibleBar)
	setProperty('utilBarFill.visible', oldVisibleBar)

	setProperty('timeBar.visible', false)

	--// creating the custom timetxt
	makeLuaText('utilTimer', 'Util Time Txt: something went wrong, did not update properly :c', 300, timeTxtX, timeTxtY);  
	setTextSize('utilTimer', timeTxtSize);
	setTextFont('utilTimer', font)
	setTextAlignment('utilTimer', 'center'); 
	setProperty("utilTimer.wordWrap", false)
	setProperty("utilTimer.autoSize", true)
	setProperty("utilTimer.antialiasing", gAA)
	setTextBorder('utilTimer', 2, '000000')
	setScrollFactor("utilTimer", 0, 0)
	setProperty('utilTimer.alpha', timeTxtAlpha)

	addLuaText('utilTimer', true);
	setProperty('utilTimer.visible', oldVisibleTxt)
	setProperty('timeTxt.visible', false)

	--// custom scoreTxt
	makeLuaText('utilScoreTxt', 'Util Score Txt: something went wrong, did not update properly :c', 1000, 0, getProperty('healthBar.y') + 40);  
	setTextSize('utilScoreTxt', scoreSize + 20);
	setTextFont('utilScoreTxt', font)
	setTextAlignment('utilScoreTxt', 'center'); 
	setProperty("utilScoreTxt.wordWrap", false)
	setProperty("utilScoreTxt.autoSize", true)
	setProperty("utilScoreTxt.antialiasing", gAA)
	setTextBorder('utilScoreTxt', 2, '000000')
	setScrollFactor("utilScoreTxt", 0, 0)

	addLuaText('utilScoreTxt', true);

	setProperty('utilScoreTxt.visible', true)
	setProperty('scoreTxt.visible', false)
end

---------------------------------------------------------------------------------------

-- formulas from http://www.robertpenner.com/easing
easing = {
	-- linear
	linear = function(t,b,c,d)
		return c * t / d + b
	end,
	
	-- quad
	inQuad = function(t, b, c, d)
		return c * math.pow(t / d, 2) + b
	end,
	outQuad = function(t, b, c, d)
		t = t / d
		return -c * t * (t - 2) + b
	end,
	inOutQuad = function(t, b, c, d)
		t = t / d * 2
		if t < 1 then return c / 2 * math.pow(t, 2) + b end
		return -c / 2 * ((t - 1) * (t - 3) - 1) + b
	end,
	outInQuad = function(t, b, c, d)
		if t < d / 2 then return outQuad(t * 2, b, c / 2, d) end
		return inQuad((t * 2) - d, b + c / 2, c / 2, d)
	end,
	
	-- cubic
	inCubic = function(t, b, c, d)
		return c * math.pow(t / d, 3) + b
	end,
	outCubic = function(t, b, c, d)
		return c * (math.pow(t / d - 1, 3) + 1) + b
	end,
	inOutCubic = function(t, b, c, d)
		t = t / d * 2
		if t < 1 then return c / 2 * t * t * t + b end
		t = t - 2
		return c / 2 * (t * t * t + 2) + b
	end,
	outInCubic = function(t, b, c, d)
		if t < d / 2 then return outCubic(t * 2, b, c / 2, d) end
		return inCubic((t * 2) - d, b + c / 2, c / 2, d)
	end,
	
	-- quint
	inQuint = function(t, b, c, d)
		return c * math.pow(t / d, 5) + b
	end,
	outQuint = function(t, b, c, d)
		return c * (math.pow(t / d - 1, 5) + 1) + b
	end,
	inOutQuint = function(t, b, c, d)
		t = t / d * 2
		if t < 1 then return c / 2 * math.pow(t, 5) + b end
		return c / 2 * (math.pow(t - 2, 5) + 2) + b
	end,
	outInQuint = function(t, b, c, d)
		if t < d / 2 then return outQuint(t * 2, b, c / 2, d) end
		return inQuint((t * 2) - d, b + c / 2, c / 2, d)
	end,
	
	-- elastics
	outElastic = function(t, b, c, d, a, p)
		a = a or 3
		p = p or 1
		if t == 0 then return b end
		t = t / d
		if t == 1 then return b + c end
		if not p then p = d * 0.3 end
		local s
		if not a or a < math.abs(c) then
			a = c
			s = p / 4
		else
			s = p / (2 * math.pi) * math.asin(c/a)
		end
		return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p) + c + b
	end
}

--[[ TWEENNUMBER ]]--
local time = 0
local os = os
function os.clock()
	return time
end

local tweenReqs = {}

function tnTick()
	local clock = os.clock()
	--print(songPos, #tweenReqs)
	if #tweenReqs > 0 then
		for i,v in next,tweenReqs do
			if clock>v[5]+v[6] then
				v[1][v[2]] =  v[7](v[6],v[3],v[4]-v[3],v[6])
				table.remove(tweenReqs,i)
				if v[9] then
					v[9]()
				end
			else
				v[1][v[2]] = v[7](clock-v[5],v[3],v[4]-v[3],v[6])
				--if (v[8]) then
				--	v[8] = false
				--	v[1][v[2]] = v[7](0,v[3],v[4]-v[3],v[6])
				--end
			end
		end
	end
end

function tweenNumber(maps, varName, startVar, endVar, time, startTime, easeF, onComplete)
	local clock = os.clock()
	maps = maps or getfenv()
	
	if #tweenReqs > 0 then
		for i2,v2 in next,tweenReqs do
			if v2[2] == varName and v2[1] == maps then
				v2[1][v2[2]] =  v2[7](v2[6],v2[3],v2[4]-v2[3],v2[6])
				table.remove(tweenReqs,i2)
				if v2[9] then
					v2[9]()
				end
				break
			end
		end
	end
	
	--print("Created TweenNumber: "..tostring(varName), startVar, endVar, time, startTime, type(onComplete) == "function")
	local t = {
		maps,
		varName,
		startVar,
		endVar,
		startTime or clock,
		time,
		easeF or easing.linear,
		true,
		onComplete
	}
	
	table.insert(tweenReqs,t)
	t[1][t[2]] = t[7](0,t[3],t[4]-t[3],t[6])
	
	return function()
		maps[varName] = t[7](v[6],t[3],t[4]-t[3],t[6])
		table.remove(tweenReqs,table.find(tweenReqs,t))
		if onComplete then
			onComplete()
		end
		return nil
	end
end

function centerOrigin(obj)
	setProperty(obj .. ".origin.x", getProperty(obj .. ".frameWidth") * .5)
	setProperty(obj .. ".origin.y", getProperty(obj .. ".frameHeight") * .5)
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

botplayStrings = {}

function loadBotplayTexts() -- i dont want to change the name every new update, so even if you change the name of the mod folder it works
    local scriptPath = debug.getinfo(2, "S").source:sub(2)
    local currentDirectory = scriptPath:match("(.*/)")

	local modsDirectory = currentDirectory:match("(.*/).*/")

    local file = io.open(modsDirectory.."/data/botplayText.txt", "r") 

    if file then
        for line in file:lines() do
			if line ~= '' then
				table.insert(botplayStrings, line)
			end
        end
        file:close()
    else
        table.insert(botplayStrings, "BOTPLAY") -- this is for when the txt disappears for some reason
    end
end

function getVersions()
    local scriptPath = debug.getinfo(2, "S").source:sub(2)
    local currentDirectory = scriptPath:match("(.*/)")
	local fileError = false
	local utilVersion = ''
	local peVersion = version

	local modsDirectory = currentDirectory:match("(.*/).*/")

    local file = io.open(modsDirectory.."/data/utilVersion.txt", "r")

    if file then
        for line in file:lines() do
			if line ~= '' then
				utilVersion = line
				break
			else
				fileError = true
			end
        end
        file:close()
    end

	return { fError = fileError, uVer = utilVersion, peVer = peVersion }
end

function setObjectCamera(object,camera) -- this will be used until there is a psych engine hotfix for the function
	-- thank you Tiphy03 for the function :D
	if stringStartsWith(version, '1.0') then
		if string.lower(camera) == "game" then camera = "camGame" end
		if string.lower(camera) == "camgame" then camera = "camGame" end
	
		if string.lower(camera) == "hud" then camera = "camHUD" end
		if string.lower(camera) == "camhud" then camera = "camHUD" end

		if string.lower(camera) == "other" then camera = "camOther" end
		if string.lower(camera) == "camother" then camera = "camOther" end

		if (camera == "camGame") or (camera == "camHUD") or (camera == "camOther") then
			setProperty(object..'.camera',instanceArg(camera),false,true)
		end
	else
		actualSetObjectCamera(object,camera)
	end
end

function math.lerp(a, b, t)
    return (b - a) * t + a;
end

function remap(v, str1, stp1, str2, stp2)
	return str2 + (v - str1) * ((stp2 - str2) / (stp1 - str1));
end

timeSX = 1
timeSY = 1

scoreTxtSX = 1
scoreTxtSY = 1

















---------------------------------------------------------------------------------------

local hudArray = {'noMarvelousJPG', 'catWuajajajaJPG'}

function onCountdownStarted()
	dadColR = getProperty('dad.healthColorArray[0]')
	dadColG = getProperty('dad.healthColorArray[1]')
	dadColB = getProperty('dad.healthColorArray[2]')

	if customHBColors then
		local dadCustomColFinal = string.format('%02x%02x%02x', hbP2ColorR, hbP2ColorG, hbP2ColorB)
		local bfCustomColFinal = string.format('%02x%02x%02x', hbP1ColorR, hbP1ColorG, hbP1ColorB)

		setHealthBarColors(dadCustomColFinal, bfCustomColFinal)
	end
end

function onEvent(name, v1, v2)
	if name == 'Change Character' and customHBColors then -- this works better than onUpdatePost, bc then we don't explode the ram
		local dadCustomColFinal = string.format('%02x%02x%02x', hbP2ColorR, hbP2ColorG, hbP2ColorB)
		local bfCustomColFinal = string.format('%02x%02x%02x', hbP1ColorR, hbP1ColorG, hbP1ColorB)

		setHealthBarColors(dadCustomColFinal, bfCustomColFinal)
	end
end

function onBeatHit()
    if timeTxtZoomOnBeat then
        tweenNumber(nil, "timeSX", 1.2, 1, .2, nil, easing.linear)
        tweenNumber(nil, "timeSY", 1.2, 1, .2, nil, easing.linear)
    end
end

function onUpdate(dt)
	time = time + dt

	if botPlay or practice then
        if usedCheats ~= true then
            usedCheats = true
        end
    end

	scaleObject('utilBarFill', timeBarLength * getProperty("songPercent"), timeBarThickness)

    if timeTxtModern then
        local elapsedTime = getSongPosition() / 1000
        
        local songLength = getProperty('songLength') / 1000
        
        local elapsedMinutes = math.floor(elapsedTime / 60)
        local elapsedSeconds = elapsedTime % 60
        
        local totalMinutes = math.floor(songLength / 60)
        local totalSeconds = songLength % 60
        
        local timeText = string.format("%d:%02d / %d:%02d", elapsedMinutes, elapsedSeconds, totalMinutes, totalSeconds)

		if curStep == 0 then
			timeText = string.format("%d:%02d / %d:%02d", 0, 0, totalMinutes, totalSeconds)
		end
        
		if timeBarStyle == 'Psych Engine' then
			setTextString('utilTimer', timeText)
		else
			setTextString('utilTimer', timeTxtBefore..' ('..timeText..')')
		end
	else
		local ogTimeText = getProperty('timeTxt.text')
		if hasTimeTxtBefore == true then
			if ogTimeText == timeTxtBefore then
				return setTextString('utilTimer', timeTxtBefore)
			end

			if ogTimeText == '' then
				setTextString('utilTimer', timeTxtBefore..' (0:00)')
			else
				setTextString('utilTimer', timeTxtBefore..' ('..ogTimeText..')')
			end
		else
			if timeTxtBefore ~= '' then
				setTextString('utilTimer', timeTxtBefore)
			else
				if ogTimeText == '' then
					setTextString('utilTimer', '0:00')
				else
					setTextString('utilTimer', ogTimeText)
				end
			end
		end
    end
end

function onUpdatePost(dt)
	tnTick()

	screenCenter('utilTimer', 'x')
	setProperty("utilTimer.scale.x", timeSX)
	setProperty("utilTimer.scale.y", timeSY)

	screenCenter('utilScoreTxt', 'x')
	setProperty("utilScoreTxt.scale.x", scoreTxtSX)
	setProperty("utilScoreTxt.scale.y", scoreTxtSY)
end
