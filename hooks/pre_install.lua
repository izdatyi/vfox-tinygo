local util = require("util")

--- Returns some pre-installed information, such as version number, download address, local files, etc.
--- If checksum is provided, vfox will automatically check it for you.
--- @param ctx { version: string }
--- @return table Version information
function PLUGIN:PreInstall(ctx)

    local version = ctx.version
    local targetSuffix = util.get_platform_suffix()
    if not targetSuffix then
        error("Unsupported platform or architecture: " .. tostring(RUNTIME.osType) .. "/" .. tostring(RUNTIME.archType))
    end

    local releases = util.fetch_all_releases()
    if #releases == 0 then
        error("No TinyGo releases found")
    end

    local targetRelease = nil
    if version == "latest" or version == "" or version == nil then
        targetRelease = releases[1]
    else
        local normalized = util.clean_version(version)
        for _, rel in ipairs(releases) do
            if rel.version == normalized or rel.version == version then
                targetRelease = rel
                break
            end
        end
    end

    if not targetRelease then
        error("TinyGo version not found: " .. tostring(version))
    end

    for _, asset in ipairs(targetRelease.assets or {}) do
        if util.ends_with(asset.name, targetSuffix) then
            local sha256 = ""
            if asset.digest and type(asset.digest) == "string" and asset.digest:sub(1, 7) == "sha256:" then
                sha256 = asset.digest:sub(8)
            end

            return {
                version = targetRelease.version,
                url = asset.browser_download_url,
                sha256 = sha256 ~= "" and sha256 or nil
            }
        end
    end

    error(string.format(
        "TinyGo version %s does not provide prebuilt binaries for %s/%s",
        targetRelease.version,
        tostring(RUNTIME.osType),
        tostring(RUNTIME.archType)
    ))
end