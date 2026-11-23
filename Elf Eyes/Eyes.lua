
--MADE BY LunnaTheElf / Luna

--Change these to your specific eye configurations
  --REQUIRED!!!!
  local HEAD = models.model.root.Head
  local LEYE = models.model.root.Head.Eyes.LEye
  local REYE = models.model.root.Head.Eyes.REye
  local EYELID = models.model.root.Head.Eyes.EyeLid
  -- In the vec the numbers correspond to (Left, Right, Up, Down) (In blockbench units)
  local LPos = vec(-1.2, 0.35, 0.35, -0.35)
  local RPos = vec(-0.35, 1.2, 0.35, -0.35)
  local BlinkPos = 2 --how far down blinking can go (in blockbench units)
  local FearEyeShrink = 0.8 --how small the eye should be when in fear
  local BouncyEye = true --makes the eyes behave like jello when you blink (this includes fear eye shrink)
  local Fear = true --whenever you are on low hp you blink less and eyes move alot
  local Blink = true --toggles whether you blink
  local BouncyHead = true --makes the head behave like jello when u blink (simmilar to BouncyEye)
  --Advanced (DONT EDIT UNLESS YOU KNOW WHAT YOUR DOING)
  local BLINKTIME = 2 --(in ticks)For how long to hold the blink
  local BLINKDELAYMAX = 120 --(in ticks)Max Blink delay (if exceeds this value you blink automaticaly)
  local BLINKDELAY = 80 --(in ticks)Minimium Blink delay (below this value you cant blink)
  local FearBlink = 1.3 --Multi on how much longer you wait when scared
  local FearRand = 0.15 --how much the eye is allowed to move when scared (in all directions)

--DO NOT TOUCH OR CHANGE THESE
  local HeadRot = vec(0, 0, 0)
  local UP = 0
  local DOWN = 0
  local LEFT = 0
  local RIGHT = 0
  local BLINK = 0
  local FEAR = 0
  local HP = 0
  local MHP = 0
  local TRAND = 0
  local TBLINK = 0
  local BLINKT = 0
  local LEYEPOS = vec(0, 0, 0)
  local REYEPOS = vec(0, 0, 0)
  local LEYESIZE = vec(0, 0, 0)
  local REYESIZE = vec(0, 0, 0)
  local EYELIDPOS = vec(0, 0, 0)
  local BLINKPOWER = 0
  local HEADSIZE = vec(0, 0, 0)
  local NEWLPOS = vec(0, 0)
  local NEWRPOS = vec(0, 0)
  local FEARRANDOMx = 0
  local FEARRANDOMy = 0
  local FF = 0
  local T = 0
  local Boing = 0
  local VEL = 0

function events.tick()
  T = T+0.05
  --Get Vanilla Head Rotation
 HeadRot = vanilla_model.HEAD:getOriginRot()
  --print(HeadRot)
  if HeadRot[1] > 15 then --UP
    UP = 1
    DOWN = 0
  elseif HeadRot[1] < -15 then --DOWN
    UP = 0
    DOWN = 1
  else --MIDDLE
    UP = 0
    DOWN = 0
  end
  if HeadRot[2] > 10 then --LEFT
    LEFT = 1
    RIGHT = 0
  elseif HeadRot[2] < -10 then --RIGHT
    LEFT = 0
    RIGHT = 1
  else -- MIDDLE
    LEFT = 0
    RIGHT = 0
  end
 HP = player:getHealth()
 MHP = player:getMaxHealth()
  if Fear == true then
    if HP/MHP < 0.35 then
      FEAR = 1
    else
      FEAR = 0
    end
  end
  if Blink == true and FEAR == 0 then
   TRAND = math.random(BLINKDELAY, BLINKDELAYMAX)
    if TBLINK == TRAND or TBLINK > BLINKDELAYMAX then
      BLINK = 1
      BLINKT = BLINKTIME
      TBLINK = 0
    else
      if BLINKT == 0 then
        BLINK = 0
      end
      BLINKT = math.max(BLINKT-1, 0)
      TBLINK = TBLINK + 1
    end
  elseif Blink == true and FEAR == 1 then
   TRAND = math.random(FearBlink*BLINKDELAY, FearBlink*BLINKDELAYMAX)
    if TBLINK == TRAND or TBLINK > BLINKDELAYMAX then
      BLINK = 1
      BLINKT = BLINKTIME/FearBlink
      TBLINK = 0
    else
      if BLINKT == 0 then
        BLINK = 0
      end
      BLINKT = math.max(BLINKT-1, 0)
      TBLINK = TBLINK + 1
    end
  end
 LEYEPOS = LEYE:getPos()
 REYEPOS = REYE:getPos()
 LEYESIZE = LEYE:getScale()
 REYESIZE = REYE:getScale()
 EYELIDPOS = EYELID:getPos()
 HEADSIZE = HEAD:getScale()
  if FEAR == 1 then
   FF = FEAR*FearEyeShrink
  else
   FF = 1
  end
 BLINKPOWER = math.max(BLINK*BlinkPos^0.3, 1)
 FEARRANDOMx = FEAR*(math.random(-FearRand*100, FearRand*100)/100)
 FEARRANDOMy = FEAR*(math.random(-FearRand*100, FearRand*100)/100)
 NEWLPOS = vec(((LPos[1]*LEFT+LPos[2]*RIGHT)*math.abs(HeadRot[2]/50))+FEARRANDOMx, ((LPos[3]*UP+LPos[4]*DOWN)*math.abs(HeadRot[1]/90))+FEARRANDOMy)
 NEWRPOS = vec(((RPos[1]*LEFT+RPos[2]*RIGHT)*math.abs(HeadRot[2]/50))+FEARRANDOMx, ((RPos[3]*UP+RPos[4]*DOWN)*math.abs(HeadRot[1]/90))+FEARRANDOMy)
 VEL = math.floor((-(VEL+BLINK/1.1)/1.6)*1000)/1000
 Boing = 1+VEL
end

function events.render(delta, context)
  LEYE:setPos(math.lerp(LEYEPOS[1], NEWLPOS[1], delta), math.lerp(LEYEPOS[2], NEWLPOS[2], delta), 0)
  REYE:setPos(math.lerp(REYEPOS[1], NEWRPOS[1], delta), math.lerp(REYEPOS[2], NEWRPOS[2], delta), 0)
  EYELID:setPos(0, math.lerp(EYELIDPOS[2], -BLINK*BlinkPos, delta), 0)
  if BouncyHead == true then
    HEAD:setScale(math.lerp(HEADSIZE[1], BLINKPOWER, delta), math.lerp(HEADSIZE[2], 1/BLINKPOWER, delta), math.lerp(HEADSIZE[3], BLINKPOWER, delta))
  end
  if BouncyEye == true then
    LEYE:setScale(math.lerp(REYESIZE[1], (Boing*FF)^-1, delta), math.lerp(REYESIZE[2], Boing*FF, delta), 1)
    REYE:setScale(math.lerp(REYESIZE[1], (Boing*FF)^-1, delta), math.lerp(REYESIZE[2], Boing*FF, delta), 1)
  end
end
