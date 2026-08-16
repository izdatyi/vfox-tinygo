local util = require("util")

--- Return all available versions provided by this plugin
--- @param ctx table Empty table used as context, for future extension
--- @return table Descriptions of available versions and accompanying tool descriptions
function PLUGIN:Available(ctx)
    local releases = util.fetch_all_releases()
    local result = {}
    for i, rel in ipairs(releases) do
        table.insert(result, {
            version = rel.version,
            note = (i == 1) and "latest" or ""
        })
    end
    return result
end