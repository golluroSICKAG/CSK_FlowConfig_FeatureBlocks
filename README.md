# CSK_FlowConfig_FeatureBlocks

SensorApp to provide specific features as blocks to be used within the CSK FlowConfig feature.  
The focus here is on features that receive data content, process the data and forward the results via events.  
Features within this SensorApp do not provide a UI itself. But they can be configured via the CSK_Module_FlowConfig UI and their setup can be saved within the persistent data of the CSK_Module_FlowConfig as well.  
This makes it possible to focus on the block features and to keep the code to a minimum as most CSK relevant code is not needed in this SensorApp.  

## How to Run

Run this SensorApp beside of the CSK_Module_FlowConfig. The provided features will show up as blocks within the UI.  
For further information check out the [documentation](https://raw.githack.com/SICKAppSpaceCodingStarterKit/CSK_FlowConfig_FeatureBlocks/main/docu/CSK_FlowConfig_FeatureBlocks.html) in the folder "docu".

## Information

Tested on:
|Device|Firmware|Module version
|--|--|--|
|SIM1012|V2.4.2|V1.1.0|
|SIM1012|V2.4.2|V1.0.0|
|SICK AppEngine|V1.7.0|V1.1.0|
|SICK AppEngine|V1.7.0|V1.0.0|

This SensorApp is part of the SICK AppSpace Coding Starter Kit developing approach.  
Please check the [documentation](https://github.com/SICKAppSpaceCodingStarterKit/.github/blob/main/docu/SICKAppSpaceCodingStarterKit_Documentation.md) of CSK for further information.  

## Topics

Coding Starter Kit, CSK, Module, SICK-AppSpace, FlowConfig, Blocks
