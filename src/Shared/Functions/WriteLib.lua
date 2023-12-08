return {
	PetsAdd = function(replica, index: string, value: table)
		replica:SetValue({ "Pets", index }, value)
	end,
	PetsUpdate = function(replica, index: string, value: table)
		replica:SetValue({ "Pets", index }, value)
	end,
	PetsRemove = function(replica, index: string)
		replica:SetValue({ "Pets", index }, nil)
	end,
	CodeSet = function(replica, index: string, value: table)
		replica:SetValue({"RedeemedCodes", index}, value)
	end,
	-- AchievementsUpdate = function(replica, path, newValue)
	-- 	warn("AchievementsUpdate", path, newValue)
	-- 	replica:SetValue({ "Achievements", path }, newValue)
	-- end,
}
