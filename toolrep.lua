-- Create the ScreenGUI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false -- Keep the GUI on screen after reset
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the draggable frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 200)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
mainFrame.Parent = screenGui

-- Make the frame draggable
local dragging
local dragStart
local startPos

-- Function to start dragging the GUI
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

-- Function to handle dragging movement
mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Function to stop dragging
mainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Create the Brick button
local Brick = Instance.new("TextButton")
Brick.Name = "Brick"
Brick.Parent = mainFrame
Brick.BackgroundColor3 = Color3.new(0.137255, 0.509804, 1)
Brick.Position = UDim2.new(0.1, 0, 0.2, 0)
Brick.Size = UDim2.new(0, 200, 0, 50)
Brick.Font = Enum.Font.Cartoon
Brick.Text = "Brick Spam"
Brick.TextColor3 = Color3.new(0, 0, 0)
Brick.TextSize = 30

-- Variables to control the spam
local isSpamming = false
local runConnection

-- Start/stop function
local function startStopSpamming()
	if isSpamming then
		isSpamming = false
		if runConnection then
			runConnection:Disconnect()
			runConnection = nil
		end
		Brick.Text = "Start Brick Spam"
	else
		isSpamming = true
		Brick.Text = "Stop Brick Spam"
		runConnection = game:GetService('RunService').Stepped:Connect(function()
			for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				if v.Name == "Spray" then
					if v.Handle and v.Handle:FindFirstChild("Mesh") then
						v.Handle.Mesh:Destroy()
					end
					v.Parent = workspace
				end
			end
		end)

		local function paint()
			for _, v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "Handle" then
					v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
					v.Transparency = 1
					v.CanCollide = false
					wait()
					v.CFrame = game.Players.LocalPlayer.Character["Left Leg"].CFrame
				end
			end
		end

		local function equip()
			for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
				if v.Name == "Spray" then
					game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
				end
			end
		end

		while isSpamming do
			paint()
			equip()
			wait(0.05)
		end
	end
end

-- Connect the button to the start/stop function
Brick.MouseButton1Down:Connect(startStopSpamming)
