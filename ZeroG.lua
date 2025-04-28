local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ToggleGui"
toggleGui.ResetOnSpawn = false
toggleGui.Parent = game.CoreGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -20)
toggleBtn.Text = "Toggle GUI"
toggleBtn.BackgroundColor3 = Color3.fromRGB(53, 93, 137)
toggleBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.ZIndex = 2
toggleBtn.Parent = toggleGui

local toggleBtnBorder = Instance.new("UIStroke")
toggleBtnBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleBtnBorder.Thickness = 2
toggleBtnBorder.Color = Color3.fromRGB(255, 255, 255)
toggleBtnBorder.Parent = toggleBtn

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZEROGRAVITYBYKONJINGHUB"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(63, 102, 150)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Active = true
frame.Draggable = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

local frameBorder = Instance.new("UIStroke")
frameBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
frameBorder.Thickness = 3
frameBorder.Color = Color3.fromRGB(255, 255, 255)
frameBorder.Parent = frame

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "ZERO GRAVITY BY KONJINGHUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local titleBorder = Instance.new("Frame")
titleBorder.Size = UDim2.new(1, 0, 0, 3)
titleBorder.Position = UDim2.new(0, 0, 0, 25)
titleBorder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleBorder.BorderSizePixel = 0
titleBorder.Parent = frame

local titleFrameCorner = Instance.new("UICorner")
titleFrameCorner.CornerRadius = UDim.new(0, 12)
titleFrameCorner.Parent = titleBorder

local zeroGBtn = Instance.new("TextButton")
zeroGBtn.Size = UDim2.new(1, 0, 0, 50)
zeroGBtn.Position = UDim2.new(0, 0, 0, 30)
zeroGBtn.Text = "Toggle 0G"
zeroGBtn.BackgroundColor3 = Color3.fromRGB(53, 93, 137)
zeroGBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
zeroGBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
zeroGBtn.Font = Enum.Font.SourceSansBold
zeroGBtn.TextSize = 16
zeroGBtn.ZIndex = 2
zeroGBtn.Parent = frame

local isGuiVisible = true

local function toggleGui()
    isGuiVisible = not isGuiVisible
    screenGui.Enabled = isGuiVisible
end

toggleBtn.MouseButton1Click:Connect(toggleGui)

local slowBouncePush = 1
local fastBouncePush = 0.05
local speedThreshold = 5
local bounceSoundId = "rbxassetid://7547210322"

local active = false
local touchConnections = {}

local function setupBounce(part)
    local function onTouched(hit)
        if not hit:IsA("BasePart") then return end

        if not hrp or not hrp.Parent then return end

        local sound = Instance.new("Sound")
        sound.SoundId = bounceSoundId
        sound.Volume = 1
        sound.Parent = hrp
        sound:Play()
        Debris:AddItem(sound, 2)

        local currentSpeed = hrp.Velocity.Magnitude
        local bounceStrength = currentSpeed <= speedThreshold and slowBouncePush or fastBouncePush
        local direction = (hrp.Position - hit.Position).Unit

        hrp.Velocity = hrp.Velocity + (direction * bounceStrength)
    end

    local connection = part.Touched:Connect(onTouched)
    table.insert(touchConnections, connection)
end

local function enableZeroGravity()
    if not character or not humanoid or not hrp then return end

    humanoid.PlatformStand = true
    workspace.Gravity = 0

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Massless = true
            part.CanCollide = true
            setupBounce(part)
        end
    end
end

local function disableZeroGravity()
    if not character or not humanoid then return end

    humanoid.PlatformStand = false
    workspace.Gravity = 196.2

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Massless = false
            part.CanCollide = true
        end
    end

    for _, conn in ipairs(touchConnections) do
        conn:Disconnect()
    end
    table.clear(touchConnections)
end

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
end)

zeroGBtn.MouseButton1Click:Connect(function()
    active = not active

    if active then
        enableZeroGravity()
        zeroGBtn.Text = "ZEROG ENABLED"
    else
        disableZeroGravity()
        zeroGBtn.Text = "ZEROG DISABLED"
    end
end)