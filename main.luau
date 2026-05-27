local container = {}

local REPO_KEY = ""
local GITHUB_LOCATION = ""

local HttpService = game:GetService("HttpService")
local EncodingService = game:GetService("EncodingService")

local function encode_url(url)
	return url:gsub(" ", "%%20")
end

local function debug_print(text)
	print(("PRIVATE_LOADSTRING: %s"):format(text))
end

function container.update_data(repo_key, github_user, repo_name)
	REPO_KEY = repo_key
	GITHUB_LOCATION = ("https://api.github.com/repos/%s/%s/contents/"):format(github_user, repo_name)
end

function container.loadstring_private(script_location, chunk_name)
	if not chunk_name then
		chunk_name = ""
	end

	--debug_print("Requesting github data...")

	local RequestData = request({
		Url = GITHUB_LOCATION .. encode_url(script_location),
		Method = "GET",
		Headers = {["Authorization"] = "token " .. REPO_KEY}
	})

	RequestData = HttpService:JSONDecode(RequestData.Body)

	--debug_print("Decoding request data...")

	local UncleanedData = RequestData.content
	UncleanedData = table.concat(UncleanedData:split("\n"), "")

	--debug_print("Cleaning request data...")

	UncleanedData = buffer.fromstring(UncleanedData)
	UncleanedData = EncodingService:Base64Decode(UncleanedData)

	local Script = buffer.tostring(UncleanedData)

	--debug_print("Finalizing request data...")
	--debug_print(("Data: %s"):format(Script))

	return loadstring(Script, chunk_name)()
end

return container
