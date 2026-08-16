--- Each SDK may have different environment variable configurations.
--- This allows plugins to define custom environment variables (including PATH settings)
--- Note: Be sure to distinguish between environment variable settings for different platforms!
--- @param ctx { path: string } Context information
function PLUGIN:EnvKeys(ctx)

    local mainPath = ctx.path
    return {
        {
            key = "TINYGOROOT",
            value = mainPath
        },
        {
            key = "PATH",
            value = mainPath .. "/bin"
        }
    }
end