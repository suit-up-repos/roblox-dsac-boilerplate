"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[682],{14630:e=>{e.exports=JSON.parse('{"functions":[{"name":"_positionToBase64Key","desc":"Generate a unique key based upon location","params":[{"name":"Position","desc":"The input position to convert to a Base64 string","lua_type":"vector3"}],"returns":[{"desc":"Returns a promise that resolves w/a Base64 string","lua_type":"Promise<T>"}],"function_type":"method","private":true,"source":{"line":89,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"_abbreviateTable","desc":"Convert table to a string (Better than json)","params":[{"name":"totalSummary","desc":"The total_summary table","lua_type":"table"}],"returns":[{"desc":"Returns an abbreviated table as a string","lua_type":"string"}],"function_type":"method","private":true,"source":{"line":115,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"_trackPart","desc":"Check to see if a logo part (For braintracking) has decals under it w/the relevant logos being tracked","params":[{"name":"logoPart","desc":"The logo object to check for decals","lua_type":"BasePart"}],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"method","private":true,"source":{"line":140,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"_untrackPart","desc":"Remove a logo part from the list of assets to check for ad visibility","params":[{"name":"logoPart","desc":"The logo object to check for decals","lua_type":"BasePart"}],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"method","private":true,"source":{"line":207,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"_reportPlayerPosition","desc":"Report the player\'s current position to BrainTrackService","params":[],"returns":[{"desc":"Returns a promise that resolves if the position was reported successfully, and rejects if not","lua_type":"Promise<T>"}],"function_type":"method","private":true,"source":{"line":221,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"_reportImageImpressions","desc":"Report the player\'s current ad impressions to BrainTrackService","params":[],"returns":[{"desc":"Returns a promise that resolves if ad impressions were successfully reported, and rejects if not","lua_type":"Promise<T>"}],"function_type":"method","private":true,"source":{"line":254,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"_refreshAdsList","desc":"Clears the list of ad parts with the controller and goes through the array of BRAINTRACK_COLLECTIONTAG items via CollectionService","params":[],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"method","private":true,"source":{"line":312,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"AddLogoToTrack","desc":"Adds a logo to be tracked (Via decal/texture ID) to the list of logos to be tracked","params":[{"name":"logoTexture","desc":"The decal/texture ID of the logo we\'re tracking","lua_type":"string"}],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"method","source":{"line":335,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"KnitInit","desc":"Initialize BrainTrackingController","params":[],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"method","source":{"line":351,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"KnitStart","desc":"Start BrainTrackingController","params":[],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"method","source":{"line":375,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}}],"properties":[{"name":"AD_IMPRESSION_STUD_RANGE","desc":"How close the player needs to be (From an ad impression part) for it to qualify as an impression","lua_type":"number","source":{"line":39,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"AD_IMPRESSION_REPORT_THRESHOLD","desc":"How many impressions a specific ad part needs to have in order to send an impression event to the server\\nEg. AD_IMPRESSION_REPORT_THRESHOLD is 10, if the specific ad part is on the player\'s screen for > 10 seconds (Cumulative), it is reported to the server and then the threshold is reset to 0","lua_type":"number","source":{"line":47,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"POSITION_REPORTING_TIME","desc":"How often to report the character\'s position to the server for tracking purposes","lua_type":"number","source":{"line":56,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"IMPRESSION_REPORTING_TIME","desc":"How often to check (In seconds) for ads that are present on the player\'s screen","lua_type":"number","source":{"line":63,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"table","desc":"An array of image IDs that should be tracked (Decals/textures should be located under parts tagged with BRAINTRACK_COLLECITONTAG)\\nImage IDs can be defined here as strings, or added via BrainTrackingController:AddLogoToTrack(logoTexture: string)","lua_type":"LOGO_ASSETS","source":{"line":71,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}},{"name":"BRAINTRACK_COLLECTIONTAG","desc":"The tag that CollectionService will use for keeping track of parts to track ad impressions with","lua_type":"string","source":{"line":77,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}}],"types":[],"name":"BrainTrackingController","desc":"Author: James (stinkoDad20x6)\\nRefactored by ArtemisTheDeer\\nDate: 11/13/2023\\nProject: Sparkles\\nDescription : track keepAlive with position and some player stats.","realm":["Client"],"source":{"line":11,"path":"src/Client/Controllers/Analytics/BrainTrackingController.lua"}}')}}]);