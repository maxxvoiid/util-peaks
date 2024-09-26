--[[ Hey neds 🤓☝️

This script handles all these functions:
- Modern Time Text
- Bouncing Time Text
- Time Bar Styles
- New Ratings
- Compact Score Text
- Only Marvelous: Images
- Show NPS
- Get Bot Score
- Now Playing Pop-up
- Random Botplay Text
- Show Reason of Game Over
- Smooth Health Bar


This script works as it should, don't touch anything if you don't know what you are doing :)
    ~ MaxxVoiid


/!\ For NOTHING IN THE WORLD delete this script, IT BREAK EVERYTHING!!! /!\
/!\ For NOTHING IN THE WORLD delete this script, IT BREAK EVERYTHING!!! /!\
/!\ For NOTHING IN THE WORLD delete this script, IT BREAK EVERYTHING!!! /!\
/!\ For NOTHING IN THE WORLD delete this script, IT BREAK EVERYTHING!!! /!\
/!\ For NOTHING IN THE WORLD delete this script, IT BREAK EVERYTHING!!! /!\

]]





-----------------------------------------------------------------------
    --- DON'T EDIT ANYTHING IF YOU DON'T KNOW WHAT YOU'RE DOING ---
-----------------------------------------------------------------------

local newRatingEnabled = getModSetting('newratings')

local ratingCounterEnabled = getModSetting('ratingcounterenabled')

local fullFcName = getModSetting('fullfcname')

local compactScore = getModSetting('compactscore')

local marvelousRatingEnabled = getModSetting('marvelousenabled')
local marvelousRatingMs = getModSetting('marvelousms')

local onlyMarvelous = getModSetting('onlymarvelous')
local onlyMarvelousVolume = getModSetting('onlymarvelousvolume')
local onlyMarvelousType = getModSetting('onlymarveloustype')

local showNPS = getModSetting('shownps')

local getBotScore = getModSetting('getbotscore')

local nowPlayingPopup = getModSetting('nowplayingpopup')
local nowPlayingPosition = getModSetting('nowplayingposition')
local nowPlayingDuration = getModSetting('nowplayingduration')

local animatedHudEnabled = getModSetting('animatedhudenabled')

local randomBotplayText = getModSetting('randombotplaytext')

local showReasonGO = getModSetting('showreasongo')

local smoothHealthBar = getModSetting('smoothhealthbar')

local settings = {
    customFont = 'vcr.ttf',
	divider = ' • ',
	styleTimer = getModSetting('timebarstyle'),
    modernTimer = getModSetting('moderntimetext'),
    timerZoomOnBeat = getModSetting('bouncingtimetext')
}

local Nps = 0
local MaxNps = 0
local bScore = 0

local barThickness = .04
local barBorder = .03
local barLength = 1.965
local barX = 312
local barY = 12.5

local barFillColor = '00ff00'
local barEmptyColor = '000000'
local barBorderColor = '000000'

local hasBarTxtBefore = false
local barTxtBefore = ''
local barTxtX = screenWidth/2
local barTxtY = not downscroll and 20 or screenHeight - 42
local barTxtSize = 30
local barTxtAlpha = 1

local healthPercent = 50

local practice = getProperty('practiceMode')
local playerDied = false
local usedCheats = false

function onCreate()
	local blockVersionBeforePrefixes = {'0.3', '0.4', '0.5', '0.6'}
	local blockVersionAfterPrefixes = {'1.0'}
	local minimalVersion = '0.7'

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
	setVar("utilLoadDebug", true) -- prints debug texts to see if each script loads
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

function getNewScore()
	local nps = ''
	local txtPart1 = ''
	local txtPart2 = ''
    local rating = ""
    local percent = getProperty('ratingPercent') * 100

	if showNPS then
		nps = settings.divider..'NPS/Max: '..tostring(formatNumberWithCommas(Nps))..'/'..tostring(formatNumberWithCommas(MaxNps))
	end

	if botPlay then
		if getBotScore then
			txtPart1 = 'Bot Score: '..tostring(formatNumberWithCommas(bScore))
		end
	else
		txtPart1 = 'Score: '..tostring(formatNumberWithCommas(getProperty('songScore')))..settings.divider..'Misses: '..getProperty('songMisses')
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

		txtPart2 = 'Accuracy: '..percent..settings.divider..rating
    else
		txtPart2 = '?'
    end

	if practice then
		if getProperty('health') <= 0 and playerDied == false then
			playerDied = true
		end
	end

	if not compactScore then
		if practice and not botPlay then
			if not playerDied then
				setTextString('utilScoreTxt', txtPart1..nps..settings.divider..'Practice Mode')
			else
				setTextString('utilScoreTxt', txtPart1..nps..settings.divider..'Practice Mode - Died')
			end
		else
			if not ratingCounterEnabled then
				setTextString('utilScoreTxt', txtPart1..nps..settings.divider..txtPart2..' - '..getProperty('ratingFC'))
			else
				setTextString('utilScoreTxt', txtPart1..nps..settings.divider..txtPart2)
			end
		end
	else
		if practice and not botPlay then
			setTextString('utilScoreTxt', txtPart1..nps..settings.divider..'Practice')
		else
			if not ratingCounterEnabled then
				setTextString('utilScoreTxt', txtPart1..nps..settings.divider..rating..' - '..getProperty('ratingFC'))
			else
				setTextString('utilScoreTxt', txtPart1..nps..settings.divider..rating)
			end
		end
	end
end

function onCreatePost()
	local gAA = getPropertyFromClass("ClientPrefs", "globalAntialiasing")

	--// getting dad health bar color
	local dadColR = getProperty('dad.healthColorArray[0]')
	local dadColG = getProperty('dad.healthColorArray[1]')
	local dadColB = getProperty('dad.healthColorArray[2]')

	local dadColFinal = string.format('%02x%02x%02x', dadColR, dadColG, dadColB)

	--// creating the custom timebar
	local oldVisibleBar = getProperty('timeBar.visible') -- this tries to avoid bugs by psych settings
	local oldVisibleTxt = getProperty('timeTxt.visible')
	
	if settings.styleTimer == 'Leather Engine' or settings.styleTimer == 'Leather Engine\n(No Gradient)' then
		if downscroll then
			barY = 705
			barTxtY = barY - 25
		else
			barY = 4
			barTxtY = barY + 20
		end

		hasBarTxtBefore = true
		barTxtBefore = songName
		barLength = 1.75
		barBorder = .025
		barX = 345
		barThickness = .035
		barFillColor = dadColFinal
		barTxtSize = 16
	elseif settings.styleTimer == 'Kade Engine' then
		if downscroll then
			barY = 695
		end

		barEmptyColor = '828282'
		barTxtBefore = songName
		barTxtY = barY - 5
		barTxtSize = 20
	else
		if downscroll then
			barY = 688
		else
			barY = 31
		end

		barFillColor = 'FFFFFF'
		barLength = 1.18
		barBorder = .023
		barX = 443.5
		barThickness = .033
		barTxtY = barY - 10
	end

	makeLuaSprite('utilBarBorder', 'spriteSolid', barX - barBorder * 175, barY - barBorder * 165)
	makeLuaSprite('utilBarEmpty', 'spriteSolid', barX, barY)

	if settings.styleTimer == 'Leather Engine' and settings.styleTimer ~= 'Leather Engine\n(No Gradient)' then
		makeLuaSprite('utilBarFill', 'spriteGradient', barX, barY) -- with gradient :D
	else
		makeLuaSprite('utilBarFill', 'spriteSolid', barX, barY) -- without gradient :(
	end

	addLuaSprite('utilBarBorder', true)
	addLuaSprite('utilBarEmpty', true)
	addLuaSprite('utilBarFill', true)

	setObjectCamera('utilBarBorder', 'hud')
	setObjectCamera('utilBarEmpty', 'hud')
	setObjectCamera('utilBarFill', 'hud')

	scaleObject('utilBarBorder', barLength + barBorder, barThickness + barBorder)
	scaleObject('utilBarEmpty', barLength, barThickness)
	scaleObject('utilBarFill', barLength, barThickness)

	doTweenColor('utilBarBorderColor', 'utilBarBorder', barBorderColor, 0.01)
	doTweenColor('utilBarEmptyarColor', 'utilBarEmpty', barEmptyColor, 0.01)
	doTweenColor('utilBarFillColor', 'utilBarFill', barFillColor, 0.01)

	setProperty('utilBarBorder.visible', oldVisibleBar)
	setProperty('utilBarEmpty.visible', oldVisibleBar)
	setProperty('utilBarFill.visible', oldVisibleBar)

	setProperty('timeBarBG.visible', false)
	setProperty('timeBar.visible', false)


	--// creating the custom timetxt
	makeLuaText('utilTimer', 'TIME', 300, barTxtX, barTxtY);  
	setTextSize('utilTimer', barTxtSize);
	setTextFont('utilTimer', settings.customFont)
	setTextAlignment('utilTimer', 'center'); 

	setProperty("utilTimer.wordWrap", false)
	setProperty("utilTimer.autoSize", true)
	
	setProperty("utilTimer.antialiasing", gAA)

	setTextBorder('utilTimer', 2, '000000')

	setScrollFactor("utilTimer", 0, 0)
	setObjectCamera("utilTimer", "hud")

	setProperty('utilTimer.alpha', barTxtAlpha)

	addLuaText('utilTimer', true);

	setProperty('utilTimer.visible', oldVisibleTxt)

	setProperty('timeTxt.visible', false)

	--// custom scoreTxt
	makeLuaText('utilScoreTxt', 'Util Score Txt: something went wrong, did not update properly :c', 1000, screenWidth / 2, getProperty('healthBar.y') + 40);  
	setTextSize('utilScoreTxt', 20);
	setTextFont('utilScoreTxt', settings.customFont)
	setTextAlignment('utilScoreTxt', 'center'); 

	setProperty("utilScoreTxt.wordWrap", false)
	setProperty("utilScoreTxt.autoSize", true)
	
	setProperty("utilScoreTxt.antialiasing", gAA)

	setTextBorder('utilScoreTxt', 2, '000000')

	setScrollFactor("utilScoreTxt", 0, 0)
	setObjectCamera("utilScoreTxt", "hud")

	addLuaText('utilScoreTxt', true);

	setProperty('scoreTxt.visible', false)

	getNewScore()

	--// now playing popup
	if nowPlayingPopup then
		boxX = -305
		boxY = 50
		textsX = 10
		nowTextY = 65
		subTextY = 95

		if nowPlayingPosition == 'Top Right' or nowPlayingPosition == 'Bottom Right' then
			boxX = 1405
			textsX = 995
		end
		if nowPlayingPosition == 'Bottom Left' or nowPlayingPosition == 'Bottom Right' then
			boxY = 560
			nowTextY = 575
			subTextY = 605
		end

		makeLuaSprite('utilPlayingLineColor', 'spriteSolid', boxX - 15, boxY) -- color bar
		makeGraphic('utilPlayingLineColor', 300 + 15, 100, dadColFinal)
		setObjectCamera('utilPlayingLineColor', 'other')
		addLuaSprite('utilPlayingLineColor', true)
	
		makeLuaSprite('utilPlayingBox', 'spriteSolid', boxX - 15, boxY) -- box
		makeGraphic('utilPlayingBox', 300, 100, '000000')
		setObjectCamera('utilPlayingBox', 'other')
		addLuaSprite('utilPlayingBox', true)
	
		makeLuaText('utilPlayingTxt', 'Now Playing:', 290, textsX, nowTextY) -- "Now Playing" text
		setTextAlignment('utilPlayingTxt', 'left')
		setObjectCamera('utilPlayingTxt', 'other')
		setTextSize('utilPlayingTxt', 25)
		setProperty('utilPlayingTxt.alpha', 0)
		addLuaText('utilPlayingTxt')
	
		makeLuaText('utilPlayingSubTxt', songName, 290, textsX, subTextY) -- song name sub text
		setTextAlignment('utilPlayingSubTxt', 'left')
		setObjectCamera('utilPlayingSubTxt', 'other')

		if string.len(songName) >= 15 then
			setTextSize('utilPlayingSubTxt', 25)
		elseif string.len(songName) >= 25 then
			setTextSize('utilPlayingSubTxt', 20)
		else
			setTextSize('utilPlayingSubTxt', 30)
		end

		setProperty('utilPlayingSubTxt.alpha', 0)
		addLuaText('utilPlayingSubTxt')
	end

	--// extra configs
	if onlyMarvelous and marvelousRatingEnabled and onlyMarvelousType == 'Images' then
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

	if animatedHudEnabled then
		if not downscroll then
			setProperty('healthBar.y', getProperty('healthBar.y') + 300)
			setProperty('iconP1.y', getProperty('iconP1.y') + 300)
			setProperty('iconP2.y', getProperty('iconP2.y') + 300)
			setProperty('utilScoreTxt.y', getProperty('utilScoreTxt.y') + 300)
		
			setProperty('utilBarBorder.y', getProperty('utilBarBorder.y') - 300)
			setProperty('utilBarEmpty.y', getProperty('utilBarEmpty.y') - 300)
			setProperty('utilBarFill.y', getProperty('utilBarFill.y') - 300)
			setProperty('utilTimer.y', getProperty('utilTimer.y') - 300)
		else
			setProperty('healthBar.y', getProperty('healthBar.y') - 300)
			setProperty('iconP1.y', getProperty('iconP1.y') - 300)
			setProperty('iconP2.y', getProperty('iconP2.y') - 300)
			setProperty('utilScoreTxt.y', getProperty('utilScoreTxt.y') - 300)
		
			setProperty('utilBarBorder.y', getProperty('utilBarBorder.y') + 300)
			setProperty('utilBarEmpty.y', getProperty('utilBarEmpty.y') + 300)
			setProperty('utilBarFill.y', getProperty('utilBarFill.y') + 300)
			setProperty('utilTimer.y', getProperty('utilTimer.y') + 300)
		end

		if ratingCounterEnabled then
			setProperty('combo.x', getProperty('combo.x') - 300)
			setProperty('sick.x', getProperty('sick.x') - 300)
			setProperty('good.x', getProperty('good.x') - 300)
			setProperty('bad.x', getProperty('bad.x') - 300)
			setProperty('shit.x', getProperty('shit.x') - 300)
			setProperty('fc.x', getProperty('fc.x') - 300)
	
			if marvelousRatingEnabled then
				setProperty('marvelous.x', getProperty('marvelous.x') - 300)
			end
		end
	end

	if randomBotplayText then
		loadBotplayTexts()

		math.randomseed(os.time()) -- it's amazing how this piece makes something “““randomized””” work

		local randomIndex = math.random(1, #botplayStrings)
		local botTxt = botplayStrings[randomIndex]
		setTextString("botplayTxt", botTxt)
	end

	if smoothHealthBar then
		setProperty('healthBar.numDivisions', 10000)
	end
end

function onUpdateScore()
	getNewScore()
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

function math.lerp(a, b, t)
    return (b - a) * t + a;
end

function remap(v, str1, stp1, str2, stp2)
	return str2 + (v - str1) * ((stp2 - str2) / (stp1 - str1));
end

















---------------------------------------------------------------------------------------

timeSX = 1
timeSY = 1

scoreTxtSX = 1
scoreTxtSY = 1

local hudArray = {'noMarvelousJPG', 'catWuajajajaJPG'}

function onSongStart()
	if animatedHudEnabled then
		if not downscroll then
			doTweenY('healthBarTween', 'healthBar', getProperty('healthBar.y') - 300, 1, 'quintOut')
			doTweenY('healthIconBFTween', 'iconP1', getProperty('iconP1.y') - 300, 1, 'quintOut')
			doTweenY('healthIconDadTween', 'iconP2', getProperty('iconP2.y') - 300, 1, 'quintOut')
			doTweenY('scoreTxtTween', 'utilScoreTxt', getProperty('utilScoreTxt.y') - 300, 1, 'quintOut')
		
			doTweenY('utilBarBorderTween', 'utilBarBorder', getProperty('utilBarBorder.y') + 300, 1, 'quintOut')
			doTweenY('utilBarEmptyTween', 'utilBarEmpty', getProperty('utilBarEmpty.y') + 300, 1, 'quintOut')
			doTweenY('utilBarFillTween', 'utilBarFill', getProperty('utilBarFill.y') + 300, 1, 'quintOut')
			doTweenY('utilTimerTween', 'utilTimer', getProperty('utilTimer.y') + 300, 1, 'quintOut')
		else
			doTweenY('healthBarTween', 'healthBar', getProperty('healthBar.y') + 300, 1, 'quintOut')
			doTweenY('healthIconBFTween', 'iconP1', getProperty('iconP1.y') + 300, 1, 'quintOut')
			doTweenY('healthIconDadTween', 'iconP2', getProperty('iconP2.y') + 300, 1, 'quintOut')
			doTweenY('scoreTxtTween', 'utilScoreTxt', getProperty('utilScoreTxt.y') + 300, 1, 'quintOut')
		
			doTweenY('utilBarBorderTween', 'utilBarBorder', getProperty('utilBarBorder.y') - 300, 1, 'quintOut')
			doTweenY('utilBarEmptyTween', 'utilBarEmpty', getProperty('utilBarEmpty.y') - 300, 1, 'quintOut')
			doTweenY('utilBarFillTween', 'utilBarFill', getProperty('utilBarFill.y') - 300, 1, 'quintOut')
			doTweenY('utilTimerTween', 'utilTimer', getProperty('utilTimer.y') - 300, 1, 'quintOut')
		end

		if ratingCounterEnabled then
			if marvelousRatingEnabled then
				doTweenX('ratingComboTween', 'combo', getProperty('combo.x') + 300, 1, 'quintOut')
				doTweenX('ratingMarvelousTween', 'marvelous', getProperty('marvelous.x') + 300, 1.15, 'quintOut')
				doTweenX('ratingSickTween', 'sick', getProperty('sick.x') + 300, 1.25, 'quintOut')
				doTweenX('ratingGoodTween', 'good', getProperty('good.x') + 300, 1.35, 'quintOut')
				doTweenX('ratingBadTween', 'bad', getProperty('bad.x') + 300, 1.45, 'quintOut')
				doTweenX('ratingShitTween', 'shit', getProperty('shit.x') + 300, 1.55, 'quintOut')
				doTweenX('ratingFcTween', 'fc', getProperty('fc.x') + 300, 1.65, 'quintOut')
			else
				doTweenX('ratingComboTween', 'combo', getProperty('combo.x') + 300, 1, 'quintOut')
				doTweenX('ratingSickTween', 'sick', getProperty('sick.x') + 300, 1.15, 'quintOut')
				doTweenX('ratingGoodTween', 'good', getProperty('good.x') + 300, 1.25, 'quintOut')
				doTweenX('ratingBadTween', 'bad', getProperty('bad.x') + 300, 1.35, 'quintOut')
				doTweenX('ratingShitTween', 'shit', getProperty('shit.x') + 300, 1.45, 'quintOut')
				doTweenX('ratingFcTween', 'fc', getProperty('fc.x') + 300, 1.55, 'quintOut')
			end
		end
	end

	if nowPlayingPopup then
		if nowPlayingPosition == 'Top Left' or nowPlayingPosition == 'Bottom Left' then
			doTweenX('MoveInOne', 'utilPlayingLineColor', 0, 0.35, 'CircInOut')
		elseif nowPlayingPosition == 'Top Right' or nowPlayingPosition == 'Bottom Right' then
			doTweenX('MoveInOne', 'utilPlayingLineColor', 970, 0.35, 'CircInOut')
		end

		runTimer('utilPlayingBoxBegin', 0.25, 1)
	end
end

function onBeatHit()
    if settings.timerZoomOnBeat then
        tweenNumber(nil, "timeSX", 1.2, 1, .2, nil, easing.linear)
        tweenNumber(nil, "timeSY", 1.2, 1, .2, nil, easing.linear)
    end
end

function getRatingMS(diff)
	diff = math.abs(diff)

	local windowSick = getProperty('ratingsData[0].hitWindow')
	local windowGood = getProperty('ratingsData[1].hitWindow')
	local windowBad = getProperty('ratingsData[2].hitWindow')

	if marvelousRatingEnabled and diff <= marvelousRatingMs then
		return 'marvelous'
	end

	if diff <= windowSick then
		return 'sick'
	end

	if diff <= windowGood then
		return 'good'
	end

	if diff <= windowBad then
		return 'bad'
	end

	return 'shit'
end

function addRatingMS(diff, noteTouch)
	if not onlyMarvelous or not marvelousRatingEnabled or onlyMarvelousType ~= 'Images' then return end

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
	if botPlay and getBotScore and not isSustainNote then
		local strumTime = getPropertyFromGroup('notes', id, 'strumTime')
		isEarly = strumTime < getSongPosition() and '' or '-'

		local fRating = getRatingMS((strumTime - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset')) / playbackRate)

		if fRating == 'marvelous' then
			bScore = bScore + 500
		elseif fRating == 'sick' then
			bScore = bScore + 350
		elseif fRating == 'good' then
			bScore = bScore + 200
		elseif fRating == 'bad' then
			bScore = bScore + 100
		elseif fRating == 'shit' then
			bScore = bScore + 50
		end
	end

	getNewScore()

	if (not isSustainNote) then
		tweenNumber(nil, "scoreTxtSX", 1.075, 1, .2, nil, easing.linear)
		tweenNumber(nil, "scoreTxtSY", 1.075, 1, .2, nil, easing.linear)

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

	if botPlay or practice then
        if usedCheats ~= true then
            usedCheats = true
        end
    end

	scaleObject('utilBarFill', barLength * getProperty("songPercent"), barThickness)

    if settings.modernTimer then
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
        
		if settings.styleTimer == 'Psych Engine' then
			setTextString('utilTimer', timeText)
		else
			setTextString('utilTimer', barTxtBefore..' ('..timeText..')')
		end
	else
		local ogTimeText = getProperty('timeTxt.text')
		if hasBarTxtBefore == true then
			if ogTimeText == barTxtBefore then
				return setTextString('utilTimer', barTxtBefore)
			end

			if ogTimeText == '' then
				setTextString('utilTimer', barTxtBefore..' (0:00)')
			else
				setTextString('utilTimer', barTxtBefore..' ('..ogTimeText..')')
			end
		else
			if barTxtBefore ~= '' then
				setTextString('utilTimer', barTxtBefore)
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

	if smoothHealthBar then
		healthFlip = getProperty('healthBar.flipX') or getProperty('healthBar.angle') == 180 or getProperty('healthBar.scale.x') == -1

		healthPercent = math.lerp(healthPercent, math.max((getProperty('health') * 50), 0), (dt * 10))
		setProperty('healthBar.percent', healthPercent)
		if healthPercent > 100 then healthPercent = 100 end

		local usePer = (healthFlip and healthPercent or remap(healthPercent, 0, 100, 100, 0)) * 0.01
		local part = getProperty('healthBar.x') + ((getProperty('healthBar.width')) * usePer)
		local iconParts = {part + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26, part - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2}
	
		for i = 1, 2 do
			setProperty('iconP'..i..'.x', iconParts[healthFlip and ((i % 2) + 1) or i])
			setProperty('iconP'..i..'.flipX', healthFlip)
		end
	end

    if settings.timerZoomOnBeat then
        setProperty("utilTimer.scale.x", timeSX)
        setProperty("utilTimer.scale.y", timeSY)
    end

    local timerWidth = getProperty('utilTimer.width')
    setProperty('utilTimer.x', (screenWidth - timerWidth) / 2)

	local scoreWidth = getProperty('utilScoreTxt.width')
    setProperty('utilScoreTxt.x', (screenWidth - scoreWidth) / 2)

	setProperty("utilScoreTxt.scale.x", scoreTxtSX)
	setProperty("utilScoreTxt.scale.y", scoreTxtSY)

	if showNPS then
		Nps = getVar("utilNpsCurrent")
		MaxNps = getVar("utilNpsMax")

		if MaxNps < Nps then
			MaxNps = Nps
		end 

		getNewScore()
	end
end

function onGameOverStart()
	--[[ Hey Modders! ✌️

	I have made a variable in case you want to add any text to Show Reason of Game Over:
	use 'setVar("utilGOReasonExtra", "Custom Reason")' to make the reason text to your liking!

		~ MaxxVoiid
	]]

	if not showReasonGO then return end

	local extraDeathReason = getVar("utilGOReasonExtra")
	local deathReason = getVar("utilGOReason")
	if deathReason == nil then deathReason = 'Died to health' end

	if extraDeathReason ~= nil and extraDeathReason ~= '' then
		makeLuaText('deathReason', extraDeathReason, screenWidth, 0, 900)
	else
		makeLuaText('deathReason', deathReason, screenWidth, 0, 900)
	end

    setObjectCamera("deathReason", "other")
    setTextSize('deathReason', 32)
    addLuaText("deathReason")

    doTweenY('upDeathReason', 'deathReason', 600, 1.5, 'quintOut')
end

function onGameOverConfirm(retry)
	if not showReasonGO then return end

    doTweenAlpha("fadeOutReasonText", "deathReason", 0, 1, "linear")
end

function onTimerCompleted(tag, loops, loopsLeft)
	if nowPlayingPosition == 'Top Left' or nowPlayingPosition == 'Bottom Left' then

		if tag == 'utilPlayingBoxBegin' then
			doTweenX('MoveInTwo', 'utilPlayingBox', 0, 0.35, 'CircInOut')
	
			runTimer('utilPlayingTxtBegin', 0.25, 1)
		end
		if tag == 'utilPlayingTxtBegin' then
			doTweenAlpha('fadeInTxt', 'utilPlayingTxt', 1, 0.5, 'linear')
			doTweenAlpha('fadeInSubTxt', 'utilPlayingSubTxt', 1, 0.5, 'linear')
	
			runTimer('utilPlayingBoxWait', nowPlayingDuration, 1)
		end
		if tag == 'utilPlayingBoxWait' then
			doTweenX('MoveOutTwo', 'utilPlayingBox', -450, 0.35, 'CircInOut')
	
			setProperty('utilPlayingTxt.alpha', 0)
			setProperty('utilPlayingSubTxt.alpha', 0)
	
			runTimer('utilPlayingBoxLeave', 0.25, 1)
		end
		if tag == 'utilPlayingBoxLeave' then
			doTweenX('MoveOutOne', 'utilPlayingLineColor', -450, 0.35, 'CircInOut')

			runTimer('utilPlayingNonVisible', 1, 1)
		end

	elseif nowPlayingPosition == 'Top Right' or nowPlayingPosition == 'Bottom Right' then

		if tag == 'utilPlayingBoxBegin' then
			doTweenX('MoveInTwo', 'utilPlayingBox', 985, 0.35, 'CircInOut')
	
			runTimer('utilPlayingTxtBegin', 0.25, 1)
		end
		if tag == 'utilPlayingTxtBegin' then
			doTweenAlpha('fadeInTxt', 'utilPlayingTxt', 1, 0.5, 'linear')
			doTweenAlpha('fadeInSubTxt', 'utilPlayingSubTxt', 1, 0.5, 'linear')
	
			runTimer('utilPlayingBoxWait', nowPlayingDuration, 1)
		end
		if tag == 'utilPlayingBoxWait' then
			doTweenX('MoveOutTwo', 'utilPlayingBox', 1405, 0.35, 'CircInOut')
	
			setProperty('utilPlayingTxt.alpha', 0)
			setProperty('utilPlayingSubTxt.alpha', 0)
	
			runTimer('utilPlayingBoxLeave', 0.25, 1)
		end
		if tag == 'utilPlayingBoxLeave' then
			doTweenX('MoveOutOne', 'utilPlayingLineColor', 1405, 0.35, 'CircInOut')

			runTimer('utilPlayingNonVisible', 1, 1)
		end

	end

	if tag == 'utilPlayingNonVisible' then
		setProperty('utilPlayingLineColor.visible', false)
		setProperty('utilPlayingBox.visible', false)
		setProperty('utilPlayingTxt.visible', false)
		setProperty('utilPlayingSubTxt.visible', false)
	end
end
