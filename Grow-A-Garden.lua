local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
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
local Options = Fluent.Options
local sell = Vector3.new(86.584465, 2.99999976, 0.426784337)
local IsAutoSeeds = false
do
    Tabs.Main:AddButton({
        Title = "Sell Inventory",
        Description = "Just sell your inventory",
        Callback = function()
            local hrp = character:WaitForChild("HumanoidRootPart")
            hrp.CFrame = CFrame.new(sell)
            wait(0.2)
            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
        end
    })
    local AutoBuySeeds = Tabs.Main:AddToggle("AutoBuySeeds", {
        Title = "Auto Buy Seeds",
        Default = false
    })
    -- AutoBuySeeds:OnChanged(function(value)

    -- end)
    AutoBuySeeds:SetValue(false)
    local SeedsList = Tabs.Main:AddDropdown("SeedsList", {
        Title = "Seeds List",
        Description = "Select seeds.",
        Values = {
            "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn",
            "Daffoli", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut",
            "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper",
            "Cacao", "Beanstalk"
        },
        Multi = true,
        Default = {},
    })
    local selectedSeeds = {}
    local selectedGears = {}
    --SeedsList:SetValue({})
    SeedsList:OnChanged(function(selected)
        for v, isSelected in pairs(selected) do
            if isSelected then
                table.insert(selectedSeeds,v)
            end
        end
    end)
    task.spawn(function()
        while true do
            if Options.AutoBuySeeds.Value then
                for _, v in ipairs(selectedSeeds) do
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(v)
                end
            end
            task.wait(0.02)
        end
    end)
    local AutoBuyGears = Tabs.Main:AddToggle("AutoBuyGears", {
        Title = "Auto Buy Gears",
        Default = false
    })
    -- AutoBuySeeds:OnChanged(function(value)

    -- end)
    AutoBuyGears:SetValue(false)
    local GearsList = Tabs.Main:AddDropdown("GearsList", {
        Title = "Gears List",
        Description = "Select gears.",
        Values = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Favorite Tool", "Harvest Tool"},
        Multi = true,
        Default = {},
    })
    local selectedGears = {}
    --SeedsList:SetValue({})
    GearsList:OnChanged(function(selected)
        for v, isSelected in pairs(selected) do
            if isSelected then
                table.insert(selectedGears,v)
            end
        end
    end)
    task.spawn(function()
        while true do
            if Options.AutoBuyGears.Value then
                for _, v in ipairs(selectedGears) do
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(v)
                end
            end
            task.wait(0.02)
        end
    end)
end
