local enable_logging = false
local enable_logging_ai = false
local enable_logging_debug = false

local function SRWLOGCORE(text)
  local logText = tostring(text)
  local popLog = io.open("supply_rework_log.txt","a")
  popLog :write("SRW: "..logText .. "  \n")
  popLog :flush()
  popLog :close()
end

local function SRWLOG(text)
  if not enable_logging then
    return;
  end
  SRWLOGCORE(text)
end

local function SRWLOGAI(text)
  if not enable_logging_ai then
    return;
  end
  SRWLOGCORE(text)
end

local function SRWLOGDEBUG(text)
  if not enable_logging_debug then
    return;
  end
  SRWLOGCORE(text)
end

local function SRWNEWLOG()
  local logTimeStamp = os.date("%d, %m %Y %X")

  local popLog = io.open("supply_rework_log.txt","w+")
  popLog :write("NEW LOG ["..logTimeStamp.."] \n")
  popLog :flush()
  popLog :close() 
end
SRWNEWLOG()

