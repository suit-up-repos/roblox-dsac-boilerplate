"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[383],{16132:e=>{e.exports=JSON.parse('{"functions":[{"name":"LogPlayerEvent","desc":"Used to track player events (example: player killed an enemy, player completed a mission, etc.)\\n\\nExamples\\n```lua\\nAnalyticsService:LogPlayerEvent({\\n\\tuserId = player.UserId,\\n\\tevent = \\"Player:KilledEnemy\\",\\n\\tvalue = 1 -- Killed 1 enemy\\n})\\nAnalyticsService:LogPlayerEvent({\\n\\tuserId = player.UserId,\\n\\tevent = \\"Player:CompletedMission\\",\\n\\tvalue = 1 -- Completed 1 mission\\n})\\nAnalyticsService:LogPlayerEvent({\\n\\tuserId = player.UserId,\\n\\tevent = \\"Player:Death\\",\\n\\tvalue = 1\\n})\\n```","params":[{"name":"data","desc":"","lua_type":"PlayerEvent"}],"returns":[],"function_type":"method","source":{"line":343,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}},{"name":"LogMarketplacePurchase","desc":"This function should be called when a successful marketplace purchase is made\\nsuch as a gamepass or developer product\\n\\nSet `LOG_DEV_PRODUCT_PURCHASES` to false inside AnalyticsService.lua if you prefer to log\\ndeveloper product purchases within MarketplaceService.ProcessReceipt\\n\\n```lua\\n-- Inside MarketplaceService.ProcessReceipt\\n-- before returning Enum.ProductPurchaseDecision.PurchaseGranted\\nAnalyticsService:LogMarketplacePurchase({\\n\\tuserId = player.UserId,\\n\\titemType = \\"Product\\",\\n\\tid = 000000000, -- Developer product id\\n\\tcartType = \\"PromptPurchase\\",\\n})\\n```","params":[{"name":"data","desc":"","lua_type":"MarketplacePurchaseEvent"}],"returns":[],"function_type":"method","source":{"line":376,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}},{"name":"LogPurchase","desc":"Shortcut function for LogResourceEvent\\nUsed to log in-game currency purchases\\n\\nExample Use:\\n```lua\\nAnalyticsService:LogPurchase({\\n\\tuserId = player.UserId,\\n\\teventType = \\"Shop\\",\\n\\tcurrency = \\"Coins\\",\\n\\titemId = \\"Red Paintball Gun\\"\\n})\\n```","params":[{"name":"data","desc":"","lua_type":"PurchaseEvent"}],"returns":[],"function_type":"method","source":{"line":410,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}},{"name":"LogResourceEvent","desc":"Used to log in-game currency changes (example: player spent coins in a shop,\\nplayer purchased coins, player won coins in a mission)\\n\\nExample Use:\\n```lua\\n-- Player purchased 100 coins with Robux\\nAnalyticsService:LogPurchase({\\n\\tuserId = player.UserId,\\n\\teventType = \\"Purchase\\",\\n\\tcurrency = \\"Coins\\",\\n\\titemId = \\"100 Coins\\"\\n})\\n```","params":[{"name":"data","desc":"","lua_type":"ResourceEvent"}],"returns":[],"function_type":"method","source":{"line":465,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}},{"name":"LogProgression","desc":"Used to track player progression (example: player score in a mission or level)\\nA progression can have up to 3 levels (example: Mission 1, Location 1, Level 1)\\n\\nExample:\\n```lua\\nAnalyticsService:LogProgression({\\n\\tuserId = player.UserId,\\n\\tstatus = \\"Start\\",\\n\\tprogression01 = \\"Mission X\\",\\n\\tprogression02 = \\"Location X\\",\\n\\tscore = 100 -- Started with score of 100\\n})\\nAnalyticsService:LogProgression({\\n\\tuserId = player.UserId,\\n\\tstatus = \\"Complete\\",\\n\\tprogression01 = \\"Mission X\\",\\n\\tprogression02 = \\"Location X\\",\\n\\tscore = 400 -- Completed the mission with a score of 400\\n})\\n```\\n\\nFor more information on progression events, refer to [GameAnalytics docs](https://docs.gameanalytics.com/integrations/sdk/roblox/event-tracking?_highlight=teleportdata#progression) on progression.","params":[{"name":"data","desc":"","lua_type":"ProgressionEvent"}],"returns":[],"function_type":"method","source":{"line":539,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}}],"properties":[],"types":[{"name":"PlayerEvent","desc":"","fields":[{"name":"userId","lua_type":"number","desc":""},{"name":"event","lua_type":"string","desc":""},{"name":"value","lua_type":"number?","desc":""}],"source":{"line":104,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}},{"name":"MarketplacePurchaseEvent","desc":"","fields":[{"name":"userId","lua_type":"number","desc":""},{"name":"itemType","lua_type":"string","desc":""},{"name":"id","lua_type":"string","desc":""},{"name":"amount","lua_type":"number?","desc":""},{"name":"cartType","lua_type":"string","desc":""}],"source":{"line":119,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}},{"name":"PurchaseEvent","desc":"- Currency is the in-game currency type used, it must be defined in the CURRENCIES table","fields":[{"name":"userId","lua_type":"number","desc":""},{"name":"eventType","lua_type":"string","desc":""},{"name":"itemId","lua_type":"string","desc":""},{"name":"currency","lua_type":"string","desc":""},{"name":"flowType","lua_type":"string?","desc":"Allowed flow types: \\"Sink\\", \\"Source\\" (defaults to \\"Sink\\")"},{"name":"amount","lua_type":"number?","desc":""}],"source":{"line":139,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}},{"name":"ResourceEvent","desc":"- Currency is the in-game currency type used, it must be defined in the CURRENCIES table","fields":[{"name":"userId","lua_type":"number","desc":""},{"name":"eventType","lua_type":"string","desc":""},{"name":"itemId","lua_type":"string","desc":""},{"name":"currency","lua_type":"string","desc":""},{"name":"flowType","lua_type":"string","desc":""},{"name":"amount","lua_type":"number","desc":""}],"source":{"line":160,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}},{"name":"ErrorEvent","desc":"","fields":[{"name":"message","lua_type":"string","desc":""},{"name":"severity","lua_type":"string?","desc":"Allowed severities: \\"Debug\\", \\"Info\\", \\"Warning\\", \\"Error\\", \\"Critical\\" (defaults to \\"Error\\")"},{"name":"userId","lua_type":"number","desc":""}],"source":{"line":177,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}},{"name":"ProgressionEvent","desc":"","fields":[{"name":"userId","lua_type":"number","desc":""},{"name":"status","lua_type":"string","desc":"Allowed statuses: \\"Start\\", \\"Fail\\", \\"Complete\\""},{"name":"progression01","lua_type":"string","desc":""},{"name":"progression02","lua_type":"string?","desc":""},{"name":"progression03","lua_type":"string?","desc":""},{"name":"score","lua_type":"number?","desc":""}],"source":{"line":193,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}}],"name":"AnalyticsService","desc":"Author: Javi M (dig1t)\\n\\nDescription: Knit service that handles GameAnalytics API requests.\\n\\nMake sure to change the API keys before using this service.\\nDevelopment keys should be used for testing and production keys should be used for release.\\n\\nBefore using this service, make sure to configure the following variables inside AnalyticsService.lua:\\n- CURRENCIES: List of all in-game currencies\\n- BUILD: Game version\\n- GAME_KEY: GameAnalytics game key\\n- SECRET_KEY: GameAnalytics secret key\\n- LOG_DEV_PRODUCT_PURCHASES: Whether or not to automatically log developer product purchases\\n- RESOURCE_EVENT_TYPES: List of all resource event types (example: player gained coins in a mission is a\\n\\"Reward\\" event type, player purchasing coins with Robux is a \\"Purchase\\" event type)\\n- GAMEPASS_IDS: List of all gamepass ids in the game\\n- CUSTOM_DIMENSIONS: Custom dimensions to be used in GameAnalytics (refer to [GameAnalytics docs](https://docs.gameanalytics.com/advanced-tracking/custom-dimensions) about dimensions)\\n\\nEvents that happen during a mission (kills, deaths, rewards) should be\\ntracked and logged after the event ends\\tto avoid hitting API limits.\\nFor example, if a player kills an enemy during a mission, the kill should be\\ntracked and logged (sum of kills) at the end of the mission.\\n\\nRefer to [GameAnalytics docs](https://docs.gameanalytics.com/integrations/sdk/roblox/event-tracking) for more information and use cases.\\n\\nUsing AnalyticsService to track events on the client:\\n```lua\\n-- Inside a LocalScript\\nlocal ReplicatedStorage = game:GetService(\\"ReplicatedStorage\\")\\nlocal Players = game:GetService(\\"Players\\")\\n\\nlocal Packages = ReplicatedStorage.Packages\\nlocal Knit = require(Packages.Knit)\\n\\nKnit.Start():await() -- Wait for Knit to start\\n\\nlocal AnalyticsService = Knit.GetService(\\"AnalyticsService\\")\\n\\nlocal timesOpenedShop: number = 2\\n\\nPlayers.PlayerRemoving:Connect(function(player: Player)\\n\\tif player == Players.LocalPlayer then\\n\\t\\t-- Before player leaves the game,\\n\\t\\t-- log the number of times the shop was opened\\n\\t\\tAnalyticsService.LogEvent:Fire({ -- Use AnalyticsService.LogEvent:Fire() to log a client-side event\\n\\t\\t\\tevent: \\"UIEvent:OpenedShop\\",\\n\\t\\t\\tvalue: timesOpenedShop -- Number of times the player opened their shop\\n\\t\\t})\\n\\tend\\nend)\\n```","realm":["Server"],"source":{"line":90,"path":"src/Server/Services/Analytics/AnalyticsService.lua"}}')}}]);