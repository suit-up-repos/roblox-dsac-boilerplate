-- DataController
-- Author(s): Jesse
-- Date: 12/06/2021

--[[
    FUNCTION    DataController:GetDataByName( name: string ) -> ( any? )
    FUNCTION    DataController:GetDataChangedSignal( name: string, createIfNoExists: boolean ) -> ( Signal? )
    FUNCTION    DataController:ObserveDataChanged( name: string, callback: ()->() ) -> ( Connection )
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Packages = game:GetService("ReplicatedStorage").Packages
local Knit = require( Packages:WaitForChild("Knit") )
local Signal = require( Packages.Signal )
local Promise = require( Packages.Promise )
local t = require( Packages.t )
local DataService

-- Roblox Services

-- Variables

---------------------------------------------------------------------

-- DataController properties
local DataController = Knit.CreateController {
    Name = "DataController";
    Data = {};
    ChangedSignals = {};
    Initialized = false;
    InitializationComplete = Signal.new();
}


-- Checks and optionally waits for initialization to complete
function DataController:WaitForInitialization(): ()
    return self.Initialized or self.InitializationComplete:Wait()
end


-- Gets the player's full dataset (recommend using GetDataByName instead)
function DataController:GetData()
    repeat task.wait() until self.Initialized
    return self.Data
end


-- Gets a specific value inside of the data
local tGetDataByName = t.tuple( t.string )
function DataController:GetDataByName( name: string ): ( any? )
    assert( tGetDataByName(name) )
    self:WaitForInitialization()
    return self.Data[ name ]
end


-- Returns the signal that fires when that data gets replicated to the client
local tGetDataChangedSignal = t.tuple( t.string, t.optional(t.boolean) )
function DataController:GetDataChangedSignal( name: string, createIfNoExists: boolean? ): ( table )
    assert( tGetDataChangedSignal(name, createIfNoExists) )
    if ( not createIfNoExists ) then
        self:WaitForInitialization()
    end

    local findSignal = self.ChangedSignals[ name ]
    if ( findSignal ) then
        return findSignal
    elseif ( createIfNoExists ) then 
        local newSignal = Signal.new()
        self.ChangedSignals[ name ] = newSignal
        return newSignal
    else
        return error( "No data changed signal found for \"" .. tostring(name) .. "\"!" )
    end
end


-- Observes when data gets replicated to the client
local tObserveDataChanged = t.tuple( t.string, t.callback )
function DataController:ObserveDataChanged( name: string, callback: ()->() ): ()
    assert( tObserveDataChanged(name, callback) )
    local dataChangedSignal = self:GetDataChangedSignal( name )
    local function Update( ... )
        callback( ... )
    end
    Update( self:GetDataByName(name) )
    return dataChangedSignal:Connect( Update )
end


-- When player data is received
function DataController:_receiveDataUpdate( name: string, value: any? ): ( any? )
    local changedSignal = self:GetDataChangedSignal( name, true )
    --print( "Received data update for", name, "| Value:", value )
    self.Data[ name ] = value
    changedSignal:Fire( value )
end


-- When player's table data by index is received
function DataController:_receiveTableIndexUpdate( name: string, index: string, value: any? ): ()
    local changedSignal = self:GetDataChangedSignal( name, true )
    local findTable: {} = self:GetDataByName( name )
    if ( typeof(findTable) == "table" ) then
        findTable[ index ] = value
        changedSignal:Fire( findTable )
    end
end


-- Starts this controller
function DataController:KnitStart(): ()
    local dataPromise = Promise.new(function( resolve, reject )
        local function GetData()
            return pcall(function()
                return DataService:GetPlayerData()
            end)
        end

        local success, data
        repeat
            success, data = GetData()
        until ( success and data ) or ( not task.wait(1) )

        resolve( data )
    end):andThen(function( data )
        for name, value in pairs( data ) do
            task.spawn( self._receiveDataUpdate, self, name, value )
        end

        self.Initialized = true
        self.InitializationComplete:Fire()
    end):catch(warn )
end


-- Sets up DataService
function DataController:KnitInit(): ()
    DataService = Knit.GetService( "DataService" )

    DataService.ReplicateData:Connect(function( ... )
        self:_receiveDataUpdate( ... )
    end)

    DataService.ReplicateTableIndex:Connect(function( ... )
        self:_receiveTableIndexUpdate( ... )
    end)
end


return DataController