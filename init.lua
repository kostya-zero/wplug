-- @type table
local M = {}
local api = require("wezterm")
local default_opts = {
    spec = {
        {
            "kostya-zero/wplug",
            provider = "https://github.com",
            name = "wplug",
            branch = "main",
            local_install = false
        }
    },
    config = {}
}

M.opts = default_opts

local function dir_exists()
    local status, _ = pcall(io.open, "~/.wplug")
    return status
end

local function git_clone(url, path, branch)
    local git_status = io.popen("git clone --branch " .. branch .. " " .. url .. " -- " .. path, "r"):read("*a")
    if string.match(git_status, "fatal:") then
        api.log_error("wplug: installation of " .. url .. "failed.")
    end
end

function M.setup(opts)
    if opts == nil then
        opts = default_opts
    end

    if opts.spec == nil then
        return
    end

    package.path = package.path .. ";~/.wezterm/?/?.lua"
    package.path = package.path .. ";~/.wezterm/?/init.lua"
    package.path = package.path .. ";~/.wezterm/?/lua/?.lua"
    package.path = package.path .. ";~/.wezterm/?/lua/init.lua"

    if dir_exists() then
        os.execute("mkdir ~/.wplug")
    end

    api.log_info(opts)
    M.opts.spec = {}

    for _, v in pairs(opts.spec) do
        local repo = v[1]
        if v.local_install == nil then
            v.local_install = false
        end


        if v.local_install == true then
            api.log_info("wplug: loading localy installed plugin " .. repo)
            package.path = package.path .. ";" .. repo .. "/lua/?.lua"
            package.path = package.path .. ";" .. repo .. "/lua/init.lua"
            package.path = package.path .. ";" .. repo .. "/?.lua"
            package.path = package.path .. ";" .. repo .. "/init.lua"
            table.insert(M.opts.spec, v)
            api.log_info("wplug: " .. repo .. " loaded.")
        elseif v.local_install == false then
            api.log_info("wplug: working with " .. repo)
            if v.branch == nil then
                v.branch = "main"
            end

            if v.name == nil then
                local name_index = 0
                local name_temp = repo:gsub("/", "")
                for i in string.gmatch(name_temp, "%a+") do
                    if name_index == 0 then
                        name_index = 1
                    else
                        v.name = i
                    end
                end
            end

            if v.provider == nil then
                v.provider = "https://github.com"
            end

            if io.open("~/.wplug/" .. v.name) ~= nil then
                api.log_info("wplug: installing " .. repo)
                git_clone(v.provider .. "/" .. repo, "~/.wplug/" .. v.name, v.branch)
            else
                api.log_info("wplug: plugin " .. repo .. " already installed.")
            end
            table.insert(M.opts.spec, v)
            table.insert(M.opts.config, opts.config)
            api.log_info("wplug: finished initialization.")
        end
    end

    api.log_info(M.opts.spec)

end

function M.count()
    local count = 0
    for _ in pairs(M.opts.spec) do count = count + 1 end
    return count
end

function M.update()
    for _, i in pairs(M.opts.spec) do
        if i.local_install == false then
            
        end
    end
end

return M
