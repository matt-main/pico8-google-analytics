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