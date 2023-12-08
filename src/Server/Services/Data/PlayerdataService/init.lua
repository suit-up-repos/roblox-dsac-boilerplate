--!strict

--[=[
@class PlayerdataService

Author: serverOptimist & ArtemisTheDeer
Date: 11/15/2023
Project: dasc-boilerplate

Description: Rewrite of serverOptimist PlayerdataService module
]=]

--GetService calls
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService: RunService = game:GetService("RunService")

--Lua types
local Types = require(ReplicatedStorage.Shared.Modules.Data.Types)
type ANY_TABLE = Types.ANY_TABLE

--Module imports (Require)
local PACKAGES: any = ReplicatedStorage.Packages
local Knit: ANY_TABLE = require(PACKAGES.Knit)
local Signal: ANY_TABLE = require(PACKAGES.Signal)
local Promise: ANY_TABLE = require(PACKAGES.Promise)
local ProfileService: ANY_TABLE = require(script.ProfileService)
local ReplicaService: ANY_TABLE

-- Imports
local Import = require(ReplicatedStorage.Packages.Import)

local t: ANY_TABLE = Import("Packages/t")
local Knit: ANY_TABLE = Import("Packages/Knit")
local Signal: ANY_TABLE = Import("Packages/Signal")
local Promise: ANY_TABLE = Import("Packages/Promise")
local ProfileService: ANY_TABLE = Import("ProfileService")
local InventoryHelper = Import("Shared/Helpers/InventoryHelper")

local PlayerdataService: ANY_TABLE = Knit.CreateService({
	Name = "PlayerdataService",
	Client = {},
	_playerdata = {},
	-- Public signals
	PlayerdataLoaded = Signal.new(),
	-- Private signals
	_playerdataLoaded = Signal.new(),
	_playerdataUnloaded = Signal.new(),
})

local DATA_TEMPLATE: ANY_TABLE = require(script.DataTemplate)
local PLAYER_TEMPLATE: ANY_TABLE = DATA_TEMPLATE.Playerdata
local KEYS_TO_IGNORE: ANY_TABLE = DATA_TEMPLATE.KEYS_TO_IGNORE

local IS_STUDIO: boolean = RunService:IsStudio()

--[=[
	@prop STORE_NAME string
	@within PlayerdataService
	The datastore to use with profileservice for storing playerdata
]=]
local STORE_NAME: string = "Playerdata"

--[=[
	@prop DATA_PREFIX string
	@within PlayerdataService
	The prefix to amend to the key used for saving playerdata (Eg. "Playerdata_123")
]=]
local DATA_PREFIX: string = "playerdata_"

--[=[
	@prop DATA_LOAD_RETRIES number
	@within PlayerdataService
	The maximum amount of times to try to load a player's data (On joining the game) before rejecting the promise associated w/it
]=]
local DATA_LOAD_RETRIES: number = 10

--[=[
	@prop DATA_LOAD_RETRY_DELAY number
	@within PlayerdataService
	How long to wait between failed attempts with loading a player's data (On joining the game) before retrying
]=]
local DATA_LOAD_RETRY_DELAY: number = 10

--[=[
	@prop LOAD_PLAYERDATA_IN_STUDIO boolean
	@within PlayerdataService
	Boolean that determines whether player save profiles should be loaded while in a Roblox studio session
	If true, playerdata will load in studio. If false, playerdata will not be loaded in studio
]=]
local LOAD_PLAYERDATA_IN_STUDIO: boolean = false
local USE_PRODUCTION_STORE: boolean = (not IS_STUDIO or LOAD_PLAYERDATA_IN_STUDIO)

--Client knit functions/methods

--[=[
	Returns a promise that resolves with a table of the player's data, and rejects if it cannot be retrieved for some reason
	If the playerdata is not loaded already, :_createPlayerdataProfile(Player: Player) will be called server-side first
	@client
	@within PlayerdataService
	@return Promise<T> -- A promise that resolves with a table of the player's data if the playerdata exists, and rejects if the playerdata does not exist
]=]
function PlayerdataService.Client:GetPlayerdata(Player: Player): ANY_TABLE
	return self.Server:GetPlayerdata(Player)
end

--Server knit functions/methods

--[=[
	Creates a new playerdata template via profileservice/replicaservice for a player
	@server
	@private
	@return Promise<T> -- A promise that resolves w/a copy of the player's data table if loaded successfully, and rejects if unable to load the player's data
]=]
function PlayerdataService:_createPlayerdataProfile(Player: Player): ANY_TABLE
	return Promise.new(function(Resolve, Reject)
		Promise.retryWithDelay(function()
			return Promise.new(function(resolveData, rejectData)
				local dataKey: string = DATA_PREFIX .. Player.UserId

				--Use the mock API under the profilestore
				local playerProfile: ANY_TABLE | nil = USE_PRODUCTION_STORE
						and self._profileStore:LoadProfileAsync(dataKey, "ForceLoad")
					or self._profileStore.Mock:LoadProfileAsync(dataKey, "ForceLoad")

				if not playerProfile then
					return rejectData(string.format("Could not load player profile %s", dataKey))
				end

				--Attach user ID to profile, reconcile data, and kick player/erase key from self._playerdata if they join another session
				playerProfile:AddUserId(Player.UserId)
				playerProfile:Reconcile()
				playerProfile:ListenToRelease(function()
					if not self._playerdata[Player] then
						return
					end

					self._playerdata[Player] = nil

					self._playerdataUnloaded:Fire(Player)

					Player:Kick("Your data was loaded on another server. Please rejoin in a few minutes.")
				end)

				--Cleanup player data when player is leaving the game
				Player.AncestryChanged:Connect(function(_: any, newParent: any)
					if not newParent then
						if self._playerdata[Player] and self._playerdata[Player]._profile then
							self._playerdata[Player]._profile:Release()
						end

						self._playerdata[Player] = nil
						self._playerdataUnloaded:Fire(Player)
					end
				end)

				self._playerdata[Player] = {
					_profile = playerProfile,
					_playerReplica = nil,
				}

				local initialReplicaData: ANY_TABLE = {}

				for Key, Value in self._playerdata[Player]._profile.Data do
					if not KEYS_TO_IGNORE[Key] then
						initialReplicaData[Key] = Value
					end
				end

				--Create new replica for playerdata
				ReplicaService:CreateReplica("Playerdata", { Player }, nil, initialReplicaData)
					:andThen(function(Replica)
						self._playerdata[Player]._playerReplica = Replica
						resolveData(playerProfile)
					end)
					:catch(Reject)
			end)
		end, DATA_LOAD_RETRIES, DATA_LOAD_RETRY_DELAY)
			:andThen(function()
				Resolve(self._playerdata[Player]._profile.Data)
			end)
			:catch(Reject)
	end):andThen(function()
		self._playerdataLoaded:Fire(Player)
		self.PlayerdataLoaded:Fire(Player)
	end)
end

--[=[
	Returns a promise that resolves with a table of the player's data, and rejects if it cannot be retrieved for some reason
	If the playerdata is not loaded already, :_createPlayerdataProfile(Player: Player) will be called first
	@server
	@return Promise<T> -- A promise that resolves with a table of the player's data if the playerdata exists, and rejects if the playerdata does not exist
]=]
function PlayerdataService:PromisePlayerdata(Player: Player): ANY_TABLE
	return Promise.new(function(Resolve, Reject)
		if self._playerdata[Player] and self._playerdata[Player]._profile then
			return Resolve(self._playerdata[Player]._profile.Data)
		end

		if not self._playerdata[Player] then
			--If playerdata is not loaded, create new promise & set the _playerdata[Player] key to the new table once promise is resolved
			self._playerdata[Player] = {
				_profilePromise = self:_createPlayerdataProfile(Player)
					:andThen(function()
						Resolve(self._playerdata[Player]._profile.Data)
					end)
					:catch(Reject),
			}
		else
			--If playerdata is being loaded, wait for the _profilePromise to resolve/reject, and act accordingly
			self._playerdata[Player]._profilePromise
				:andThen(function()
					Resolve(self._playerdata[Player]._profile.Data)
				end)
				:catch(Reject)
		end
	end)
end

local tGetPlayerDataAsync = t.tuple(t.instanceIsA("Player"))
function PlayerdataService:GetPlayerdataAsync(player: Player): {}?
	assert(tGetPlayerDataAsync(player))

	local success: boolean, data: ANY_TABLE = self:PromisePlayerdata(player):await()
	if success then
		return data
	else
		warn(string.format("Could not get playerdata for %s", player.Name))
		return nil
	end
end

function PlayerdataService:GetPlayerReplica(player: Player): {}?
	t.instanceIsA("Player")
	if self._playerdata[player] then
		return self._playerdata[player]._playerReplica
	end
end

local tSetPlayerData = t.tuple(t.instanceIsA("Player"), t.string, t.optional(t.any))
function PlayerdataService:SetPlayerData(Player: Player, Key: string, Value: any?): ()
	assert(tSetPlayerData(Player, Key, Value))
	if self._playerdata[Player] and self._playerdata[Player]._profile then
		if self._playerdata[Player]._profile.Data[Key] then
			self._playerdata[Player]._profile.Data[Key] = Value
			if self._playerdata[Player]._playerReplica then
				self._playerdata[Player]._playerReplica:SetValue(Key, Value)
			end
		end
	end
end

local tIncrementPlayerData = t.tuple(t.instanceIsA("Player"), t.string, t.number)
function PlayerdataService:IncrementPlayerData(Player: Player, Key: string, Amount: number): ()
	assert(tIncrementPlayerData(Player, Key, Amount))

	if self._playerdata[Player] and self._playerdata[Player]._profile then
		if
			self._playerdata[Player]._profile.Data[Key]
			and typeof(self._playerdata[Player]._profile.Data[Key]) == "number"
		then
			self._playerdata[Player]._profile.Data[Key] += Amount
			if self._playerdata[Player]._playerReplica then
				self._playerdata[Player]._playerReplica:SetValue(Key, self._playerdata[Player]._profile.Data[Key])
			end
		end
	end
end

function PlayerdataService:AddData(Player: Player, Path: string, Value: any)
	if self._playerdata[Player] and self._playerdata[Player]._profile then
		if self._playerdata[Player]._profile.Data[Path] then
			local success, data = InventoryHelper.AddToInventory(self._playerdata[Player]._profile.Data[Path], Value)
			-- print(success, self._playerdata[Player]._profile.Data)
			if success then
				if self._playerdata[Player]._playerReplica then
					self._playerdata[Player]._playerReplica:Write(Path .. "Add", data.GUID, data)
					return success, data
				end
			end
		end
	end
end

function PlayerdataService:RemoveData(Player: Player, Path: string, Value: any)
	if self._playerdata[Player] and self._playerdata[Player]._profile then
		if self._playerdata[Player]._profile.Data[Path] then
			if self._playerdata[Player]._profile.Data[Path][Value] then
				self._playerdata[Player]._profile.Data[Path][Value] = nil
				if self._playerdata[Player]._playerReplica then
					self._playerdata[Player]._playerReplica:Write(Path .. "Remove", Value)
				end
			end
		end
	end
end

function PlayerdataService:AddRedeemedCode(player: Player, code: string, delay: number?)
	if not (self._playerdata[player] and self._playerdata[player]._profile) then
		return
	end
	
	if not (self._playerdata[player]._profile.Data.RedeemedCodes) then
		return
	end

	if not (self._playerdata[player]._playerReplica) then
		return
	end

	if type(delay) == "number" then -- if it is not a number, it is a boolean "true" as a permanent delay
		delay = os.time() + delay
	end

	self._playerdata[player]._playerReplica:Write("CodeSet", code, delay)

	return true
end

function PlayerdataService:UpdateEntry(Player: Player, Path: string, Id: string, callback)
	if self._playerdata[Player] and self._playerdata[Player]._profile then
		if self._playerdata[Player]._profile.Data[Path] then
			-- local entry = InventoryHelper.GetInventoryEntryByGUID(self._playerdata[Player]._profile.Data[Path], Id)
			local entry = self._playerdata[Player]._profile.Data[Path][Id]
			if entry then
				local data = callback(entry)
				if data then
					self._playerdata[Player]._profile.Data[Path][Id] = data
					if self._playerdata[Player]._playerReplica then
						self._playerdata[Player]._playerReplica:Write(Path .. "Update", Id, data)
					end
					return true, data
				end
			end
		end
	end
end

function PlayerdataService:ReplicateTableIndex(Player: Player, Key: string, value)
	if self._playerdata[Player] and self._playerdata[Player]._profile then
		if self._playerdata[Player]._playerReplica then
			self._playerdata[Player]._playerReplica:Write("AddPet", value.GUID, value)
		end
	end
end
				
--[=[
	Initialize PlayerdataService
	@server
	@return nil
]=]
function PlayerdataService:KnitInit()
	ReplicaService = Knit.GetService("ReplicaService")
	self._profileStore = ProfileService.GetProfileStore(STORE_NAME, PLAYER_TEMPLATE)
end

--[=[
	Start PlayerdataService
	@server
	@return nil
]=]
function PlayerdataService:KnitStart() end

return PlayerdataService
