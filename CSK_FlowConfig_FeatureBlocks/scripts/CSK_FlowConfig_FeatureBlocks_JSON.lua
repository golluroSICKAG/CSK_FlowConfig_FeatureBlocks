---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

--*****************************************************************
-- Here you will find all the required content to provide a block
-- within the FlowConfig feature to:
-- * create JSON content out of received data.
--*****************************************************************

-- If App property "LuaLoadAllEngineAPI" is FALSE, use this to load and check for required APIs
-- This can improve performance of garbage collection
_G.availableAPIs = require('FlowConfig/FeatureBlocks/helper/checkAPIs')
-----------------------------------------------------------
-- Logger
_G.logger = Log.SharedLogger.create('ModuleLogger')

local parameters = {}

--- Function to create JSON content
---@param instance string Instance identifier to create JSON content
local function createJSON(instance)
  local firstEntry = true
  local fullString = '{'

  for key, value in ipairs(parameters[instance]['keys']) do
    if value ~= '' then
      if firstEntry == false then
        fullString = fullString .. ', '
      else
        firstEntry = false
      end
      fullString = fullString .. '"' .. tostring(value) .. '": '
      if parameters[instance]['values'][key] ~= '' then
        fullString = fullString .. tostring(parameters[instance]['values'][key])
      end
    end
  end
  fullString = fullString .. '}'
  Script.notifyEvent(parameters[instance]['resultEvent'], fullString)

  --print(fullString)
end

local function addJSONBlock(instance, data, events, trigger)

  -- Create new instance of block
  if not parameters[instance] then

    parameters[instance] = {}
    parameters[instance]['keys'] = {} -- Keys for received data
    parameters[instance]['values'] = {} -- Table to store data
    parameters[instance]['sourceEvents'] = {} -- Events to receive data
    parameters[instance]['trigger'] = trigger or ''

    local setFunctions = {}

    for key, _ in ipairs(data) do

      -- Create default parameters
      parameters[instance]['keys'][key] = data[key]
      parameters[instance]['sourceEvents'][key] = events[key]
      parameters[instance]['values'][key] = ''

      -- Create internally used function to update received values
      local function setParameter(value)
        parameters[instance]['values'][tonumber(key)] = value
        if parameters[instance]['trigger'] == '' then
          createJSON(instance)
        end
      end
      table.insert(setFunctions, setParameter)
    end
    parameters[instance].setFunctions = setFunctions

    -- Dynamically serve events to forward JSON content
    parameters[instance]['resultEvent'] = 'OnNewJSON_' .. tostring(instance)
    local isServed = Script.isServedAsEvent("CSK_FlowConfigFeatureBlocks." .. parameters[instance]['resultEvent'])
    if not isServed then
      Script.serveEvent("CSK_FlowConfigFeatureBlocks." .. parameters[instance]['resultEvent'], parameters[instance]['resultEvent'], 'string')
    end

    -- Register to source events to update values
    for id, eventName in ipairs(parameters[instance]['sourceEvents']) do
      if eventName ~= '' and parameters[instance]['keys'][id] ~= '' then
        Script.register(eventName, parameters[instance].setFunctions[tonumber(id)])
      end
    end

    -- Register to trigger event
    if parameters[instance]['trigger'] ~= '' then
      local function notifyJSON()
        createJSON(instance)
      end
      parameters[instance]['notifyFunction'] = notifyJSON
      Script.register(parameters[instance]['trigger'], parameters[instance]['notifyFunction'])
    end

  -- Instance already exists. Only extend event registration
  else

    -- Check if new sources needs to be added
    for key, value in ipairs(data) do
      if parameters[instance]['sourceEvents'][key] == '' and value ~= '' and events[key] ~= '' then
        parameters[instance]['sourceEvents'][key] = events[key]
        Script.register(events[key], parameters[instance].setFunctions[tonumber(key)])
      end
    end

    -- Check if trigger event needs to be set
    if trigger ~= '' and parameters[instance]['trigger'] == '' then
      parameters[instance]['trigger'] = trigger
      local function notifyJSON()
        createJSON(instance)
      end
      parameters[instance]['notifyFunction'] = notifyJSON
      Script.register(parameters[instance]['trigger'], parameters[instance]['notifyFunction'])
    end
  end
end
Script.serveFunction('CSK_FlowConfigFeatureBlocks.addJSONBlock', addJSONBlock)

--- Function to reset all old timers and data
local function reset()
  -- Deregister from all previous events
  for instanceNo, _ in pairs(parameters) do
    if parameters[instanceNo]['sourceEvents'] then
      for key, value in ipairs(parameters[instanceNo]['sourceEvents']) do
        if parameters[instanceNo].setFunctions[tonumber(key)] then
          Script.deregister(value, parameters[instanceNo].setFunctions[tonumber(key)])
        end
      end
    end

    -- Deregister from previous triger event
    if parameters[instanceNo]['trigger'] ~= '' and parameters[instanceNo]['notifyFunction'] then
      Script.deregister(parameters[instanceNo]['trigger'], parameters[instanceNo]['notifyFunction'])
    end

    -- Clear old values
    for key, _ in pairs(parameters[instanceNo]['values']) do
      parameters[instanceNo]['values'][key] = ''
    end
  end
  parameters = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', reset)
