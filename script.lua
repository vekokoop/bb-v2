-- Blockspin Master Hub V6.0 (Full UI + Ghost Farm + Combat)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local GUI_Parent = gethui and gethui() or CoreGui
if GUI_Parent:FindFirstChild("BlockspinMasterHub") then GUI_Parent.BlockspinMasterHub:Destroy() end

-- ==========================================
-- 1. الإعدادات
-- ==========================================
local Settings = {
    AimbotEnabled = false,
    ESPEnabled = false,
    AutoFarmATM = false,
    FOVSize = 100,
    Smoothness = 5,
    AimKey = Enum.UserInputType.MouseButton2
}

local AtmPositions = {
    Vector3.new(-132.2, 258.5, 106.9),
    Vector3.new(-156.8, 258.5, 442.9),
    Vector3.new(68.4, 265.1, 44.0),
    Vector3.new(90.7, 258.7, 166.4),
    Vector3.new(109.7, 258.5, 463.5)
}

-- ==========================================
-- 2. بناء الواجهة (UI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlockspinMasterHub"
ScreenGui.Parent = GUI_Parent
ScreenGui.ResetOnSpawn = false

-- الأيقونة العائمة
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
FloatingIcon.Position = UDim2.new(0, 35, 0, 150)
FloatingIcon.Size = UDim2.new(0, 55, 0, 55)
FloatingIcon.Font = Enum.Font.SourceSansBold
FloatingIcon.Text = "🔥"
FloatingIcon.TextColor3 = Color3.fromRGB(255, 165, 0)
FloatingIcon.TextSize = 28

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 165, 0)
IconStroke.Thickness = 2.5
IconStroke.Parent = FloatingIcon

-- القائمة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -230)
MainFrame.Size = UDim2.new(0, 420, 0, 460)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 165, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.Size = UDim2.new(1, 0, 0, 50)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "BLOCKSPIN | Master Hub"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseXBtn = Instance.new("TextButton")
CloseXBtn.Parent = TopBar
CloseXBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseXBtn.Position = UDim2.new(1, -40, 0.5, -14)
CloseXBtn.Size = UDim2.new(0, 28, 0, 28)
CloseXBtn.Font = Enum.Font.SourceSansBold
CloseXBtn.Text = "X"
CloseXBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseXBtn.TextSize = 14
CloseXBtn.AutoButtonColor = false

local XCorner = Instance.new("UICorner")
XCorner.CornerRadius = UDim.new(1, 0)
XCorner.Parent = CloseXBtn

local TabsBar = Instance.new("Frame")
TabsBar.Parent = MainFrame
TabsBar.BackgroundTransparency = 1
TabsBar.Position = UDim2.new(0, 10, 0, 60)
TabsBar.Size = UDim2.new(1, -20, 0, 35)

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Parent = TabsBar
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 8)

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 10, 0, 100)
ContentContainer.Size = UDim2.new(1, -20, 1, -110)

local tabs = {}
local function createTabContent(name)
    local scrolling = Instance.new("ScrollingFrame")
    scrolling.Name = name .. "Content"
    scrolling.Parent = ContentContainer
    scrolling.BackgroundTransparency = 1
    scrolling.Size = UDim2.new(1, 0, 1, 0)
    scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrolling.ScrollBarThickness = 4
    scrolling.Visible = false

    local list = Instance.new("UIListLayout")
    list.Parent = scrolling
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 10)
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrolling.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15)
    end)
    return scrolling
end

local function createTabButton(name, iconText)
    local btn = Instance.new("TextButton")
    btn.Parent = TabsBar
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = iconText .. " " .. name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.TextSize = 13
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Thickness = 1
    stroke.Parent = btn

    local content = createTabContent(name)

    btn.Activated:Connect(function()
        for _, t in pairs(tabs) do
            t.content.Visible = false
            t.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            t.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.stroke.Color = Color3.fromRGB(45, 45, 60)
        end
        content.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        btn.TextColor3 = Color3.fromRGB(255, 165, 0)
        stroke.Color = Color3.fromRGB(255, 165, 0)
    end)

    tabs[name] = {btn = btn, content = content, stroke = stroke}
    return content
end

local combatTab = createTabButton("Combat", "🎯")
local visualsTab = createTabButton("Visuals", "👁️")
local utilityTab = createTabButton("Utility", "📦")
tabs["Combat"].content.Visible = true
tabs["Combat"].btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
tabs["Combat"].btn.TextColor3 = Color3.fromRGB(255, 165, 0)
tabs["Combat"].stroke.Color = Color3.fromRGB(255, 165, 0)

local function createFeatureToggle(parentTab, name, desc, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parentTab
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    btn.Size = UDim2.new(0.95, 0, 0, 50)
    btn.Text = ""
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Thickness = 1.2
    stroke.Parent = btn

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 15, 0, 8)
    nameLabel.Size = UDim2.new(0.7, 0, 0, 16)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = btn
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 15, 0, 26)
    descLabel.Size = UDim2.new(0.7, 0, 0, 16)
    descLabel.Font = Enum.Font.SourceSans
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left

    local statusBox = Instance.new("Frame")
    statusBox.Parent = btn
    statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    statusBox.Position = UDim2.new(1, -40, 0.5, -12)
    statusBox.Size = UDim2.new(0, 24, 0, 24)

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = statusBox

    local state = false
    btn.Activated:Connect(function()
        state = not state
        if state then
            statusBox.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
            stroke.Color = Color3.fromRGB(255, 165, 0)
        else
            statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            stroke.Color = Color3.fromRGB(45, 45, 60)
        end
        callback(state)
    end)
    return btn
end

local function createFovControl(parentTab, labelText, onMinus, onPlus)
    local frame = Instance.new("Frame")
    frame.Parent = parentTab
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Size = UDim2.new(0.95, 0, 0, 45)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Thickness = 1.2
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Font = Enum.Font.SourceSansBold
    label.Text = labelText .. ": " .. Settings.FOVSize
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local minusBtn = Instance.new("TextButton")
    minusBtn.Parent = frame
    minusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    minusBtn.Position = UDim2.new(1, -80, 0.5, -12)
    minusBtn.Size = UDim2.new(0, 28, 0, 24)
    minusBtn.Font = Enum.Font.SourceSansBold
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.TextSize = 18
    local mCorner = Instance.new("UICorner"); mCorner.CornerRadius = UDim.new(0, 6); mCorner.Parent = minusBtn
    
    local plusBtn = Instance.new("TextButton")
    plusBtn.Parent = frame
    plusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    plusBtn.Position = UDim2.new(1, -45, 0.5, -12)
    plusBtn.Size = UDim2.new(0, 28, 0, 24)
    plusBtn.Font = Enum.Font.SourceSansBold
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.TextSize = 18
    local pCorner = Instance.new("UICorner"); pCorner.CornerRadius = UDim.new(0, 6); pCorner.Parent = plusBtn

    minusBtn.Activated:Connect(function()
        local newVal = onMinus()
        label.Text = labelText .. ": " .. tostring(math.floor(newVal))
    end)
    plusBtn.Activated:Connect(function()
        local newVal = onPlus()
        label.Text = labelText .. ": " .. tostring(math.floor(newVal))
    end)
    return frame
end

-- ==========================================
-- 3. ربط الأزرار بالمنطق
-- ==========================================
createFeatureToggle(combatTab, "Aimbot", "قفل الكاميرا (Lerp)", function(enabled) Settings.AimbotEnabled = enabled end)
createFeatureToggle(visualsTab, "ESP", "مربعات وأسماء اللاعبين", function(enabled) Settings.ESPEnabled = enabled end)
createFeatureToggle(utilityTab, "Auto Farm (Ghost)", "طيران تحت الأرض + اختفاء", function(enabled) 
    Settings.AutoFarmATM = enabled 
    if not enabled then SetGhostMode(false) end
end)

createFovControl(combatTab, "Aimbot FOV", 
    function() Settings.FOVSize = math.max(20, Settings.FOVSize - 10); FOVCircle.Radius = Settings.FOVSize; return Settings.FOVSize end,
    function() Settings.FOVSize = math.min(600, Settings.FOVSize + 10); FOVCircle.Radius = Settings.FOVSize; return Settings.FOVSize end
)

-- ==========================================
-- 4. دوائر الـ FOV والـ Aimbot
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Transparency = 0.6
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 165, 0)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.FOVSize

local function GetClosestTarget()
    local target = nil
    local shortestDist = Settings.FOVSize
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local hrp = player.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        target = player.Character.Head
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Settings.FOVSize

    if Settings.AimbotEnabled and UserInputService:IsMouseButtonPressed(Settings.AimKey) then
        local targetHead = GetClosestTarget()
        if targetHead then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / Settings.Smoothness)
        end
    end
end)

-- ==========================================
-- 5. نظام ESP
-- ==========================================
local espCache = {}
local function CreateESP(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Visible = false; box.Color = Color3.fromRGB(255, 50, 50); box.Thickness = 1; box.Filled = false

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false; nameTag.Color = Color3.fromRGB(255, 255, 255); nameTag.Size = 12; nameTag.Center = true; nameTag.Outline = true

    espCache[player] = {Box = box, Name = nameTag}

    player.CharacterRemoving:Connect(function()
        box.Visible = false; nameTag.Visible = false
    end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(p)
    if espCache[p] then espCache[p].Box:Remove(); espCache[p].Name:Remove(); espCache[p] = nil end
end)

RunService.RenderStepped:Connect(function()
    if not Settings.ESPEnabled then
        for _, data in pairs(espCache) do data.Box.Visible = false; data.Name.Visible = false end
        return
    end

    for player, data in pairs(espCache) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local hrp = char.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2

                data.Box.Size = Vector2.new(width, height)
                data.Box.Position = Vector2.new(vector.X - width / 2, headPos.Y)
                data.Box.Visible = true

                data.Name.Text = player.Name
                data.Name.Position = Vector2.new(vector.X, headPos.Y - 16)
                data.Name.Visible = true
            else
                data.Box.Visible = false; data.Name.Visible = false
            end
        else
            data.Box.Visible = false; data.Name.Visible = false
        end
    end
end)

-- ==========================================
-- 6. الأوتو فارم + Ghost Mode
-- ==========================================
local function SetGhostMode(isGhost)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if isGhost then part.LocalTransparencyModifier = 1 else part.LocalTransparencyModifier = 0 end
        end
    end
end

task.spawn(function()
    while task.wait(3) do
        if Settings.AutoFarmATM then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local hrp = char.HumanoidRootPart

                SetGhostMode(true) -- تفعيل الاختفاء

                for _, atmPos in ipairs(AtmPositions) do
                    if not Settings.AutoFarmATM then break end
                    
                    hrp.CanCollide = false
                    hrp.CFrame = CFrame.new(atmPos + Vector3.new(0, -4, 0))
                    task.wait(0.5)

                    local params = OverlapParams.new()
                    params.FilterDescendantsInstances = {char}
                    params.FilterType = Enum.RaycastFilterType.Exclude
                    
                    local partsNear = Workspace:GetPartBoundsInRadius(atmPos, 15, params)
                    for _, part in pairs(partsNear) do
                        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            pcall(function() fireproximityprompt(prompt) end)
                            break
                        end
                    end
                    
                    hrp.CanCollide = true
                    task.wait(2)
                end
                
                if not Settings.AutoFarmATM then SetGhostMode(false) end
            end
        else
            SetGhostMode(false)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Settings.AutoFarmATM then SetGhostMode(true) else SetGhostMode(false) end
end)

-- ==========================================
-- 7. تحريك الأيقونة والواجهة
-- ==========================================
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = FloatingIcon.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local function toggleMenu() MainFrame.Visible = not MainFrame.Visible end
FloatingIcon.Activated:Connect(toggleMenu)
CloseXBtn.Activated:Connect(toggleMenu)

print("Blockspin Master Hub V6.0 (Full UI + Ghost) Loaded Successfully!")
