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

local function addLogBlock(instance, level, event)

  parameters[instance] = {}
  local function logContent(value)
    if level == 'FINE' then
      _G.logger:fine(tostring(value))
    elseif level == 'INFO' then
      _G.logger:info(tostring(value))
    elseif level == 'SEVERE' then
      _G.logger:severe(tostring(value))
    else
      _G.logger:warning(tostring(value))
    end
  end
  parameters[instance]['notifyFunction'] = logContent
  parameters[instance]['sourceEvent'] = event
  Script.register(parameters[instance]['sourceEvent'], parameters[instance]['notifyFunction'])

end
Script.serveFunction('CSK_FlowConfigFeatureBlocks.addLogBlock', addLogBlock)

--- Function to reset all old timers and data
local function reset()
  -- Deregister from all previous events

  for instanceNo, _ in pairs(parameters) do
    if parameters[instanceNo]['sourceEvent'] then
      Script.deregister(parameters[instanceNo]['sourceEvent'], parameters[instanceNo]['notifyFunction'])
    end
  end
  parameters = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', reset)
