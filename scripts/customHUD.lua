local newRatingEnabled = getModSetting('newratings')

local ratingCounterEnabled = getModSetting('ratingcounterenabled')

local fullFcName = getModSetting('fullfcname')

local compactScore = getModSetting('compactscore')

local marvelousRatingEnabled = getModSetting('marvelousenabled')
local marvelousRatingMs = getModSetting('marvelousms')

local onlyMarvelous = getModSetting('onlymarvelous')
local onlyMarvelousVolume = getModSetting('onlymarvelousvolume')

local showNPS = getModSetting('shownps')

local settings = {
    customFont = 'vcr.ttf',
	divider = ' • ',
    modernTimer = getModSetting('moderntimetext'),
    timerZoomOnBeat = getModSetting('bouncingtimetext')
}

local Nps = 0
local MaxNps = 0
local npsRefresh1 = 0
local npsRefresh2 = 0

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

function getNewScore()
	local nps = ''
    local rating = ""
    local percent = getProperty('ratingPercent') * 100

	if showNPS then
		nps = settings.divider..'NPS/Max: '..tostring(formatNumberWithCommas(Nps))..'/'..tostring(formatNumberWithCommas(MaxNps))
	end

    if percent > 0 then
		if newRatingEnabled then
			if percent >= 100 then
				rating = rating..'SSSS'
			elseif percent >= 97.50 then
				rating = rating..'SSS'
			elseif percent >= 95 then
				rating = rating..'SS'
			elseif percent >= 90 then
				rating = rating..'S'
			elseif percent >= 85 then
				rating = rating..'A'
			elseif percent >= 75 then
				rating = rating..'B'
			elseif percent >= 60 then
				rating = rating..'C'
			elseif percent >= 45 then
				rating = rating..'D'
			elseif percent >= 30 then
				rating = rating..'E'
			else
				rating = rating..'F'
			end
		else
			rating = rating..ratingName
		end

		percent = (math.floor(getProperty('ratingPercent') * 10000)/100)..'%'
        rating = rating
    else
		percent = '100%'
		if newRatingEnabled then
			rating = rating..'SSSS'
		else
			rating = rating..'Perfect!!'
		end
    end

	if not compactScore then
		if not ratingCounterEnabled then
			setTextString('scoreTxt', 'Score: '..tostring(formatNumberWithCommas(getProperty('songScore')))..settings.divider..'Misses: '..getProperty('songMisses')..nps..settings.divider..'Accuracy: '..percent..settings.divider..rating..' - '..getProperty('ratingFC'))
		else
			setTextString('scoreTxt', 'Score: '..tostring(formatNumberWithCommas(getProperty('songScore')))..settings.divider..'Misses: '..getProperty('songMisses')..nps..settings.divider..'Accuracy: '..percent..settings.divider..rating)
		end
	else
		if not ratingCounterEnabled then
			setTextString('scoreTxt', 'Score: '..tostring(formatNumberWithCommas(getProperty('songScore')))..settings.divider..'Misses: '..getProperty('songMisses')..nps..settings.divider..rating..' - '..getProperty('ratingFC'))
		else
			setTextString('scoreTxt', 'Score: '..tostring(formatNumberWithCommas(getProperty('songScore')))..settings.divider..'Misses: '..getProperty('songMisses')..nps..settings.divider..rating)
		end
	end
end

function onUpdateScore()
	getNewScore()
end

function onCreatePost()
    if settings.modernTimer then
        local gAA = getPropertyFromClass("ClientPrefs", "globalAntialiasing")

        makeLuaText('timerModed', 'TIME', 300, screenWidth/2, not downscroll and 20 or screenHeight - 42);  
        setTextSize('timerModed', 30);
        setTextFont('timerModed', settings.customFont)
        setTextAlignment('timerModed', 'center'); 
    
        setProperty("timerModed.wordWrap", false)
        setProperty("timerModed.autoSize", true)
        
        setProperty("timerModed.antialiasing", gAA)
    
        setTextBorder('timerModed', 2, '000000')
    
        setScrollFactor("timerModed", 0, 0)
        setObjectCamera("timerModed", "hud")
    
        setProperty('timerModed.alpha', 0)
    
        addLuaText('timerModed', true);
    
        setProperty('timeTxt.visible', false)
	else
		setTextBorder('timeTxt', 2, '000000')
    end

	if onlyMarvelous and marvelousRatingEnabled then
		makeLuaSprite('noMarvelousJPG', 'nomarvelous', 0, 0);
        addLuaSprite('noMarvelousJPG', true);
        scaleObject('noMarvelousJPG', 6, 3);
        setObjectCamera('noMarvelousJPG', 'other');
		setProperty('noMarvelousJPG.alpha', 0)

		makeLuaSprite('catWuajajajaJPG', 'catwuajajaja', 0, 0);
        addLuaSprite('catWuajajajaJPG', true);
        scaleObject('catWuajajajaJPG', 1.5, 0.85);
        setObjectCamera('catWuajajajaJPG', 'other');
		setProperty('catWuajajajaJPG.alpha', 0)
	end

	if showNPS then
		runTimer(npsTimer1, 0.1, 0)
		runTimer(npsTimer2, 0.5, 0)
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

timeSX = 1
timeSY = 1

local hudArray = {'noMarvelousJPG', 'catWuajajajaJPG'}

function onSongStart()
    if settings.modernTimer then
        doTweenAlpha('fadeInTween', 'timerModed', 1, 0.1, 'linear')
    end
end

function onBeatHit()
    if settings.timerZoomOnBeat then
        tweenNumber(nil, "timeSX", 1.2, 1, .2, nil, easing.linear)
        tweenNumber(nil, "timeSY", 1.2, 1, .2, nil, easing.linear)
    end
end

function addRatingMS(diff, noteTouch)
	if botPlay or (not onlyMarvelous or not marvelousRatingEnabled) then return end

	diff = math.abs(diff)

	local windowSick = getProperty('ratingsData[0].hitWindow')
	local windowGood = getProperty('ratingsData[1].hitWindow')
	local windowBad = getProperty('ratingsData[2].hitWindow')

	if marvelousRatingEnabled and diff <= marvelousRatingMs then return end

	if (diff <= windowSick) or (diff <= windowGood) or (diff <= windowBad) then
		setProperty('noMarvelousJPG.alpha', 1)
		playSound('vineboom', onlyMarvelousVolume)
		for i, hud in pairs(hudArray) do
			doTweenAlpha(hud..'Alpha', hud, 0, 1, 'linear')
		end
		return
	end

	if noteTouch then
		setProperty('noMarvelousJPG.alpha', 1)
		playSound('vineboom', onlyMarvelousVolume)
		for i, hud in pairs(hudArray) do
			doTweenAlpha(hud..'Alpha', hud, 0, 1, 'linear')
		end
		return
	end

	setProperty('catWuajajajaJPG.alpha', 1)
	playSound('wuajajaja', onlyMarvelousVolume)
	for i, hud in pairs(hudArray) do
		doTweenAlpha(hud..'Alpha', hud, 0, 1, 'linear')
	end
	return
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	getNewScore()

	if (not isSustainNote) then
		npsRefresh1 = npsRefresh1 + 1

		local strumTime = getPropertyFromGroup('notes', id, 'strumTime')
		addRatingMS((strumTime - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset')) / playbackRate, true)
	end
end

function noteMissPress(direction)
	getNewScore()

	addRatingMS(1500, false)
end

function noteMiss(id, direction, noteType, isSustainNote)
	getNewScore()

	addRatingMS(1500, false)
end

function onUpdate(dt)
	time = time + dt

    if settings.modernTimer then
        -- Obtiene el tiempo transcurrido en segundos
        local elapsedTime = getSongPosition() / 1000
        
        -- Obtiene la duración total de la canción en segundos
        local songLength = getProperty('songLength') / 1000
        
        -- Convierte el tiempo transcurrido a formato "minutos:segundos"
        local elapsedMinutes = math.floor(elapsedTime / 60)
        local elapsedSeconds = elapsedTime % 60
        
        -- Convierte la duración total a formato "minutos:segundos"
        local totalMinutes = math.floor(songLength / 60)
        local totalSeconds = songLength % 60
        
        -- Formatea el texto como "0:00 (3:42)"
        local timeText = string.format("%d:%02d (%d:%02d)", elapsedMinutes, elapsedSeconds, totalMinutes, totalSeconds)
        
        setTextString('timerModed', timeText)
    end
end

function onUpdatePost(dt)
	tnTick()

	if showNPS then
		getNewScore()

		if MaxNps < Nps then
			MaxNps = Nps
		end 
	end

    if settings.timerZoomOnBeat then
        if settings.modernTimer then
            setProperty("timerModed.scale.x", timeSX)
            setProperty("timerModed.scale.y", timeSY)
        else
            setProperty("timeTxt.scale.x", timeSX)
            setProperty("timeTxt.scale.y", timeSY)
        end
    end

    if settings.modernTimer then
        local timerWidth = getProperty('timerModed.width')
        setProperty('timerModed.x', (screenWidth - timerWidth) / 2)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == npsTimer1 then
		npsRefresh2 = npsRefresh1
		runTimer(npsTimer4, 0.15, 0)
	end
	if tag == npsTimer2 then
		Nps = (npsRefresh2)
		runTimer(npsTimer3, 1.15, 0)
	end
	if tag == npsTimer3 then
		npsRefresh2 = 0
	end
	if tag == npsTimer4 then
		npsRefresh1 = 0
	end
end
