--[[
	Framework 2019
]]--

loadscreen_manual_shutdown "yes"

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_scripts {
	"@async/async.lua",
	"@mysql-async/lib/MySQL.lua",
	
	"server/*",
	"server/functions/*",
	"server/user/*",

	"shared/*"
}

client_scripts {
	"client/*",
	"client/functions/*",

	"shared/*"
}

shared_scripts {
	"config.lua"
}

exports {
	"UpdateUser",
	"FetchUser",
	"FetchMain",
	"EditRichPresence"
}

server_exports {
	"UpdateUser",
	"FetchUser",
	"FetchUserWithIdentifier",
	"FetchMain",
	"IsWhitelisted",
	"RefreshWhitelist"
}