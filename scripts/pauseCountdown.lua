--[[ Hey neds 🤓☝️

Well, as the name says, this script handles the Resume Countdown
This script works as it should, don't touch anything if you don't know what you are doing :)
    ~ MaxxVoiid

]]





-----------------------------------------------------------------------
    --- DON'T EDIT ANYTHING IF YOU DON'T KNOW WHAT YOU'RE DOING ---
-----------------------------------------------------------------------

local resumeCountEnabled = getModSetting('resumecountenabled')

function onCreatePost()
   closeIfUtilNotEnabled()
end

if resumeCountEnabled then
   local isON = false;

   function repeatDashes(num)
      local dashes = string.rep("-", num)
      return dashes.. " "..num.. " "..dashes
  end

   function onResume()
      if not isON and curStep > 0 then
         time = 3;
         playSound('metronome')
         openCustomSubstate('countdownOnResume', true);
      end
      isON = false;
  end
  
  function onCustomSubstateCreatePost(name)
      if name == 'countdownOnResume' then
         if not isON then
            makeLuaText('countdownTxt', repeatDashes(time), 0, 0, 0);
            setTextSize('countdownTxt', 60);
            setTextBorder('countdownTxt', 3, '000000')
            screenCenter('countdownTxt', 'xy');
            setObjectCamera("countdownTxt", "other")
            addLuaText('countdownTxt', true);
  
            runTimer('pauseCountdown', 0.5);
         end
      end
  end
  
  function onCustomSubstateUpdate(name, elapsed)
      if name == 'countdownOnResume' then
         if time <= 0 then
            cancelTimer('pauseCountdown');
            removeLuaText('countdownTxt');
            isON = true;
            closeCustomSubstate();
         end
      end
  end
  
  function onTimerCompleted(tag)
      if tag == 'pauseCountdown' then
         time = time - 1;
  
         if time > 0 then
           playSound('metronome');
         end
  
         setTextString('countdownTxt', repeatDashes(time));
         screenCenter('countdownTxt', 'xy');
         runTimer('pauseCountdown', 0.5);
      end
  end
end

function closeIfUtilNotEnabled()
   local var, debug = getVar("utilEnabled"), getVar("utilLoadDebug")

   if var == false or var == nil then
      return close()
   end

   if debug == true and debug ~= nil then
      local sName = 'PC'
      debugPrint(sName..': OK')
   end
end
