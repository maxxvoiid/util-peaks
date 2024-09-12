--[[ Hey neds 🤓☝️

Well, as the name says, this script handles the Play As Opponent
This script works as it should, don't touch anything if you don't know what you are doing :)
    ~ MaxxVoiid

]]





-----------------------------------------------------------------------
    --- DON'T EDIT ANYTHING IF YOU DON'T KNOW WHAT YOU'RE DOING ---
-----------------------------------------------------------------------

local enabled = getModSetting('opponentplay')

if enabled == true then
function rgbToHex(r,g,b)
    local rgb = (r * 0x10000) + (g * 0x100) + b
    return string.format("%x", rgb)
end

coolIcon = 'face'
meanIcon = 'face'

singTable = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}

function hitNote(isDad, id, dir, noteType, miss)
gfNote = false
if getPropertyFromGroup('notes', id, 'gfNote') == true then
gfNote = true
end

suffix = getPropertyFromGroup('notes', id, 'animSuffix')

shouldMissAnimation = true
shouldAnimation = true

if suffix == 'therenoanimation' then
	shouldAnimation = false
end

if suffix == 'therenomissanimation' then
	shouldMissAnimation = false
end

if suffix == 'therenoanimationormiss' then
	shouldAnimation = false
	shouldMissAnimation = false
end

customAnimation = ''

if noteType == 'GF Sing' then
	gfNote = true
end
if noteType == '' then
	gfNote = false
end
if noteType == 'No Animation' then
	shouldAnimation = false
	shouldMissAnimation = false
end
if noteType == 'Alt Animation' then
	suffix = '-alt'
end
if noteType == 'Hurt Note' then
	shouldMissAnimation = false
	if miss == true then
		customAnimation = 'Hurt'
	end
end
if noteType == 'Hey!' then
	shouldAnimation = false
	shouldMissAnimation = false
	customAnimation = 'Hey'
end

singer = 'dad'

if isDad == false then
	singer = 'boyfriend'
end

if gfNote == true then
	singer = 'gf'
end

if shouldMissAnimation == true then
if miss == true then
	if getProperty(singer .. '.hasMissAnimations') == true then
		suffix = 'miss'		
		shouldAnimation = false
	end
end
end

if shouldAnimation == true then
triggerEvent('Play Animation', singTable[dir + 1] .. suffix, singer)
end

if customAnimation ~= '' then
	triggerEvent('Play Animation', customAnimation, singer)
end

end

function goodNoteHit(id, dir, noteType, isSus)
	hitNote(true, id, dir, noteType, false)
	--callOnLuas('opponentNoteHit', {id, dir, noteType, isSus}, false, true)
end

function opponentNoteHit(id, dir, noteType, isSus)
	hitNote(false, id, dir, noteType, false)
	--callOnLuas('goodNoteHit', {id, dir, noteType, isSus}, false, true)
end

function noteMiss(id, dir, noteType, isSus)
	hitNote(true, id, dir, noteType, true)
end

function onCreatePost()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == true then
			setPropertyFromGroup('unspawnNotes', i, 'mustPress', false)
		else
			setPropertyFromGroup('unspawnNotes', i, 'mustPress', true)
		end
		if getPropertyFromGroup('unspawnNotes', i, 'noAnimation') == true and getPropertyFromGroup('unspawnNotes', i, 'noMissAnimation') == false then
setPropertyFromGroup('unspawnNotes', i, 'animSuffix', 'therenoanimation')
		end
		if getPropertyFromGroup('unspawnNotes', i, 'noAnimation') == false and getPropertyFromGroup('unspawnNotes', i, 'noMissAnimation') == true then
setPropertyFromGroup('unspawnNotes', i, 'animSuffix', 'therenomissanimation')
		end
		if getPropertyFromGroup('unspawnNotes', i, 'noAnimation') == true and getPropertyFromGroup('unspawnNotes', i, 'noMissAnimation') == true then
setPropertyFromGroup('unspawnNotes', i, 'animSuffix', 'therenoanimationormiss')
		end
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
			setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true)
	end

	meanIcon = getProperty('dad.healthIcon')
	coolIcon = getProperty('boyfriend.healthIcon')

	if not middlescroll then

	noteTweenX('bfTween1', 4, 90, 0.01, 'linear');
	 noteTweenX('bfTween2', 5, 205, 0.01, 'linear');
 	noteTweenX('bfTween3', 6, 315, 0.01, 'linear');
	 noteTweenX('bfTween4', 7, 425, 0.01, 'linear');
	 noteTweenX('dadTween1', 0, 730, 0.01, 'linear');
	 noteTweenX('dadTween2', 1, 845, 0.01, 'linear');
	 noteTweenX('dadTween3', 2, 955, 0.01, 'linear');
	 noteTweenX('dadTween4', 3, 1065, 0.01, 'linear');

	end
end

function onUpdate()
setHealthBarColors(rgbToHex(getProperty('boyfriend.healthColorArray')[1], getProperty('boyfriend.healthColorArray')[2], getProperty('boyfriend.healthColorArray')[3]), rgbToHex(getProperty('dad.healthColorArray')[1], getProperty('dad.healthColorArray')[2], getProperty('dad.healthColorArray')[3]))

	setProperty('boyfriend.isPlayer', false)
	setProperty('gf.isPlayer', false)
	setProperty('dad.isPlayer', true)
end

function onUpdatePost()
	setHealthBarColors(rgbToHex(getProperty('boyfriend.healthColorArray')[1], getProperty('boyfriend.healthColorArray')[2], getProperty('boyfriend.healthColorArray')[3]), rgbToHex(getProperty('dad.healthColorArray')[1], getProperty('dad.healthColorArray')[2], getProperty('dad.healthColorArray')[3]))

	local health = getProperty('health')
	local baseX = getProperty('healthBar.x')
	local baseXScale = getProperty('healthBar.scale.x') / 2
	if health >= 2 then
		health = 2
	elseif health <= 0.001 then
		health = 0.001
	end
	local moveAlong = health * 225
	
	setProperty('iconP1.x', baseX + baseXScale + 60 + moveAlong)
	setProperty('iconP2.x', baseX+ baseXScale - 60 + moveAlong)

if health >= 2 then

setProperty('iconP1.animation.curAnim.curFrame',0)

setProperty('iconP2.animation.curAnim.curFrame', 0)

elseif health <= 0.37599 then

setProperty('iconP1.animation.curAnim.curFrame', 0)

setProperty('iconP2.animation.curAnim.curFrame', 1)

elseif health >= 1.55 then

setProperty('iconP1.animation.curAnim.curFrame', 1)

setProperty('iconP2.animation.curAnim.curFrame', 0)

end

	setProperty('healthBar.flipX', true)
end
end
