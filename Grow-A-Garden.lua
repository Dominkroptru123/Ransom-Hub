local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local BuySeedStock = GameEvents:WaitForChild("BuySeedStock")
local BuyGearStock = GameEvents:WaitForChild("BuyGearStock")
local SellInventory = GameEvents:WaitForChild("Sell_Inventory")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Ransom Hub " .. Fluent.Version,
    SubTitle = "by g.rav3",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.K
})
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "settings" }),
}

local sell = Vector3.new(86.584465, 2.99999976, 0.426784337)
local selectedSeeds = {}
local selectedGears = {}

Tabs.Main:AddButton({
    Title = "Sell Inventory",
    Description = "Just sell your inventory",
    Callback = function()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(sell)
        wait(0.2)
        SellInventory:FireServer()
    end
})

local AutoBuySeeds = Tabs.Main:AddToggle("AutoBuySeeds", { Title = "Auto Buy Seeds", Default = false })
local SeedsList = Tabs.Main:AddDropdown("SeedsList", {
    Title = "Seeds List",
    Description = "Select seeds.",
    Values = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn","Daffoli", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut","Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper","Cacao", "Beanstalk"},
    Multi = true,
    Default = {},
})

SeedsList:OnChanged(function(selected)
    table.clear(selectedSeeds)
    for seed, isSelected in pairs(selected) do
        if isSelected then
            table.insert(selectedSeeds, seed)
        end
    end
end)

local AutoBuyGears = Tabs.Main:AddToggle("AutoBuyGears", { Title = "Auto Buy Gears", Default = false })
local GearsList = Tabs.Main:AddDropdown("GearsList", {
    Title = "Gears List",
    Description = "Select gears.",
    Values = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler","Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Favorite Tool", "Harvest Tool"},
    Multi = true,
    Default = {},
})

GearsList:OnChanged(function(selected)
    table.clear(selectedGears)
    for gear, isSelected in pairs(selected) do
        if isSelected then
            table.insert(selectedGears, gear)
        end
    end
end)

task.spawn(function()
    while true do
        if AutoBuySeeds.Value then
            for _, seed in ipairs(selectedSeeds) do
                BuySeedStock:FireServer(seed)
            end
        end
        task.wait(0.02)
    end
end)
task.spawn(function()
    while true do
        if AutoBuyGears.Value then
            for _, gear in ipairs(selectedGears) do
                BuyGearStock:FireServer(gear)
            end
        end
        task.wait(0.02)
    end
end)
