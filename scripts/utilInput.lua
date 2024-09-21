--[[ Hey neds 🤓☝️

This script handles all these functions:
- Only Marvelous Type: Instakill
- Achievement: Marvelous Chaos!


This script works as it should, don't touch anything if you don't know what you are doing :)
    ~ MaxxVoiid

]]





-----------------------------------------------------------------------
    --- DON'T EDIT ANYTHING IF YOU DON'T KNOW WHAT YOU'RE DOING ---
-----------------------------------------------------------------------

local marvelousRatingEnabled = getModSetting('marvelousenabled')
local marvelousRatingMs = getModSetting('marvelousms')

local onlyMarvelousEnabled = getModSetting('onlymarvelous')
local onlyMarvelousType = getModSetting('onlymarveloustype')

local showReasonGO = getModSetting('showreasongo')

local usedCheats = false
local cheerGfCombo = true -- makes gf celebrate if you reach 50 combo
local cryGfCombo = true -- makes gf cry if you have lost a combo greater than 10
local actCombo = 0

local trueHealthLossSus = 0
local trueHealthLossNor = 0

function onCreatePost()
    closeIfUtilNotEnabled()

    opponentName = getProperty('dad.curCharacter')

    trueHealthLossNor = 0.3*healthLossMult
    trueHealthLossSus = 0.1*healthLossMult

    if marvelousRatingEnabled and onlyMarvelousEnabled and onlyMarvelousType == 'Instakill' then
        onlyMarvelousType = true
    else
        onlyMarvelousType = false
    end
end

function getRatingMS(diff)
    diff = math.abs(diff)

    local windowSick = getProperty('ratingsData[0].hitWindow')
    local windowGood = getProperty('ratingsData[1].hitWindow')
    local windowBad = getProperty('ratingsData[2].hitWindow')

    if marvelousRatingEnabled and diff <= marvelousRatingMs then
        return { marvelous = true, ms = math.floor(diff), rating = 'Marvelous' }
    end

    if diff <= windowSick then
        return { marvelous = false, ms = math.floor(diff), rating = 'Sick!' }
    end

    if diff <= windowGood then
        return { marvelous = false, ms = math.floor(diff), rating = 'Good' }
    end

    if diff <= windowBad then
        return { marvelous = false, ms = math.floor(diff), rating = 'Bad' }
    end

    return { marvelous = false, ms = math.floor(diff), rating = 'Shit' }
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if (not isSustainNote) then
        local strumTime = getPropertyFromGroup('notes', id, 'strumTime')
        isEarly = strumTime < getSongPosition() and '' or '-'

        local ratingData = getRatingMS((strumTime - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset')) / playbackRate)

        actCombo = actCombo + 1

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

        if marvelous == false and onlyMarvelousType == true then
            setVar("utilGOReason", 'Died to a '..rating..' ('..ms..'ms)')

            setHealth(-1)
        end
    end
end

function noteMissPress(direction)
    if actCombo >= 10 and cryGfCombo then
        if startsWith(opponentName, "gf") then
            triggerEvent('Play Animation', 'sad', 'dad')
        else
            triggerEvent('Play Animation', 'sad', 'gf')
        end
    end

    actCombo = 0

    if onlyMarvelousType ~= true then return end

    setVar("utilGOReason", 'Died to a missed note')
    setHealth(-1)
end

function noteMiss(id, direction, noteType, isSustainNote)
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

    if onlyMarvelousType ~= true then return end

    setVar("utilGOReason", 'Died to a missed note')
    setHealth(-1)
end

function onUpdatePost(elapsed)
    local practice = getProperty('practiceMode')

    if botPlay or practice then
        if usedCheats ~= true then
            usedCheats = true
        end
    end

    if keyJustPressed('reset') then
        setVar("utilGOReason", 'Reset button pressed')
    end
end

function onEndSong()
    if usedCheats == false and onlyMarvelousType == true then
        unlockAchievement('marvelous_chaos')
    end

	return Function_Continue;
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