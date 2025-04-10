--MIT License
--
--Copyright (c) 2025 SICK AG
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.

---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************
-- If app property "LuaLoadAllEngineAPI" is FALSE, use this to load and check for required APIs
-- This can improve performance of garbage collection
_G.availableAPIs = require('FlowConfig/FeatureBlocks/helper/checkAPIs')
-----------------------------------------------------------

-- Logger
_G.logger = Log.SharedLogger.create('ModuleLogger')
_G.logHandle = Log.Handler.create()
_G.logHandle:attachToSharedLogger('ModuleLogger')
_G.logHandle:setConsoleSinkEnabled(false) --> Set to TRUE if CSK_Logger module is not used
_G.logHandle:setLevel("ALL")
_G.logHandle:applyConfig()
-----------------------------------------------------------

-- Only to prevent WARNING messages, but these are only examples/placeholders for dynamically created events/functions
----------------------------------------------------------------
Script.serveEvent("CSK_FlowConfigFeatureBlocks.OnNewJSON_ID", "FeatureBlocks_OnNewJSON_ID")
Script.serveEvent("CSK_FlowConfigFeatureBlocks.OnNewCollectedData_ID", "FeatureBlocks_OnNewCollectedData_ID")
----------------------------------------------------------------

-- Read in code to provide FlowConfig blocks
----------------------------------------------------------------
require('FlowConfig/FeatureBlocks/FlowConfig/FeatureBlocks_JSON')
require('FlowConfig/FeatureBlocks/FlowConfig/FeatureBlocks_CollectData')
require('FlowConfig/FeatureBlocks/FlowConfig/FeatureBlocks_Log')
-- ...
----------------------------------------------------------------

-- Load script for JSON block
----------------------------------------------------------------
Script.startScript('CSK_FlowConfig_FeatureBlocks_JSON')
Script.startScript('CSK_FlowConfig_FeatureBlocks_CollectData')
Script.startScript('CSK_FlowConfig_FeatureBlocks_Log')
-- ...
----------------------------------------------------------------

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************