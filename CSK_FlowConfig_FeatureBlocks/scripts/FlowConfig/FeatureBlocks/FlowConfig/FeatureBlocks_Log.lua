-- Block namespace
local BLOCK_NAMESPACE = 'FeatureBlocks_FC.Log'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function log(handle, source1)

  local instance = Container.get(handle, 'Instance')
  local level = Container.get(handle, 'Level')
  CSK_FlowConfigFeatureBlocks.addLogBlock(instance, level, source1)

end
Script.serveFunction(BLOCK_NAMESPACE .. '.log', log)

--*************************************************************
--*************************************************************

local function create(level)

  local instanceNo = #instanceTable + 1

  local handle = Container.create()
  instanceTable[instanceNo] = instanceNo
  Container.add(handle, 'Instance', tostring(instanceNo))
  Container.add(handle, 'Level', level or '')

  return handle
end
Script.serveFunction(BLOCK_NAMESPACE .. '.create', create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)
