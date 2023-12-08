if not game:IsLoaded() then
	game.Loaded:Wait()
end

local startTime = os.clock()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Import = require(ReplicatedStorage.Packages.Import)
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.LocalPlayer = game:GetService("Players").LocalPlayer
Knit.PlayerGui = Knit.LocalPlayer:WaitForChild("PlayerGui")

-- EXPOSE ASSETS FOLDERS
Knit.Assets = ReplicatedStorage.Assets

-- EXPOSE CLIENT MODULES
Knit.Modules = script:WaitForChild("Modules")

local Interface: ModuleScript = script:WaitForChild("Interface")

--EXPOSE SHARED MODULES
Knit.SharedModules = game.ReplicatedStorage.Shared.Modules
Knit.Helpers = Knit.SharedModules.Helpers
Knit.GameData = Knit.SharedModules.Data
Knit.Packages = ReplicatedStorage.Packages

-- IMPORT ALIASES
Import.setAliases({
	Packages = ReplicatedStorage.Packages,
	Shared = ReplicatedStorage.Shared,
	Assets = ReplicatedStorage.Assets,
	Modules = script.Modules,
	Interface = Interface,
})

-- ENVIRONMENT SWITCHES
Knit.IsStudio = game:GetService("RunService"):IsStudio()
Knit.IsClient = game:GetService("RunService"):IsClient()
Knit.IsServer = game:GetService("RunService"):IsServer()

-- ADD CONTROLLERS
local Controllers = script:WaitForChild("Controllers")
Knit.AddControllersDeep(Controllers)

-- ADD COMPONENTS
local Components = script:WaitForChild("Components")
for _, v in Components:GetDescendants() do
	if v:IsA("ModuleScript") then
		require(v)
	end
end

-- LOCAL STATE
Knit.Store = require(script:FindFirstChild("Store"))

-- INTERFACE
require(Interface)

-- START
Knit:Start()
	:andThen(function()
		print(string.format("Client Successfully Compiled! [%s ms]", math.round((os.clock() - startTime) / 1000)))
	end)
	:catch(error)

return true
