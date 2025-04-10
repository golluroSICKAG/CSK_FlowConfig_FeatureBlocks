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

local function addDataCollectorBlock(instance, source, counter, separator, trigger)

  -- Create new instance of block
  if not parameters[instance] then

    parameters[instance] = {}
    parameters[instance]['data'] = '' -- Collected data
    parameters[instance]['source'] = source -- Event of data to receive
    parameters[instance]['counter'] = 0 -- Counter of received data
    parameters[instance]['maxCounter'] = counter -- Maximum amount of data to collect
    parameters[instance]['separator'] = separator -- Separator to separate recieved data
    parameters[instance]['trigger'] = trigger or '' -- Optional event to trigger to forward collected data

    -- Create internally used function to update received values
    local function collectNewData(value)
      if parameters[instance]['data'] ~= '' then
        parameters[instance]['data'] = parameters[instance]['data'] .. parameters[instance]['separator'] .. value
      else
        parameters[instance]['data'] = value
      end
      if parameters[instance]['counter'] >= parameters[instance]['maxCounter'] then

      end
      parameters[instance]['counter'] = parameters[instance]['counter'] + 1

      if parameters[instance]['counter'] >= parameters[instance]['maxCounter'] then
        Script.notifyEvent(parameters[instance]['resultEvent'], parameters[instance]['data'])
        parameters[instance]['data'] = ''
        parameters[instance]['counter'] = 0
      end
    end
    parameters[instance]['function'] = collectNewData
    Script.register(parameters[instance]['source'], parameters[instance]['function'])

    -- Dynamically serve events to forward collected data
    parameters[instance]['resultEvent'] = 'OnNewCollectedData_' .. tostring(instance)
    local isServed = Script.isServedAsEvent("CSK_FlowConfigFeatureBlocks." .. parameters[instance]['resultEvent'])
    if not isServed then
      Script.serveEvent("CSK_FlowConfigFeatureBlocks." .. parameters[instance]['resultEvent'], parameters[instance]['resultEvent'], 'string')
    end

    -- Register to trigger event
    if parameters[instance]['trigger'] ~= '' then
      local function notifyCollectedData()
        Script.notifyEvent(parameters[instance]['resultEvent'], parameters[instance]['data'])
        parameters[instance]['data'] = ''
        parameters[instance]['counter'] = 0
      end
      parameters[instance]['notifyFunction'] = notifyCollectedData
      local suc = Script.register(parameters[instance]['trigger'], parameters[instance]['notifyFunction'])
    end
  end
end
Script.serveFunction('CSK_FlowConfigFeatureBlocks.addDataCollectorBlock', addDataCollectorBlock)

--- Function to reset all old timers and data
local function reset()
  -- Deregister from all previous events
  for instanceNo, _ in pairs(parameters) do
    if parameters[instanceNo]['source'] then
      Script.deregister(parameters[instanceNo]['source'], parameters[instanceNo]['function'])
    end

    -- Deregister from previous triger event
    if parameters[instanceNo]['trigger'] ~= '' and parameters[instanceNo]['notifyFunction'] then
      Script.deregister(parameters[instanceNo]['trigger'], parameters[instanceNo]['notifyFunction'])
    end

    -- Clear old values
    parameters[instanceNo]['data'] = ''
  end
  parameters = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', reset)
