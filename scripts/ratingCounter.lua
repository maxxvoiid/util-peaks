--[[ Hey neds 🤓☝️

This script handles all these functions:
- Rating Counter
- Full FC Rating Name


This script works as it should, don't touch anything if you don't know what you are doing :)
    ~ MaxxVoiid

]]





-----------------------------------------------------------------------
    --- DON'T EDIT ANYTHING IF YOU DON'T KNOW WHAT YOU'RE DOING ---
-----------------------------------------------------------------------

local dFont = 'vcr.ttf'
local ratingCounterEnabled = getModSetting('ratingcounterenabled')
local marvelousRatingEnabled = getModSetting('marvelousenabled')
local marvelousRatingMs = getModSetting('marvelousms')
local fullFcName = getModSetting('fullfcname')

local usedBotplay = false -- used for cheaters who used botplay at some point in the song >:(

function onCreatePost()
	usedBotplay = false -- reset

	local gAA = getPropertyFromClass("ClientPrefs", "globalAntialiasing")

	makeLuaText('combo', 'Combo: 0 (0)', -1, (-10 + (1280 * 0.0375)), 289);  
	setTextSize('combo', 22);
	setTextFont('combo', dFont)
	setTextAlignment('combo', 'left')

	if marvelousRatingEnabled then
		makeLuaText('marvelous', 'Marvelous: 0', -1, getProperty('combo.x'), getProperty('combo.y') + getProperty('combo.height'));  
		setTextSize('marvelous', 22);
		setTextFont('marvelous', dFont)
		setTextAlignment('marvelous', 'left')

		makeLuaText('sick', 'Sicks: 0', -1, getProperty('combo.x'), getProperty('marvelous.y') + getProperty('marvelous.height'));  
		setTextSize('sick', 22);
		setTextFont('sick', dFont)
		setTextAlignment('sick', 'left')
	else
		makeLuaText('sick', 'Sicks: 0', -1, getProperty('combo.x'), getProperty('combo.y') + getProperty('combo.height'));  
		setTextSize('sick', 22);
		setTextFont('sick', dFont)
		setTextAlignment('sick', 'left')
	end

	makeLuaText('good', 'Goods: 0', -1, getProperty('combo.x'), getProperty('sick.y') + getProperty('sick.height'));    
	setTextSize('good', 22);
	setTextFont('good', dFont)
	setTextAlignment('good', 'left')

	makeLuaText('bad', 'Bads: 0', -1, getProperty('combo.x'), getProperty('good.y') + getProperty('good.height'));    
	setTextSize('bad', 22);
	setTextFont('bad', dFont)
	setTextAlignment('bad', 'left')

	makeLuaText('shit', 'Shits: 0', -1, getProperty('combo.x'), getProperty('bad.y') + getProperty('bad.height'));      
	setTextSize('shit', 22);
	setTextFont('shit', dFont)
	setTextAlignment('shit', 'left')

	makeLuaText('fc', '?', -1, getProperty('combo.x'), getProperty('shit.y') + getProperty('shit.height') * 2);  
	setTextSize('fc', 22);
	setTextFont('fc', dFont)
	setTextAlignment('fc', 'left')

	setProperty("combo.wordWrap", false)
	setProperty("combo.autoSize", true)
	setProperty("sick.wordWrap", false)
	setProperty("sick.autoSize", true)
	setProperty("good.wordWrap", false)
	setProperty("good.autoSize", true)
	setProperty("bad.wordWrap", false)
	setProperty("bad.autoSize", true)
	setProperty("shit.wordWrap", false)
	setProperty("shit.autoSize", true)
	setProperty("fc.wordWrap", false)
	setProperty("fc.autoSize", true)
	
	setProperty("combo.antialiasing", gAA)
	setProperty("sick.antialiasing", gAA)
	setProperty("good.antialiasing", gAA)
	setProperty("bad.antialiasing", gAA)
	setProperty("shit.antialiasing", gAA)
	setProperty("fc.antialiasing", gAA)

	setTextBorder('combo', 2, '000000')
	setTextBorder('sick', 2, '000000')
	setTextBorder('good', 2, '000000')
	setTextBorder('bad', 2, '000000')
	setTextBorder('shit', 2, '000000')
	setTextBorder('fc', 2, '000000')

	setScrollFactor("combo", 0, 0)
	setObjectCamera("combo", "hud")
	setScrollFactor("sick", 0, 0)
	setObjectCamera("sick", "hud")
	setScrollFactor("good", 0, 0)
	setObjectCamera("good", "hud")
	setScrollFactor("bad", 0, 0)
	setObjectCamera("bad", "hud")
	setScrollFactor("shit", 0, 0)
	setObjectCamera("shit", "hud")
	setScrollFactor("fc", 0, 0)
	setObjectCamera("fc", "hud")

	if ratingCounterEnabled then
		addLuaText('combo', true);

		if marvelousRatingEnabled then
			setProperty("marvelous.wordWrap", false)
			setProperty("marvelous.autoSize", true)
	
			setProperty("marvelous.antialiasing", gAA)
	
			setTextBorder('marvelous', 2, '000000')
	
			setScrollFactor("marvelous", 0, 0)
			setObjectCamera("marvelous", "hud")
	
			addLuaText('marvelous', true);
		end
	
		addLuaText('sick', true);
		addLuaText('good', true);
		addLuaText('bad', true);
		addLuaText('shit', true);
		addLuaText('fc', true);
	end
end


--[[ NERD TIME! ]]--

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







---------------------------------------------------------------------------------------

comboSX = 1
comboSY = 1

marvelousSX = 1
marvelousSY = 1

sickSX = 1
sickSY = 1

goodSX = 1
goodSY = 1

badSX = 1
badSY = 1

shitSX = 1
shitSY = 1

fcSX = 1
fcSY = 1

local mCombo = 0
local prevCombo = 0
local prevMarvelous = 0
local prevSick = 0
local prevGood = 0
local prevBad = 0
local prevShit = 0
local prevFc = 0

local actMarvelous = 0
local actSick = 0
local actGood = 0
local actBad = 0
local actShit = 0

function addRatingMS(diff)
	diff = math.abs(diff)

	local windowSick = getProperty('ratingsData[0].hitWindow')
	local windowGood = getProperty('ratingsData[1].hitWindow')
	local windowBad = getProperty('ratingsData[2].hitWindow')

	if marvelousRatingEnabled and diff <= marvelousRatingMs then
		tweenNumber(nil, "marvelousSX", 1.075, 1, .2, nil, easing.linear)
		tweenNumber(nil, "marvelousSY", 1.075, 1, .2, nil, easing.linear)

		actMarvelous = actMarvelous + 1

		setTextColor("marvelous", "FFEBBE")
		doTweenColor('marvelousW', "marvelous", 'ffffff', 0.3, 'linear')
		return
	end

	if diff <= windowSick then
		tweenNumber(nil, "sickSX", 1.075, 1, .2, nil, easing.linear)
		tweenNumber(nil, "sickSY", 1.075, 1, .2, nil, easing.linear)

		actSick = actSick + 1

		setTextColor("sick", "68FAFC")
		doTweenColor('sickW', "sick", 'ffffff', 0.3, 'linear')
		return
	end

	if diff <= windowGood then
		tweenNumber(nil, "goodSX", 1.075, 1, .2, nil, easing.linear)
		tweenNumber(nil, "goodSY", 1.075, 1, .2, nil, easing.linear)

		actGood = actGood + 1

		setTextColor("good", "48F048")
		doTweenColor('goodW', "good", 'ffffff', 0.3, 'linear')
		return
	end

	if diff <= windowBad then
		tweenNumber(nil, "badSX", 1.075, 1, .2, nil, easing.linear)
		tweenNumber(nil, "badSY", 1.075, 1, .2, nil, easing.linear)

		actBad = actBad + 1

		setTextColor("bad", "F0D148")
		doTweenColor('badW', "bad", 'ffffff', 0.3, 'linear')
		return
	end


	tweenNumber(nil, "shitSX", 1.075, 1, .2, nil, easing.linear)
	tweenNumber(nil, "shitSY", 1.075, 1, .2, nil, easing.linear)

	actShit = actShit + 1

	setTextColor("shit", "878787")
	doTweenColor('shitW', "shit", 'ffffff', 0.3, 'linear')
	return
end

function getCFC()
	local misses = getProperty('songMisses')

	if fullFcName then
		if misses >= 1000 then
			setProperty('ratingFC', 'Quadruple Digit Combo Break')
			return 'Quadruple Digit Combo Break'
		end
	
		if misses >= 100 then
			setProperty('ratingFC', 'Triple Digit Combo Break')
			return 'Triple Digit Combo Break'
		end
	
		if misses >= 10 then
			setProperty('ratingFC', 'CLEAR')
			return 'CLEAR'
		end
	
		if misses > 0 then
			setProperty('ratingFC', 'Single Digit Combo Break')
			return 'Single Digit Combo Break'
		end
	
		if (actBad > 0 or actShit > 0) and misses == 0 then
			setProperty('ratingFC', 'Full Combo')
			return 'Full Combo'
		end
	
		if actMarvelous > 0 and actSick > 0 and actGood > 0 and actBad == 0 and actShit == 0 then
			setProperty('ratingFC', 'Good Full Combo')
			return 'Good Full Combo'
		end
	
		if actMarvelous > 0 and actSick > 0 and actGood == 0 and actBad == 0 and actShit == 0 then
			setProperty('ratingFC', 'Sick Full Combo')
			return 'Sick Full Combo'
		end
	
		if actMarvelous > 0 and actSick == 0 and actGood == 0 and actBad == 0 and actShit == 0 then
			setProperty('ratingFC', 'Marvelous Full Combo')
			return 'Marvelous Full Combo'
		end

		if marvelousRatingEnabled then
			setProperty('ratingFC', 'Marvelous Full Combo')
		else
			setProperty('ratingFC', 'Sick Full Combo')
		end
	else
		if misses >= 1000 then
			setProperty('ratingFC', 'QDCB')
			return 'QDCB' -- Quadruple Digit Combo Break
		end
	
		if misses >= 100 then
			setProperty('ratingFC', 'TDCB')
			return 'TDCB' -- Triple Digit Combo Break
		end
	
		if misses >= 10 then
			setProperty('ratingFC', 'CLEAR')
			return 'CLEAR'
		end
	
		if misses > 0 then
			setProperty('ratingFC', 'SDCB')
			return 'SDCB' -- Single Digit Combo Break
		end
	
		if (actBad > 0 or actShit > 0) and misses == 0 then
			setProperty('ratingFC', 'FC')
			return 'FC' -- Full Combo
		end
	
		if actMarvelous > 0 and actSick > 0 and actGood > 0 and actBad == 0 and actShit == 0 then
			setProperty('ratingFC', 'GFC')
			return 'GFC' -- Good Full Combo
		end
	
		if actMarvelous > 0 and actSick > 0 and actGood == 0 and actBad == 0 and actShit == 0 then
			setProperty('ratingFC', 'SFC')
			return 'SFC' -- Sick Full Combo
		end
	
		if actMarvelous > 0 and actSick == 0 and actGood == 0 and actBad == 0 and actShit == 0 then
			setProperty('ratingFC', 'MFC')
			return 'MFC' -- Marvelous Full Combo
		end

		if marvelousRatingEnabled then
			setProperty('ratingFC', 'MFC')
		else
			setProperty('ratingFC', 'SFC')
		end
	end

	return '' -- Not Play
end

function fcColor(actFc)
	if actFc == 'MFC' or actFc == 'Marvelous Full Combo' then
		return 'FFEBBE'
	elseif actFc == 'SFC' or actFc == 'Sick Full Combo' then
		return '68FAFC'
	elseif actFc == 'GFC' or actFc == 'Good Full Combo' then
		return '48F048'
	elseif actFc == 'FC' or actFc == 'Full Combo' then
		return 'F0D148'
	elseif actFc == 'TDCB' or actFc == 'Triple Digit Combo Break' then
		return 'FF9900'
	elseif actFc == 'QDCB' or actFc == 'Quadruple Digit Combo Break' then
		return 'FF0000'
	else
		return 'FFFFFF'
	end
end

function onUpdateScore()
	getCFC()
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if (not isSustainNote) then
		local strumTime = getPropertyFromGroup('notes', id, 'strumTime')
		isEarly = strumTime < getSongPosition() and '' or '-'

		local curRating = addRatingMS((strumTime - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset')) / playbackRate)

		tweenNumber(nil, "comboSX", 1.075, 1, .2, nil, easing.linear)
		tweenNumber(nil, "comboSY", 1.075, 1, .2, nil, easing.linear)

		local fcTxt = getCFC()
		if (fcTxt ~= prevFc) then
			tweenNumber(nil, "fcSX", 1.075, 1, .2, nil, easing.linear)
			tweenNumber(nil, "fcSY", 1.075, 1, .2, nil, easing.linear)
		end
	end
end

function noteMissPress(direction)
	local fcTxt = getCFC()
	if (fcTxt ~= prevFc) then
		tweenNumber(nil, "fcSX", 1.075, 1, .2, nil, easing.linear)
		tweenNumber(nil, "fcSY", 1.075, 1, .2, nil, easing.linear)
	end 
end

function noteMiss(id, direction, noteType, isSustainNote)
	local fcTxt = getCFC()
	if (fcTxt ~= prevFc) then
		tweenNumber(nil, "fcSX", 1.075, 1, .2, nil, easing.linear)
		tweenNumber(nil, "fcSY", 1.075, 1, .2, nil, easing.linear)
	end 
end

function onUpdate(dt)
	time = time + dt

	if botPlay then
		if usedBotplay ~= true then
			usedBotplay = true
		end
	end
end

function onUpdatePost(dt)
	tnTick()

	local hideHud = getPropertyFromClass("ClientPrefs", "hideHud")

	local combo = getProperty('combo')

	if combo < 0 then combo = 0 end

	if combo > mCombo then
		mCombo = combo
	end

	local comboTxt = "Combo: " ..tostring(formatNumberWithCommas(combo)).. ' ('..formatNumberWithCommas(mCombo)..')'
	local marvelousTxt = "Marvelous: " ..tostring(formatNumberWithCommas(actMarvelous))
	local sickTxt = "Sicks: " ..tostring(formatNumberWithCommas(actSick))
	local goodTxt = "Goods: " ..tostring(formatNumberWithCommas(actGood))
	local badTxt = "Bads: " ..tostring(formatNumberWithCommas(actBad))
	local shitTxt = "Shits: " ..tostring(formatNumberWithCommas(actShit))
	local fcTxt = getCFC() == "" and "?" or getCFC()

	if (combo ~= prevCombo) then
		setTextString("combo", comboTxt)
		centerOrigin("combo")
	end
	setProperty("combo.visible", not hideHud)
	setProperty("combo.scale.x", comboSX)
	setProperty("combo.scale.y", comboSY)

	if marvelousRatingEnabled then
		if (actMarvelous ~= prevMarvelous) then
			setTextString("marvelous", marvelousTxt)
			centerOrigin("marvelous")
		end
		setProperty("marvelous.visible", not hideHud)
		setProperty("marvelous.scale.x", marvelousSX)
		setProperty("marvelous.scale.y", marvelousSY)
	end 

	if (actSick ~= prevSick) then
		setTextString("sick", sickTxt)
		centerOrigin("sick")
	end
	setProperty("sick.visible", not hideHud)
	setProperty("sick.scale.x", sickSX)
	setProperty("sick.scale.y", sickSY)

	if (actGood ~= prevGood) then
		setTextString("good", goodTxt)
		centerOrigin("good")
	end
	setProperty("good.visible", not hideHud)
	setProperty("good.scale.x", goodSX)
	setProperty("good.scale.y", goodSY)

	if (actBad ~= prevBad) then
		setTextString("bad", badTxt)
		centerOrigin("bad")
	end
	setProperty("bad.visible", not hideHud)
	setProperty("bad.scale.x", badSX)
	setProperty("bad.scale.y", badSY)

	if (actShit ~= prevShit) then
		setTextString("shit", shitTxt)
		centerOrigin("shit")
	end
	setProperty("shit.visible", not hideHud)
	setProperty("shit.scale.x", shitSX)
	setProperty("shit.scale.y", shitSY)

	if usedBotplay then
		setTextString("fc", 'BOTPLAY\nWAS ENABLED')
		centerOrigin("fc")

		doTweenColor('fcColor', 'fc', 'FF8000', 0.1, 'linear')
	end

	if (fcTxt ~= prevFc) then
		if not usedBotplay then
			setTextString("fc", fcTxt)
			centerOrigin("fc")
	
			doTweenColor('fcColor', 'fc', fcColor(fcTxt), 0.1, 'linear')
		else
			setTextString("fc", 'BOTPLAY\nWAS ENABLED')
			centerOrigin("fc")

			doTweenColor('fcColor', 'fc', 'FF8000', 0.1, 'linear')
		end
	end
	setProperty("fc.alpha", getProperty("shit.alpha"))
	setProperty("fc.visible", not hideHud)
	setProperty("fc.scale.x", fcSX)
	setProperty("fc.scale.y", fcSY)

	prevCombo = combo
	prevSick = sicks
	prevGood = goods
	prevBad = bads
	prevShit = shits
	prevFc = fcTxt
end

-- yes, I'm sorry if this code is spagetti, I have no idea how to simplify it :c
