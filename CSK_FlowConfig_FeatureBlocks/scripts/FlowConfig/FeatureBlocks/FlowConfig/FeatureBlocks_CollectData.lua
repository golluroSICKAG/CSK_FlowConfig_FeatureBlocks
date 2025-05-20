-- Block namespace
local BLOCK_NAMESPACE = 'FeatureBlocks_FC.CollectData'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function collectData(handle, trigger, source)

  local instance = Container.get(handle, 'Instance')

  local counter = Container.get(handle, 'Counter')
  local separator = Container.get(handle, 'Separator')

  CSK_FlowConfigFeatureBlocks.addDataCollectorBlock(instance, source, counter, separator, trigger or '')

  return 'CSK_FlowConfigFeatureBlocks.OnNewCollectedData_' .. tostring(instance)
end
Script.serveFunction(BLOCK_NAMESPACE .. '.collectData', collectData)

--*************************************************************
--*************************************************************

local function create(counter, separator)

  local instanceNo = #instanceTable + 1

  local handle = Container.create()
  instanceTable[instanceNo] = instanceNo
  Container.add(handle, 'Instance', tostring(instanceNo))
  Container.add(handle, 'Counter', counter)
  Container.add(handle, 'Separator', separator)

  return handle
end
Script.serveFunction(BLOCK_NAMESPACE .. '.create', create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)
