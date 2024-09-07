local resumeCountEnabled = getModSetting('resumecountenabled')

if resumeCountEnabled then
   local isON = false;

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
             makeLuaText('countdownTxt', time, 0, 0, 0);
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
   
          setTextString('countdownTxt', time);
          runTimer('pauseCountdown', 0.5);
       end
   end
end
