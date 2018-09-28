pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--pico-8 google analytics
--example cart

--[[

api:
event(category,action,label?,value?)

examples:
event('got item','pick-axe')
event('level 12','clear','found treasure')
event('level 1','win','perfect',64)

]]--

function _init()
 t=0 --timer
 cls()
 print("hi there ♥\n")
 print("event #1 firing in 1 sec...")
end

function _update()
 t+=1
 
 --fire event #1
 if(t==30)then
  ---
  event("got item","pick-axe")
  ---
  color(9)
  print("event('got item','pick-axe')")
  color(6)
  print("event #1 fired.\n")
 end

 if(t==60)print("event #2 firing in 1 more sec...")

 --fire event #2
 if(t==90)then
  ---
  event('level 12','clear','found treasure')
  ---
  color(9)
  print("event('level 12','clear',\n'found treasure')")
  color(6)
  print("event #2 fired.\n")
  print("end of example cart.")
 end
end
-->8
--(pasted from event.lua file)

--pico-8 google analytics
--by matthias
--special thanks to nucleartide

do
  -- generate character map
  local chars = ' !"#%\'()*+,-./0123456789:;<=>?abcdefghijklmnopqrstuvwxyz[]^_{~}'
  local charset = {}
  for i=1,#chars do
    charset[sub(chars,i,i)] = i
  end

  --gpio memory address
  local start  = 0x5f80
  local offset = 0

  --restrict to 128 bytes
  local function check()
    if start+offset > 0x5fff then assert(false, 'event is too large.') end
  end

  --data write functions
  local function write_char(ch)
    check()
    poke(start+offset, charset[ch])
    offset += 1
  end

  local function write_uint8(n)
    check()
    poke(start+offset, n)
    offset += 1
  end

  local function write_end()
    check()
    poke(start+offset, 255)
    offset = 0
  end

  local function write_str(s)
    write_uint8(#s)
    for i=1,#s do write_char(sub(s,i,i)) end
  end
  
  --event tracking function
  function event(category,action,label,value)
   label=label or ""
   value=tostr(value) or ""
   write_str(category)
   write_str(action)
   write_str(label)
   write_str(value)
   write_end()
  end
end

--[[

api:
event(category,action,label?,value?)

examples:
event('got item','pick-axe')
event('level 12','clear','found treasure')
event('level 1','win','perfect',64)

]]--
