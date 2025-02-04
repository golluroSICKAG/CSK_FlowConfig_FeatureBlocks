-- Block namespace
local BLOCK_NAMESPACE = 'FeatureBlocks_FC.JSON'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function json(handle, trigger, sourceA, sourceB, sourceC, sourceD)

  local instance = Container.get(handle, 'Instance')

  local key1 = Container.get(handle, 'Key1')
  local key2 = Container.get(handle, 'Key2')
  local key3 = Container.get(handle, 'Key3')
  local key4 = Container.get(handle, 'Key4')

  CSK_FlowConfigFeatureBlocks.addJSONBlock(instance, {key1, key2, key3, key4}, {sourceA or '', sourceB or '', sourceC or '', sourceD or ''}, trigger or '')

  return 'CSK_FlowConfigFeatureBlocks.OnNewJSON_' .. tostring(instance)
end
Script.serveFunction(BLOCK_NAMESPACE .. '.json', json)

--*************************************************************
--*************************************************************

local function create(key1, key2, key3, key4)

  local instanceNo = #instanceTable + 1

  local handle = Container.create()
  instanceTable[instanceNo] = instanceNo
  Container.add(handle, 'Instance', tostring(instanceNo))
  Container.add(handle, 'Key1', key1 or '')
  Container.add(handle, 'Key2', key2 or '')
  Container.add(handle, 'Key3', key3 or '')
  Container.add(handle, 'Key4', key4 or '')

  return handle
end
Script.serveFunction(BLOCK_NAMESPACE .. '.create', create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)
