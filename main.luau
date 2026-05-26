local module = {}

local REPO_KEY = ""
local GITHUB_LOCATION = ""
local GITHUB_SCRIPT = ""

local HttpService = game:GetService("HttpService")
local EncodingService = game:GetService("EncodingService")

function module.update_data(repo_key, github_user, repo_name, script_location)
	REPO_KEY = repo_key
	GITHUB_LOCATION = ("https://api.github.com/repos/%s/%s/contents/"):format(github_user, repo_name)
	GITHUB_SCRIPT = script_location
end

function module.loadstring_private(chunk_name)
	local RequestData = request({
		Url = GITHUB_LOCATION .. HttpService:UrlEncode(GITHUB_SCRIPT),
		Method = "GET",
		Headers = {["Authorization"] = "token " .. REPO_KEY}
	})

	RequestData = HttpService:JSONDecode(RequestData.Body)

	local UncleanedData = RequestData.content
	UncleanedData = table.concat(UncleanedData:split("\n"), "")

	UncleanedData = buffer.fromstring(UncleanedData)
	UncleanedData = EncodingService:Base64Decode(UncleanedData)

	local Script = buffer.tostring(UncleanedData)

	loadstring(Script, chunk_name)()
end

return module
