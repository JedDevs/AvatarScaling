# AvatarScaling
Ease Of Use Avatar Scaling

Prototype Based Class System for avatar scaling, supports*: 
*"DepthScale", "HeightScale", "ProportionScale", "BodyTypeScale", "WidthScale", "HeadScale"*

## Example

```lua
local HumanoidDescriptionModule = require(game:GetService("ReplicatedStorage").HumanoidDescription)
local success, humanoidDescription = HumanoidDescriptionModule.new(plr, "All", 0.5)
if not success then return warn(humanoidDescription) end

humanoidDescription:ApplyDescription()
wait(5)
humanoidDescription:RevertDescription()

```
*Can be easily modified to support more - just modify: MODIFIABLE_DESCRIPTIONS
