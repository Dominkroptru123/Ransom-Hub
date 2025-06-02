if not game:IsLoaded() then
    game.Loaded:Wait()
end
local replicatedstorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GameEvents = replicatedstorage:WaitForChild("GameEvents")
local BuySeedStock = GameEvents:WaitForChild("BuySeedStock")
local BuyGearStock = GameEvents:WaitForChild("BuyGearStock")
local BuyEventItems = GameEvents:WaitForChild("BuyEventShopStock")
local sellinventory = GameEvents:WaitForChild("Sell_Inventory")
local sellitem = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Item")
local backpack = Players.LocalPlayer.Backpack
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local pname = player.Name
local hrppos = character:WaitForChild("HumanoidRootPart").Position
local isplanted = false
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
local function checks2(item)
	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character or player.CharacterAdded:Wait()

	if backpack and backpack:FindFirstChild(item) then
		return true
	end

	if character and character:FindFirstChild(item) then
		return true
	end

	return false
end
--check function 2
local function ispollinatedleft()
    for _, v in backpack:GetChildren() do
        if v:IsA("Tool") and string.find(string.lower(v.Name),"pollinated") then
            return true
        end
    end
    for _, v in character:GetChildren() do
        if v:IsA("Tool") and string.find(string.lower(v.Name),"pollinated") then
            return true
        end
    end
    return false
end
local Window = Fluent:CreateWindow({
    Title = "Ransom Hub " .. Fluent.Version,
    SubTitle = "by fiftyy.one and Dominkroptru123",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
local Tabs = {
    Info = Window:AddTab({Title = "Info", Icon = ""}),
    Main = Window:AddTab({Title = "Tab Farm", Icon = "" }),
    Event = Window:AddTab({Title = "Honey Event", Icon = "" }),
    DupeTab = Window:AddTab({ Title = "Dupe", Icon = "" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "" }),
}

Tabs.Info:AddParagraph({
    Title = "Get fast update by join our server!",
    Description = ""

})
Tabs.Info:AddButton({
    Title = "Discord link",
    Description = "Click to copy Discord link",
    Callback = function()
        setclipboard("https://discord.gg/vZFFmeJp")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Discord Link",
            Text = "https://discord.gg/vZFFmeJp",
            Duration = 5
        })
    end
})
--Tabs, Windowsf
local infjump = true
game:GetService("UserInputService").JumpRequest:Connect(function()
	if infjump then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)
--Inf Jump
local vu = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
--antiafk
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
local gear = Vector3.new(-285.88616943359375, 2.999999761581421, -33.095706939697266)
local cosmetics = Vector3.new(-285.88616943359375, 2.999999761581421, -14.9064884)
local selectedSeeds = {}
local selectedGears = {}
local blacklisted = {}
local selectedEggs = {}
local selectedeventitems = {}
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
        wait(0.2)
        sellinventory:FireServer()
        wait(0.2)
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
local AutoBuyEggs = Tabs.Main:AddToggle("AutoBuyEggs", { Title = "Auto Buy Eggs", Default = false })
local EggsList = Tabs.Main:AddDropdown("EggsList", {
    Title = "Eggs List",
    Description = "Select eggs.",
    Values = {"Common Egg","Uncommon Egg","Rare Egg","Legendary Egg","Mythical Egg","Bug Egg"},
    Multi = true,
    Default = {},
})

EggsList:OnChanged(function(selected)
    table.clear(selectedEggs)
    for egg, isSelected in pairs(selected) do
        if isSelected then
            table.insert(selectedEggs, egg)
        end
    end
end)
--auto buy eggs
local AutoSellFruits = Tabs.Main:AddToggle("AutoSellFruits", { Title = "Auto Sell Fruits", Default = false })

local fruitlimit = Tabs.Main:AddSlider("fruitlimit", {
    Title = "Fruit Limit",
    Description = "Slide to choose the limit",
    Default = 200,
    Min = 3,
    Max = 200,
    Rounding = 1,
})
local BlacklistMutated = Tabs.Main:AddDropdown("BlacklistMutated", {
    Title = "Blacklist Mutated",
    Description = "Select mutated types",
    Values = {"Wet","Chilled","Chocolate","Moonlit","Bloodlit","Plasma","Frozen","Gold","Zombified","Twisted","Rainbow","Shocked","Celestial","Disco","Voidtouched"},
    Multi = true,
    Default = {},
})

BlacklistMutated:OnChanged(function(selected)
    table.clear(blacklisted)
    for seed, isSelected in pairs(selected) do
        if isSelected then
            table.insert(blacklisted, seed)
        end
    end
end)
--auto sell fruit
local AutoPlant = Tabs.Main:AddToggle("AutoPlant", { Title = "Auto Plant", Default = false })
Tabs.Main:AddButton({
    Title = "Set Plant Location",
    Description = "Set yout plant location for auto plant",
    Callback = function()
        hrppos = character:WaitForChild("HumanoidRootPart").Position
        isplanted = true
    end
})
local AutoQuest = Tabs.Main:AddToggle("AutoQuest", { Title = "Auto Quest", Default = false })

--plan point
Tabs.Teleport:AddButton({
    Title = "Teleport To Gear Shop",
    Description = "Self-explain",
    Callback = function()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(gear)
    end
})
Tabs.Teleport:AddButton({
    Title = "Teleport To Cosmetics Shop",
    Description = "Self-explain",
    Callback = function()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(cosmetics)
    end
})
--teleport thingy
local AutoDupe = Tabs.DupeTab:AddToggle("AutoDupe", { Title = "Auto Dupe [PATCHED]", Default = false })
Tabs.DupeTab:AddParagraph({
    Title = "How To Dupe",
    Content = "Equip a pet on another account in the same server"
})
local AutoEvent = Tabs.Event:AddToggle("AutoEvent", { Title = "Auto Farm Honey", Default = false })
local AutoBuyEventItems = Tabs.Event:AddToggle("AutoBuyEventItems", { Title = "Auto Buy Event Items", Default = false })
local EventShopList = Tabs.Event:AddDropdown("EventShopList", {
    Title = "Event Item List",
    Description = "Select event items.",
    Values = {"Flower Seed Pack","Nectarine","Hive Fruit","Honey Sprinkler","Bee Egg","Bee Crate","Honey Comb","Bee Chair","Honey Torch","Honey Walkway"},
    Multi = true,
    Default = {},
})

EventShopList:OnChanged(function(selected)
    table.clear(selectedeventitems)
    for eventitems, isSelected in pairs(selected) do
        if isSelected then
            table.insert(selectedeventitems, eventitems)
        end
    end
end)
local issell = false
task.spawn(function()
    while true do
        if AutoBuyEventItems.Value then
            for _, eventitems in ipairs(selectedeventitems) do
                BuyEventItems:FireServer(eventitems)
            end
        end
        task.wait(0.25)
    end
end)
task.spawn(function()
    while true do
        if AutoEvent.Value then
            for _, v in backpack:GetChildren() do
                if string.find(string.lower(v.Name), "pollinated") and not issell then
                    v.Parent = character
                    task.wait(0.1)
                    while checks2(v.Name) do
                        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("HoneyMachineService_RE"):FireServer("MachineInteract")
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)
task.spawn(function()
    while true do
        if AutoQuest.Value then
            game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring("\002"))
        end
        task.wait(2.5)
    end
end)
task.spawn(function()
    local SellPetEvent = replicatedstorage:WaitForChild("GameEvents"):WaitForChild("SellPet_RE")
    while true do
        for _, obj in ipairs(game.Workspace:GetChildren()) do
            local plr = game.Players:GetPlayerFromCharacter(obj)
            if plr then
                for _, v in ipairs(obj:GetChildren()) do
                    if v:IsA("Model") or v:IsA("Folder") or v:IsA("Part") then
                        if string.find(string.lower(v.Name), "age") then
                            while obj:FindFirstChild(v.Name) do
                                if AutoDupe.Value then
                                    SellPetEvent:FireServer(v)
                                    task.wait(0.001)
                                end
                                task.wait(0.01)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.01)
    end
end)
task.spawn(function()
    while true do
        if AutoBuyEggs.Value then
            local cnt = 1
            for _, v in pairs(game.Workspace.NPCS:WaitForChild("Pet Stand").EggLocations:GetChildren()) do
                if string.find(string.lower(v.Name), "egg") then
                    if checks(v.Name,selectedEggs) then
                        replicatedstorage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(cnt)
                    end
                    cnt = cnt + 1
                end
            end
        end
        task.wait(0.3)
    end
end)
task.spawn(function()
    while true do
        for _, v in backpack:GetChildren() do
            if v:IsA("Tool") and AutoPlant.Value and string.find(string.lower(v.Name), "seed") then
                while checks2(v.Name) do
                    if not v or not v.Parent or v.Parent == nil or v.Parent == game then
                        break
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if v.Parent == backpack then
                        if humanoid then
                            if isplanted then
                                pcall(function()
                                    humanoid:EquipTool(v)
                                end)
                            end
                        end
                    end
                    local seedStart = string.find(string.lower(v.Name), "seed")
                    local seedName = v.Name:sub(1, seedStart - 2):gsub("%s*$", "")
                    if v.Parent == character then
                        replicatedstorage:WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(vector.create(hrppos.X, 0.13552704453468323, hrppos.Z),seedName)
                    else
                        if isplanted then
                            pcall(function()
                                humanoid:EquipTool(v)
                            end)
                        end
                        replicatedstorage:WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(vector.create(hrppos.X, 0.13552704453468323, hrppos.Z),seedName)
                    end
                    task.wait(0.1)
                end
            end
        end
        task.wait(0.1)
    end
end)


task.spawn(function()
    while true do
        for _ ,v in plant:GetChildren() do
            if checks(v.Name,onetimefruits) then
                if AutoHarvest.Value then
                    replicatedstorage:WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring("\001\001\000\001"),{ v })
                end
            else
                if v:FindFirstChild("Fruits") then 
                    for _, i in v.Fruits:GetChildren() do
                        if AutoHarvest.Value then
                            replicatedstorage:WaitForChild("ByteNetReliable"):FireServer(buffer.fromstring("\001\001\000\001"),{ i })
                        end
                        task.wait(0.01)
                    end
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
                    issell = true
                    local hrp = character:WaitForChild("HumanoidRootPart")
                    for _, u in character:GetChildren() do
                        if u:IsA("Tool") then
                            u.Parent = backpack
                        end
                    end
                    for _, v in backpack:GetChildren() do
                        local check2716 = false
                        local check2717 = false
                        for _, i in ipairs(blacklisted) do
                            if string.find(string.lower(v.Name), string.lower(i)) then
                                check2716 = true
                                break
                            end
                        end
                        if not check2716 then
                            if string.find(v.Name,"kg") then
                                if AutoEvent.Value then
                                    if string.find(string.lower(v.Name),"pollinated") then
                                        check2717 = true
                                    end
                                end
                                if not check2717 then
                                    v.Parent = character
                                end
                                task.wait(0.01)
                            end
                        end
                    end
                    local hrppos1 = hrp.Position
                    hrp.CFrame = CFrame.new(sell)
                    wait(0.5)
                    sellitem:FireServer()
                    wait(0.5)
                    hrp.CFrame = CFrame.new(hrppos1)
                    issell = false
            end
        end
        task.wait(0.25)
    end
end)
task.spawn(function()
    while true do
        if AutoBuySeeds.Value then
            for _, seed in ipairs(selectedSeeds) do
                BuySeedStock:FireServer(seed)
            end
        end
        task.wait(0.25)
    end
end)
task.spawn(function()
    while true do
        if AutoBuyGears.Value then
            for _, gear in ipairs(selectedGears) do
                BuyGearStock:FireServer(gear)
            end
        end
        task.wait(0.25)
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
