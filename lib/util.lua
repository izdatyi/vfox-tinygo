local http = require("http")
local json = require("json")

local util = {}

local GITHUB_API_URL = "https://api.github.com/repos/tinygo-org/tinygo/releases"

function util.get_platform_suffix()
    local osType = RUNTIME.osType
    local archType = RUNTIME.archType

    if osType == "windows" then
        if archType == "amd64" or archType == "x86_64" or archType == "x64" then
            return ".windows-amd64.zip"
        end
    elseif osType == "darwin" then
        if archType == "arm64" or archType == "aarch64" then
            return ".darwin-arm64.tar.gz"
        elseif archType == "amd64" or archType == "x86_64" or archType == "x64" then
            return ".darwin-amd64.tar.gz"
        end
    elseif osType == "linux" then
        if archType == "arm64" or archType == "aarch64" then
            return ".linux-arm64.tar.gz"
        elseif archType == "arm" or archType == "armv6l" or archType == "armv7l" or archType == "armhf" then
            return ".linux-arm.tar.gz"
        elseif archType == "amd64" or archType == "x86_64" or archType == "x64" then
            return ".linux-amd64.tar.gz"
        end
    end

    return nil
end

function util.ends_with(str, suffix)
    return suffix == "" or str:sub(-#suffix) == suffix
end

function util.clean_version(raw)
    if not raw then return "" end
    -- Remove "Release ", "release ", "Release-", "release-", and leading "v"/"V"
    local v = raw:gsub("^[Rr]elease[%s%-]*", ""):gsub("^[vV]", "")
    return v
end


function util.fetch_all_releases()
    local mirror = os.getenv("VFOX_TINYGO_MIRROR") or os.getenv("GITHUB_MIRROR")
    local baseUrl = GITHUB_API_URL
    if mirror and mirror ~= "" then
        baseUrl = mirror .. "/repos/tinygo-org/tinygo/releases"
    end

    local page = 1
    local allReleases = {}

    while true do
        local separator = baseUrl:find("%?") and "&" or "?"
        local url = string.format("%s%spage=%d&per_page=100", baseUrl, separator, page)

        local resp, err = http.get({
            url = url,
            headers = {
                ["User-Agent"] = "vfox-tinygo"
            }
        })

        if err ~= nil or resp.status_code ~= 200 then
            local msg = "Failed to fetch TinyGo releases"
            if err then
                msg = msg .. ": " .. tostring(err)
            elseif resp then
                msg = msg .. ": HTTP " .. tostring(resp.status_code)
            end
            error(msg)
        end

        local body = json.decode(resp.body)
        if not body or #body == 0 then
            break
        end

        for _, item in ipairs(body) do
            if not item.draft and not item.prerelease then
                local rawTag = item.tag_name or ""
                if rawTag == "" then
                    rawTag = item.name or ""
                end
                local version = util.clean_version(rawTag)

                table.insert(allReleases, {
                    version = version,
                    raw_tag = rawTag,
                    assets = item.assets or {}
                })
            end
        end

        if #body < 100 then
            break
        end

        page = page + 1
    end

    return allReleases
end

return util