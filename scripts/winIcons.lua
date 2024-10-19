--[[ Hey neds 🤓☝️

This script handles all these functions:
- Shaking Icons
- BF Winning Icon
- Opponent Winning Icon
- Old BF Easter Egg Icon


This script works as it should, don't touch anything if you don't know what you are doing :)
    ~ MaxxVoiid

]]





-----------------------------------------------------------------------
    --- DON'T EDIT ANYTHING IF YOU DON'T KNOW WHAT YOU'RE DOING ---
-----------------------------------------------------------------------

local iconsShake = getModSetting('shakingicons')
local bfWinIcon = getModSetting('bfwinicon')
local dadWinIcon = getModSetting('opponentwinicon')
local opponentPlay = getModSetting('opponentplay')
local oldBFIcon = getModSetting('oldbficon')

bfWinningIcons = bfWinIcon
dadWinningIcons = dadWinIcon

bfLoseShakeIcon = true
dadLoseShakeIcon = true

canShakeIcon = false
iconShake = ''

if iconsShake == 'Opponent & BF' then
	bfLoseShakeIcon = true
	dadLoseShakeIcon = true
elseif iconsShake == 'Only Opponent' then
	bfLoseShakeIcon = false
	dadLoseShakeIcon = true
elseif iconsShake == 'Only BF' then
	bfLoseShakeIcon = true
	dadLoseShakeIcon = false
elseif iconsShake == 'None' then
	bfLoseShakeIcon = false
	dadLoseShakeIcon = false
end

local previousBeatTime = 0
local existsBFWinning = false
local existsDadWinning = false
local pathWinningBF = ''
local pathWinningDad = ''

function onCreatePost()
	closeIfUtilNotEnabled()

	existsBFWinning = false
	existsDadWinning = false

	createIcons()
end

function shakeIconWhile(icon, time)
	iconShake = icon
	runTimer('stopIconShake', time)
	runTimer('shakeIcon', 0.05, 9999)
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'stopIconShake' then
		canShakeIcon = false
		setProperty(iconShake..'.angle', 0)
	end

	if tag == 'shakeIcon' then
		if canShakeIcon then
			local angleOfs = math.random(-5, 5)
			setProperty(iconShake..'.angle', angleOfs)
		end
	end
end

function onCountdownStarted()
	if oldBFIcon then
		setObjectOrder('oldBFNormalIcoPlayer', getObjectOrder('iconP1'))
		makeLuaSprite('oldBFNormalIcoPlayer', 'icons/icon-bf-old-normal', getProperty('iconP1.x'), getProperty('iconP1.y'))
		callScript('scripts/usefulFunctions', 'setObjectCamera', {'oldBFNormalIcoPlayer', 'hud'}) -- setObjectCamera('oldBFNormalIcoPlayer', 'hud')
		addLuaSprite('oldBFNormalIcoPlayer', true)
		setProperty('oldBFNormalIcoPlayer.alpha', 1)
		setProperty('oldBFNormalIcoPlayer.flipX', true)

		setObjectOrder('oldBFDryingIcoPlayer', getObjectOrder('iconP1'))
		makeLuaSprite('oldBFDryingIcoPlayer', 'icons/icon-bf-old-drying', getProperty('iconP1.x'), getProperty('iconP1.y'))
		callScript('scripts/usefulFunctions', 'setObjectCamera', {'oldBFDryingIcoPlayer', 'hud'}) -- setObjectCamera('oldBFDryingIcoPlayer', 'hud')
		addLuaSprite('oldBFDryingIcoPlayer', true)
		setProperty('oldBFDryingIcoPlayer.alpha', 0)
		setProperty('oldBFDryingIcoPlayer.flipX', true)

		setProperty('boyfriend.healthColorArray', {233, 255, 72})
		triggerEvent('Change Character', 'bf', getProperty('boyfriend.curCharacter'))
	end
end

function createIcons()
	--BF
	if bfWinningIcons == true then
		customWinningBFFile = checkFileExists('images/icons/custom_winning/win-'..getProperty('boyfriend.healthIcon')..'.png')
		winningBFFile = checkFileExists('images/icons/win-'..getProperty('boyfriend.healthIcon')..'.png')

		if customWinningBFFile then
			pathWinningBF = 'icons/custom_winning/win-'..getProperty('boyfriend.healthIcon')
			existsBFWinning = true

			makeLuaSprite('winIcoPlayer', pathWinningBF, getProperty('iconP1.x'), getProperty('iconP1.y'))
			callScript('scripts/usefulFunctions', 'setObjectCamera', {'winIcoPlayer', 'hud'}) -- setObjectCamera('winIcoPlayer', 'hud')
			addLuaSprite('winIcoPlayer', true)
			setProperty('winIcoPlayer.flipX', true)
			setProperty('winIcoPlayer.alpha', 0)
		elseif winningBFFile then
			pathWinningBF = 'icons/win-'..getProperty('boyfriend.healthIcon')
			existsBFWinning = true

			makeLuaSprite('winIcoPlayer', pathWinningBF, getProperty('iconP1.x'), getProperty('iconP1.y'))
			callScript('scripts/usefulFunctions', 'setObjectCamera', {'winIcoPlayer', 'hud'}) -- setObjectCamera('winIcoPlayer', 'hud')
			addLuaSprite('winIcoPlayer', true)
			setProperty('winIcoPlayer.flipX', true)
			setProperty('winIcoPlayer.alpha', 0)
		end
	end

	--Opponent
	if dadWinningIcons == true then
		customWinningDadFile = checkFileExists('images/icons/custom_winning/win-'..getProperty('dad.healthIcon')..'.png')
		winningDadFile = checkFileExists('images/icons/win-'..getProperty('dad.healthIcon')..'.png')

		if customWinningDadFile then
			pathWinningDad = 'icons/custom_winning/win-'..getProperty('dad.healthIcon')
			existsDadWinning = true

			makeLuaSprite('winIcoOpponent', pathWinningDad, getProperty('iconP2.x'), getProperty('iconP2.y'))
			callScript('scripts/usefulFunctions', 'setObjectCamera', {'winIcoOpponent', 'hud'}) -- setObjectCamera('winIcoOpponent', 'hud')
			addLuaSprite('winIcoOpponent', true)
			setProperty('winIcoOpponent.flipX', false)
			setProperty('winIcoOpponent.alpha', 0)
		elseif winningDadFile then
			pathWinningDad = 'icons/win-'..getProperty('dad.healthIcon')
			existsDadWinning = true

			makeLuaSprite('winIcoOpponent', pathWinningDad, getProperty('iconP2.x'), getProperty('iconP2.y'))
			callScript('scripts/usefulFunctions', 'setObjectCamera', {'winIcoOpponent', 'hud'}) -- setObjectCamera('winIcoOpponent', 'hud')
			addLuaSprite('winIcoOpponent', true)
			setProperty('winIcoOpponent.flipX', false)
			setProperty('winIcoOpponent.alpha', 0)
		end
	end
end

function onUpdatePost(elapsed)
		local actBFIconVisible = getProperty('iconP1.visible')
		local actDadIconVisible = getProperty('iconP2.visible')

		if oldBFIcon then
			actBFIconVisible = false
			bfWinningIcons = false

			--Set pos
			setProperty('oldBFNormalIcoPlayer.x', getProperty('iconP1.x'))
			setProperty('oldBFNormalIcoPlayer.angle', getProperty('iconP1.angle'))
			setProperty('oldBFNormalIcoPlayer.y', getProperty('iconP1.y'))
			setProperty('oldBFNormalIcoPlayer.scale.x', getProperty('iconP1.scale.x'))
			setProperty('oldBFNormalIcoPlayer.scale.y', getProperty('iconP1.scale.y'))

			setProperty('oldBFDryingIcoPlayer.x', getProperty('iconP1.x'))
			setProperty('oldBFDryingIcoPlayer.angle', getProperty('iconP1.angle'))
			setProperty('oldBFDryingIcoPlayer.y', getProperty('iconP1.y'))
			setProperty('oldBFDryingIcoPlayer.scale.x', getProperty('iconP1.scale.x'))
			setProperty('oldBFDryingIcoPlayer.scale.y', getProperty('iconP1.scale.y'))

			setProperty('iconP1.visible', false)
		end

		--BF
		if bfWinningIcons == true and existsBFWinning == true then
			--Set sprite and things
			setObjectOrder('winIcoPlayer', getObjectOrder('iconP1') - 1)
			makeLuaSprite('winIcoPlayer', pathWinningBF, getProperty('iconP1.x'), getProperty('iconP1.y'))
			callScript('scripts/usefulFunctions', 'setObjectCamera', {'winIcoPlayer', 'hud'}) -- setObjectCamera('winIcoPlayer', 'hud')
			addLuaSprite('winIcoPlayer', true)
			setProperty('winIcoPlayer.flipX', true)
			setProperty('winIcoPlayer.alpha', 0)

			--Set pos
			setProperty('winIcoPlayer.x', getProperty('iconP1.x'))
			setProperty('winIcoPlayer.angle', getProperty('iconP1.angle'))
			setProperty('winIcoPlayer.alpha', getProperty('iconP1.alpha'))
			setProperty('winIcoPlayer.y', getProperty('iconP1.y'))
			setProperty('winIcoPlayer.scale.x', getProperty('iconP1.scale.x'))
			setProperty('winIcoPlayer.scale.y', getProperty('iconP1.scale.y'))
		end

		if dadWinningIcons == true and existsDadWinning == true then
			--Set sprite and things
			setObjectOrder('winIcoOpponent', getObjectOrder('iconP2') - 1)
			makeLuaSprite('winIcoOpponent', pathWinningDad, getProperty('iconP2.x'), getProperty('iconP2.y'))
			callScript('scripts/usefulFunctions', 'setObjectCamera', {'winIcoOpponent', 'hud'}) -- setObjectCamera('winIcoOpponent', 'hud')
			addLuaSprite('winIcoOpponent', true)
			setProperty('winIcoOpponent.flipX', false)
			setProperty('winIcoOpponent.alpha', 0)

			--Set pos
			setProperty('winIcoOpponent.x', getProperty('iconP2.x'))
			setProperty('winIcoOpponent.angle', getProperty('iconP2.angle'))
			setProperty('winIcoOpponent.alpha', getProperty('iconP2.alpha'))
			setProperty('winIcoOpponent.y', getProperty('iconP2.y'))
			setProperty('winIcoOpponent.scale.x', getProperty('iconP2.scale.x'))
			setProperty('winIcoOpponent.scale.y', getProperty('iconP2.scale.y'))
		end

		-- Handle Icons
		if not opponentPlay then
			if bfWinningIcons == true then
				if getProperty('health') >= 1.62 and existsBFWinning == true then
					setProperty('winIcoPlayer.alpha', 1)
					setProperty('iconP1.alpha', 0)
				else
					setProperty('winIcoPlayer.alpha', 0)
					setProperty('iconP1.alpha', 1)
				end
			end

			if dadWinningIcons == true then
				if getProperty('health') <= 0.4 and existsDadWinning == true then
					setProperty('iconP2.alpha', 0)
					setProperty('winIcoOpponent.alpha', 1)
				else
					setProperty('iconP2.alpha', 1)
					setProperty('winIcoOpponent.alpha', 0)
				end
			end

			if oldBFIcon then
				if getProperty('health') <= 0.38 then -- Old BF Losing Icon
					setProperty('oldBFNormalIcoPlayer.alpha', 0)
					setProperty('oldBFDryingIcoPlayer.alpha', 1)
				else -- Old BF Normal Icon
					setProperty('oldBFNormalIcoPlayer.alpha', 1)
					setProperty('oldBFDryingIcoPlayer.alpha', 0)
				end
			end
		else
			-- This here fixes bugs with icons in Play As Opponent

			if dadWinningIcons == true then
				if getProperty('health') >= 1.62 and existsDadWinning == true then
					setProperty('iconP2.alpha', 0)
					setProperty('winIcoOpponent.alpha', 1)
				else
					setProperty('iconP2.alpha', 1)
					setProperty('winIcoOpponent.alpha', 0)
				end
			end

			if bfWinningIcons == true then
				if getProperty('health') <= 0.38 and existsBFWinning == true then -- BF Winning Icon
					setProperty('winIcoPlayer.alpha', 1)
					setProperty('iconP1.alpha', 0)
				elseif getProperty('health') >= 1.62 then -- BF Losing Icon
					setProperty('iconP1.animation.curAnim.curFrame', 1)
					setProperty('winIcoPlayer.alpha', 0)
				else -- BF Normal Icon (I've had serious problems with this)
					setProperty('iconP1.animation.curAnim.curFrame', 0)
					setProperty('winIcoPlayer.alpha', 0)
					setProperty('iconP1.alpha', 1)
				end
			else
				if oldBFIcon then
					if getProperty('health') >= 1.62 then -- Old BF Losing Icon
						setProperty('oldBFNormalIcoPlayer.alpha', 0)
						setProperty('oldBFDryingIcoPlayer.alpha', 1)
					else -- Old BF Normal Icon
						setProperty('oldBFNormalIcoPlayer.alpha', 1)
						setProperty('oldBFDryingIcoPlayer.alpha', 0)
					end
				else
					if getProperty('health') >= 1.62 then -- BF Losing Icon
						setProperty('iconP1.animation.curAnim.curFrame', 1)
					else -- BF Normal Icon
						setProperty('iconP1.animation.curAnim.curFrame', 0)
					end
				end
			end
		end
end

function onBeatHit()
		local currentBeatTime = getSongPosition()
		local timeDifference = currentBeatTime - previousBeatTime
		timeDifference = (timeDifference / 2) / 1000

		--Shake
		local angleOfs = math.random(-5, 5)

		if not opponentPlay then
			if getProperty('healthBar.percent') > 80 and dadLoseShakeIcon then
				canShakeIcon = true
				shakeIconWhile('iconP2', timeDifference)
			elseif getProperty('healthBar.percent') < 20 and bfLoseShakeIcon then
				canShakeIcon = true
				shakeIconWhile('iconP1', timeDifference)
			else
				canShakeIcon = false
				setProperty('iconP1.angle', 0)
				setProperty('iconP2.angle', 0)
			end
		else
			if getProperty('healthBar.percent') < 20 and dadLoseShakeIcon then
				canShakeIcon = true
				shakeIconWhile('iconP2', timeDifference)
			elseif getProperty('healthBar.percent') > 80 and bfLoseShakeIcon then
				canShakeIcon = true
				shakeIconWhile('iconP1', timeDifference)
			else
				canShakeIcon = false
				setProperty('iconP1.angle', 0)
				setProperty('iconP2.angle', 0)
			end
		end

		previousBeatTime = currentBeatTime
end

function onEvent(name, value1, value2, strumTime)
		if name == 'Change Character' then
			--Update characters
			if existsBFWinning == true then
				removeLuaSprite('winIcoPlayer', true)
			end
			createIcons()
		end
end

function closeIfUtilNotEnabled()
    local var, debug = getVar("utilEnabled"), getVar("utilLoadDebug")

    if var == false or var == nil then
        return close()
    end

    if debug == true and debug ~= nil then
        local sName = 'WI'
        debugPrint(sName..': OK')
    end
end
