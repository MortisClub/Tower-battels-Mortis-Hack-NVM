-- Mortis NVM HACK v3.3 - main.lua
-- Точка входа: подгружает монолитный runtime.lua с GitHub

local HttpService = game:GetService("HttpService")

-- ЗАМЕНИ ЭТУ СТРОКУ НА СВОЙ RAW-URL ДО runtime.lua
-- Пример: https://raw.githubusercontent.com/<USER>/Tower-battels-Mortis-Hack/main/runtime.lua
local RUNTIME_URL = "https://raw.githubusercontent.com/<USER>/Tower-battels-Mortis-Hack/main/runtime.lua"

local function safeHttpGet(url)
    local ok, result = pcall(game.HttpGet, game, url)
    if not ok then
        warn("[Mortis NVM HACK v3.3] HttpGet failed: " .. tostring(result))
        return nil
    end
    return result
end

local function loadRuntime()
    local source = safeHttpGet(RUNTIME_URL)
    if not source or source == "" then
        warn("[Mortis NVM HACK v3.3] Empty runtime.lua response")
        return
    end

    local fn, err = loadstring(source)
    if not fn then
        warn("[Mortis NVM HACK v3.3] loadstring error: " .. tostring(err))
        return
    end

    local ok, runtimeErr = pcall(fn)
    if not ok then
        warn("[Mortis NVM HACK v3.3] runtime.lua crashed: " .. tostring(runtimeErr))
    end
end

loadRuntime()

