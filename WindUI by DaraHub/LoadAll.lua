local fileNames = {
    "ButtonLib.lua",  -- read docs at https://darahub.pages.dev/Module/Library/GUI/Documents/ButtonLib.md
    "NotifyToast.lua", -- read docs at https://darahub.pages.dev/Module/Library/GUI/Documents/NotifyToast.md
    "CallDialogScreen.lua",  -- read docs at https://darahub.pages.dev/Module/Library/GUI/Documents/CallDialogScreen.md
}

local baseUrl = "https://darahub.pages.dev/Module/Library/GUI/"


local threads = {}

function loadInBackground(fileName)
    return coroutine.create(function()
        local fullUrl = baseUrl .. fileName
        
        local success, result = pcall(function()
            return game:HttpGet(fullUrl)
        end)
        
        if success and result then
            local loadFunction, loadError = loadstring(result)
            if loadFunction then
                loadFunction()
            else
                warn("Loadstring failed for " .. fileName .. ": " .. tostring(loadError))
            end
        else
            warn("Failed to get " .. fileName .. ": " .. tostring(result))
        end
    end)
end

for _, fileName in ipairs(fileNames) do
    table.insert(threads, loadInBackground(fileName))
end
for _, thread in ipairs(threads) do
    task.spawn(function()
        coroutine.resume(thread)
    end)
end
