local iconsShake = getModSetting('shakingicons')
local bfWinIcon = getModSetting('bfwinicon')
local opponentPlay = getModSetting('opponentplay')

bfWinningIcons = bfWinIcon

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

function onCreatePost()
	createIcons()
end

function createIcons()
	--BF
	if bfWinningIcons == true then
		makeLuaSprite('winIcoPlayer', 'icons/win-'..getProperty('boyfriend.healthIcon'), getProperty('iconP1.x'), getProperty('iconP1.y'))
		setObjectCamera('winIcoPlayer', 'hud')
		addLuaSprite('winIcoPlayer', true)
		setProperty('winIcoPlayer.flipX', true)
		setProperty('winIcoPlayer.visible', false)
	end
end

function onUpdatePost(elapsed)
		--BF
		if bfWinningIcons == true then
			--Set sprite and things
			setObjectOrder('winIcoPlayer', getObjectOrder('iconP1') - 1)
			makeLuaSprite('winIcoPlayer', 'icons/win-'..getProperty('boyfriend.healthIcon'), getProperty('iconP1.x'), getProperty('iconP1.y'))
			setObjectCamera('winIcoPlayer', 'hud')
			addLuaSprite('winIcoPlayer', true)
			setProperty('winIcoPlayer.flipX', true)
			setProperty('winIcoPlayer.visible', false)

			--Set pos
			setProperty('winIcoPlayer.x', getProperty('iconP1.x'))
			setProperty('winIcoPlayer.angle', getProperty('iconP1.angle'))
			setProperty('winIcoPlayer.alpha', getProperty('iconP1.alpha'))
			setProperty('winIcoPlayer.y', getProperty('iconP1.y'))
			setProperty('winIcoPlayer.scale.x', getProperty('iconP1.scale.x'))
			setProperty('winIcoPlayer.scale.y', getProperty('iconP1.scale.y'))

			--Toggle win icon
			if not opponentPlay then
				if getProperty('health') >= 1.62 then
					setProperty('iconP1.visible', false)
					setProperty('winIcoPlayer.visible', true)
				else
					setProperty('iconP1.visible', true)
					setProperty('winIcoPlayer.visible', false)
				end
			else
				-- This here fixes bugs with icons in Play As Opponent

				if getProperty('health') <= 0.38 then -- BF Winning Icon
					setProperty('iconP1.visible', false)
					setProperty('winIcoPlayer.visible', true)
				elseif getProperty('health') >= 1.62 then -- BF Losing Icon
					setProperty('iconP1.animation.curAnim.curFrame', 1)
				else -- BF Normal Icon (I've had serious problems with this)
					setProperty('iconP1.animation.curAnim.curFrame', 0)
					setProperty('iconP1.visible', true)
					setProperty('winIcoPlayer.visible', false)
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
			removeLuaSprite('winIcoPlayer', true)
			createIcons()
		end
end
