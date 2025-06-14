local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Input = {}

local CurrentInputsDown = {}
local JustPressedInputs = {}
local JustReleasedInputs = {}

local MouseWheelDelta = 0

local InputActions = {}
local InputConnections = {}

local function ConnectInputAction(ActionName, InputAction)
	local PressedConn = InputAction.Pressed:Connect(function()
		if not CurrentInputsDown[ActionName] then
			JustPressedInputs[ActionName] = true
		end
		CurrentInputsDown[ActionName] = true
	end)

	local ReleasedConn = InputAction.Released:Connect(function()
		CurrentInputsDown[ActionName] = false
		JustReleasedInputs[ActionName] = true
	end)

	InputConnections[ActionName] = {PressedConn, ReleasedConn}
end

local function DisconnectInputAction(ActionName)
	if InputConnections[ActionName] then
		for _, Conn in ipairs(InputConnections[ActionName]) do
			Conn:Disconnect()
		end
		InputConnections[ActionName] = nil
	end
end

for _, Context in ipairs(script:GetChildren()) do
	if Context:IsA("InputContext") then
		for _, InputAction in ipairs(Context:GetChildren()) do
			if InputAction:IsA("InputAction") then
				local ActionName = InputAction.Name
				InputActions[ActionName] = InputAction
				ConnectInputAction(ActionName, InputAction)
			end
		end
	end
end

UserInputService.InputChanged:Connect(function(InputObj)
	if InputObj.UserInputType == Enum.UserInputType.MouseWheel then
		MouseWheelDelta = InputObj.Position.Z
	end
end)

local LastMousePosition = UserInputService:GetMouseLocation()
local MouseDelta = Vector2.new(0, 0)

RunService.RenderStepped:Connect(function()
	for ActionName in pairs(JustPressedInputs) do
		JustPressedInputs[ActionName] = false
	end
	for ActionName in pairs(JustReleasedInputs) do
		JustReleasedInputs[ActionName] = false
	end

	local CurrentMousePosition = UserInputService:GetMouseLocation()
	MouseDelta = CurrentMousePosition - LastMousePosition
	LastMousePosition = CurrentMousePosition

	MouseWheelDelta = 0
end)

function Input.RebindAction(ActionName, BindingName, NewInput)
	local InputAction = InputActions[ActionName]
	local TargetBinding = InputAction:FindFirstChild(BindingName)
	if NewInput.EnumType == Enum.KeyCode then
		TargetBinding.KeyCode = NewInput
	end
end



function Input.IsActionJustPressed(ActionName)
	return JustPressedInputs[ActionName] == true
end

function Input.IsActionPressed(ActionName)
	return CurrentInputsDown[ActionName] == true
end

function Input.IsActionJustReleased(ActionName)
	return JustReleasedInputs[ActionName] == true
end

function Input.GetAxis(NegAction, PosAction)
	local Pos = Input.IsActionPressed(PosAction) and 1 or 0
	local Neg = Input.IsActionPressed(NegAction) and 1 or 0
	return Pos - Neg
end

function Input.GetVector(NegX, PosX, NegY, PosY)
	return Vector2.new(
		Input.GetAxis(NegX, PosX),
		Input.GetAxis(NegY, PosY)
	)
end

function Input.IsAnyPressed()
	if #UserInputService:GetKeysPressed() > 0 then
		return true
	end
	if #UserInputService:GetMouseButtonsPressed() > 0 then
		return true
	end
	return false
end

function Input.IsKeyPressed(KeyCode)
	return UserInputService:IsKeyDown(KeyCode)
end

function Input.IsMouseButtonPressed(ButtonEnum)
	return UserInputService:IsMouseButtonPressed(ButtonEnum)
end

function Input.GetMousePosition()
	return UserInputService:GetMouseLocation()
end

function Input.GetMouseDelta()
	return MouseDelta
end

function Input.GetMouseWheelDelta()
	return MouseWheelDelta
end

function Input.GetDeviceAcceleration()
	return UserInputService:GetDeviceAcceleration().Position
end

function Input.GetDeviceGravity()
	return UserInputService:GetDeviceGravity().Position
end

function Input.GetDeviceRotation()
	return UserInputService:GetDeviceRotation().Position
end

return Input
