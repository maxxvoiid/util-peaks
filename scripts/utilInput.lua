--[[ Hey neds 🤓☝️

This script handles all these functions:
- Only Marvelous Event: Instakill & Crash
- Achievement: Master of notes, Accuracy Legend & Marvelous Chaos


This script works as it should, don't touch anything if you don't know what you are doing :)
    ~ MaxxVoiid

]]





-----------------------------------------------------------------------
    --- DON'T EDIT ANYTHING IF YOU DON'T KNOW WHAT YOU'RE DOING ---
-----------------------------------------------------------------------

local fullFcName = getModSetting('fullfcname')

local marvelousRatingEnabled = getModSetting('marvelousenabled')
local marvelousRatingMs = getModSetting('marvelousms')

local onlyMarvelousEnabled = getModSetting('onlymarvelous')
local onlyMarvelousType = getModSetting('onlymarveloustype')

local showNPS = getModSetting('shownps')

local usedCheats = false
local cheerGfCombo = true -- makes gf celebrate if you reach 50 combo
local cryGfCombo = true -- makes gf cry if you have lost a combo greater than 10

local actKeyHit = 0
local actCombo = 0
local actMarvelous = 0
local actSick = 0
local actGood = 0
local actBad = 0
local actShit = 0
local actMisses = 0

local Nps = 0
local MaxNps = 0
local npsRefresh1 = 0
local npsRefresh2 = 0

local trueHealthLossSus = 0
local trueHealthLossNor = 0

local oMInsta = false
local oMCrash = false

function onCreatePost()
    closeIfUtilNotEnabled()
    updCFC(true)

    opponentName = getProperty('dad.curCharacter')

    trueHealthLossNor = 0.3*healthLossMult
    trueHealthLossSus = 0.1*healthLossMult

    if marvelousRatingEnabled and onlyMarvelousEnabled then
        if onlyMarvelousType == 'Instakill' then
            oMInsta = true
        elseif onlyMarvelousType == 'Crash' then
            oMCrash = true
        end
    end

    if showNPS then
		runTimer(npsTimer1, 0.1, 0)
		runTimer(npsTimer2, 0.5, 0)
	end
end

function getRatingMS(diff)
    diff = math.abs(diff)

    local windowSick = getProperty('ratingsData[0].hitWindow')
    local windowGood = getProperty('ratingsData[1].hitWindow')
    local windowBad = getProperty('ratingsData[2].hitWindow')

    if marvelousRatingEnabled and diff <= marvelousRatingMs then
        actMarvelous = actMarvelous + 1
        return { marvelous = true, ms = math.floor(diff), rating = 'Marvelous' }
    end

    if diff <= windowSick then
        actSick = actSick + 1
        return { marvelous = false, ms = math.floor(diff), rating = 'Sick!' }
    end

    if diff <= windowGood then
        actGood = actGood + 1
        return { marvelous = false, ms = math.floor(diff), rating = 'Good' }
    end

    if diff <= windowBad then
        actBad = actBad + 1
        return { marvelous = false, ms = math.floor(diff), rating = 'Bad' }
    end

    actShit = actShit + 1
    return { marvelous = false, ms = math.floor(diff), rating = 'Shit' }
end

function updCFC(initial) -- Update CURRENT FC
    local misses = getProperty('songMisses')

    if initial == true then
        return setVar('utilCFC', '?') -- prevents any strange bugs from occurring where it cannot pick up the fc well
    end

    if fullFcName then
        if misses >= 1000 then
            return setVar('utilCFC', 'Quadruple Digit Combo Break')
        end
    
        if misses >= 100 then
            return setVar('utilCFC', 'Triple Digit Combo Break')
        end
    
        if misses >= 10 then
            return setVar('utilCFC', 'CLEAR')
        end
    
        if misses > 0 then
            return setVar('utilCFC', 'Single Digit Combo Break')
        end
    
        if (actBad > 0 or actShit > 0) and misses == 0 then
            return setVar('utilCFC', 'Full Combo')
        end
    
        if actGood > 0 and misses == 0 then
            return setVar('utilCFC', 'Good Full Combo')
        end
    
        if actSick > 0 and misses == 0 then
            return setVar('utilCFC', 'Sick Full Combo')
        end
    
        if actMarvelous > 0 and misses == 0 then
            return setVar('utilCFC', 'Marvelous Full Combo')
        end
    else
        if misses >= 1000 then
            return setVar('utilCFC', 'QDCB')
        end
    
        if misses >= 100 then
            return setVar('utilCFC', 'TDCB')
        end
    
        if misses >= 10 then
            return setVar('utilCFC', 'CLEAR')
        end
    
        if misses > 0 then
            return setVar('utilCFC', 'SDCB')
        end
    
        if (actBad > 0 or actShit > 0) and misses == 0 then
            return setVar('utilCFC', 'FC')
        end
    
        if actGood > 0 and misses == 0 then
            return setVar('utilCFC', 'GFC')
        end
    
        if actSick > 0 and misses == 0 then
            return setVar('utilCFC', 'SFC')
        end
    
        if actMarvelous > 0 and misses == 0 then
            return setVar('utilCFC', 'MFC')
        end
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if (not isSustainNote) then
        local strumTime = getPropertyFromGroup('notes', id, 'strumTime')
        isEarly = strumTime < getSongPosition() and '' or '-'

        local ratingData = getRatingMS((strumTime - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset')) / playbackRate)

        updCFC()

        actCombo = actCombo + 1
        actKeyHit = actKeyHit + 1
        npsRefresh1 = npsRefresh1 + 1

        if actCombo == 50 and cheerGfCombo then
            if startsWith(opponentName, "gf") then -- Tutorial GF is actually Dad! The GF is an sussy! ding ding ding ding ding ding ding
                triggerEvent('Play Animation', 'cheer', 'dad')
            else
                triggerEvent('Play Animation', 'cheer', 'gf')
            end
        end

        local marvelous = ratingData.marvelous
        local ms = tostring(ratingData.ms)
        local rating = tostring(ratingData.rating)

        if marvelous == false then
            if oMCrash == true then
                addHaxeLibrary('Application', 'lime.app')

                runHaxeCode('Application.current.window.alert("You get a '..rating..' ('..ms..'ms)\n\nClick OK to close the game", "No Marvelous");')
            
                os.exit();
            end

            if oMInsta == true then
                setVar("utilGOReason", 'Died to a '..rating..' ('..ms..'ms)')

                setHealth(-1)
            end
        end
    end
end

function noteMissPress(direction)
    updCFC()

    if actCombo >= 10 and cryGfCombo then
        if startsWith(opponentName, "gf") then
            triggerEvent('Play Animation', 'sad', 'dad')
        else
            triggerEvent('Play Animation', 'sad', 'gf')
        end
    end

    actCombo = 0

    if oMCrash == true then
        addHaxeLibrary('Application', 'lime.app')

        runHaxeCode('Application.current.window.alert("You missed a note\n\nClick OK to close the game", "No Marvelous");')
    
        os.exit();
    end

    if oMInsta == true then 
        setVar("utilGOReason", 'Died to a missed note')
        setHealth(-1)
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
    updCFC()

    if actCombo >= 10 and cryGfCombo then
        if startsWith(opponentName, "gf") then
            triggerEvent('Play Animation', 'sad', 'dad')
        else
            triggerEvent('Play Animation', 'sad', 'gf')
        end
    end

    actCombo = 0

    if noteType == 'Hurt Note' then
        if instakillOnMiss or getProperty('health') < trueHealthLossNor or (isSustainNote and getProperty('health') < trueHealthLossSus) then
            setVar("utilGOReason", 'Died to a hurt note')
        end
    else
        if instakillOnMiss then
            setVar("utilGOReason", 'Died to a missed note')
        end
    end

    if oMCrash == true then
        addHaxeLibrary('Application', 'lime.app')

        runHaxeCode('Application.current.window.alert("You missed a note\n\nClick OK to close the game", "No Marvelous");')
    
        os.exit();
    end

    if oMInsta == true then 
        setVar("utilGOReason", 'Died to a missed note')
        setHealth(-1)
    end
end

function onUpdatePost(elapsed)
    local practice = getProperty('practiceMode')

    if keyJustPressed('reset') then
        setVar("utilGOReason", 'Reset button pressed')
    end

    if botPlay or practice then
        if usedCheats ~= true then
            usedCheats = true
        end
    end

    if showNPS then
        setVar("utilNpsCurrent", Nps)

        if MaxNps < Nps then
            MaxNps = Nps
			setVar("utilNpsMax", MaxNps)
		end 
	end
end

function onEndSong()
    local progressMasterNotes = getAchievementScore('master_notes')

    if usedCheats == false and actKeyHit > 0 then
        if MaxNps >= 12 then
			setAchievementScore('master_notes', 12)
		end

		if MaxNps < 12 and tonumber(progressMasterNotes) < MaxNps then
			setAchievementScore('master_notes', MaxNps)
		end

        if actSick == 0 and actGood == 0 and actBad == 0 and actShit == 0 and actMisses == 0 then
            unlockAchievement('accuracy_legend')
        end

        if oMInsta == true or oMCrash == true then
            unlockAchievement('marvelous_chaos')
        end
    end

	return Function_Continue;
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

function startsWith(str, prefix)
    return string.sub(str, 1, #prefix) == prefix
end

function closeIfUtilNotEnabled()
    local var, debug = getVar("utilEnabled"), getVar("utilLoadDebug")

    if var == false or var == nil then
        return close()
    end

    if debug == true and debug ~= nil then
        local sName = 'UI'
        debugPrint(sName..': OK')
    end
end
