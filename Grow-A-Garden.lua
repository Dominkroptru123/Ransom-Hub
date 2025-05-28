local Players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local GameEvents = rs:WaitForChild("GameEvents")
local BuySeedStock = GameEvents:WaitForChild("BuySeedStock")
local BuyGearStock = GameEvents:WaitForChild("BuyGearStock")
local sellinventory = GameEvents:WaitForChild("Sell_Inventory")
local backpack = game.Players.LocalPlayer.Backpack
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local pname = player.Name
local hrppos = character:WaitForChild("HumanoidRootPart").Position
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local onetimefruits = {"Carrot", "Daffodil", "Orange Tulip", "Watermelon", "Pumpkin", "Bamboo", "Mushroom"}
local fruitlist = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn","Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut","Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper","Cacao", "Beanstalk"}
--variables
local function checks(a, b)
    for _, v in ipairs(b) do
        if v == a then
            return true
        end
    end
    return false
end
--check function
local Window = Fluent:CreateWindow({
    Title = "Ransom Hub " .. Fluent.Version,
    SubTitle = "by 51 aka fiftyone",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
local Tabs = {
    Main = Window:AddTab({ Title = "Tab Farm", Icon = "carrot" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
--Tabs, Windows
local infjump = true
game:GetService("UserInputService").JumpRequest:connect(function()
	if infjump then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)
--Inf Jump
local farm = nil
for _, v in game.Workspace.Farm:GetChildren() do
    local v2 = v:FindFirstChild("Important")
    if v2 then 
        local v3 = v2:FindFirstChild("Data")
        if v3 and v3.Owner.Value == pname then
            farm = v3
            break
        end
    end
end
local plant = farm.Parent.Plants_Physical
--Get plr farm
local sell = Vector3.new(86.584465, 2.99999976, 0.426784337)
local selectedSeeds = {}
local selectedGears = {}
local function itemcnt()
    local cnt = 0
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            cnt += 1
        end
    end
    return cnt
end
--count the items in backpack
Tabs.Main:AddButton({
    Title = "Sell Inventory",
    Description = "Just sell your inventory",
    Callback = function()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local hrppos1 = hrp.Position
        hrp.CFrame = CFrame.new(sell)
        wait(0.15)
        sellinventory:FireServer()
        wait(0.15)
        hrp.CFrame = CFrame.new(hrppos1)
    end
})
--sell inventory
local AutoHarvest = Tabs.Main:AddToggle("AutoHarvest", { Title = "Auto Collect", Default = false })

local AutoBuySeeds = Tabs.Main:AddToggle("AutoBuySeeds", { Title = "Auto Buy Seeds", Default = false })
local SeedsList = Tabs.Main:AddDropdown("SeedsList", {
    Title = "Seeds List",
    Description = "Select seeds.",
    Values = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn","Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut","Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper","Cacao", "Beanstalk"},
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
--auto buy seeds
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
--auto buy gears
local AutoSellFruits = Tabs.Main:AddToggle("AutoSellFruits", { Title = "Auto Sell Fruits", Default = false })

local fruitlimit = Tabs.Main:AddSlider("fruitlimit", {
    Title = "Fruit Limit",
    Description = "Slide to choose the limit",
    Default = 200,
    Min = 1,
    Max = 200,
    Rounding = 1,
})
--auto sell fruit
local AutoPlant = Tabs.Main:AddToggle("AutoPlant", { Title = "Auto Plant", Default = false })
Tabs.Main:AddButton({
    Title = "Set Plant Location",
    Description = "Set yout plant location for auto plant",
    Callback = function()
        hrppos = character:WaitForChild("HumanoidRootPart").Position
    end
})
--plan point
task.spawn(function()
    while true do
        for _, v in backpack:GetChildren() do
            if string.find(string.lower(v.Name), "seed") then
                if v:IsA("Tool") and AutoPlant.Value then
                    v.Parent = character
                    for i = tonumber(string.match(v.Name, "%d+")), 1,-1 do
                        local start = string.find(string.lower(v.Name), "seed")
                        local s = string.sub(v.Name, 1, start-2)
                        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(vector.create(hrppos.X, 0.13552704453468323, hrppos.Z),s)
                        task.wait(0.25)
                    end
                end
            end
        end
        task.wait(0.01)
    end
end)
task.spawn(function()
    while true do
        for _ ,v in plant:GetChildren() do
            if checks(v.Name,onetimefruits) then
                if AutoHarvest.Value then
                    game.ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring("\001\001\000\001"),{ v })
                end
            else
                for _, i in v.Fruits:GetChildren() do
                    if AutoHarvest.Value then
                        game.ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring("\001\001\000\001"),{ i })
                    end
                    task.wait(0.04)
                end
            end
        end
        task.wait(0.01)
    end
end)
task.spawn(function()
    while true do
        if AutoSellFruits.Value then
            local val = tonumber(fruitlimit.Value)
            if itemcnt() >= val then
                local hrp = character:WaitForChild("HumanoidRootPart")
                local hrppos1 = hrp.Position
                hrp.CFrame = CFrame.new(sell)
                wait(0.15)
                sellinventory:FireServer()
                wait(0.15)
                hrp.CFrame = CFrame.new(hrppos1)
            end
        end
        task.wait(0.1)
    end
end)
task.spawn(function()
    while true do
        if AutoBuySeeds.Value then
            for _, seed in ipairs(selectedSeeds) do
                BuySeedStock:FireServer(seed)
            end
        end
        task.wait(0.1)
    end
end)
task.spawn(function()
    while true do
        if AutoBuyGears.Value then
            for _, gear in ipairs(selectedGears) do
                BuyGearStock:FireServer(gear)
            end
        end
        task.wait(0.1)
    end
end)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("RansomHub")
SaveManager:SetFolder("RansomHub/Grow-A-Garden")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
Fluent:Notify({
    Title = "Ransom Hub",
    Content = "The script for Grow A Garden has been loaded, thank you for using, much love from Vietnam.",
    Duration = 6
})
SaveManager:LoadAutoloadConfig()
