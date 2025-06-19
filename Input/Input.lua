local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Input = {}

local CurrentActionsDown = {}
local JustPressedActions = {}
local JustReleasedActions = {}

local KeysDown = {}
local KeysJustPressed = {}

local MouseWheelDelta = 0
local MouseDelta = Vector2.new(0, 0)
local LastMousePosition = UserInputService:GetMouseLocation()

local InputActions = {}
local InputConnections = {}
local CustomActions = {}

local function ConnectInputAction(ActionName, InputAction)
	local PressedConn = InputAction.Pressed:Connect(function()
		if not CurrentActionsDown[ActionName] then
			JustPressedActions[ActionName] = true
		end
		CurrentActionsDown[ActionName] = true
	end)

	local ReleasedConn = InputAction.Released:Connect(function()
		CurrentActionsDown[ActionName] = false
		JustReleasedActions[ActionName] = true
	end)

	InputConnections[ActionName] = {PressedConn, ReleasedConn}
end

local function DisconnectInputAction(ActionName)
	local Connections = InputConnections[ActionName]
	if Connections then
		for _, Connection in ipairs(Connections) do
			Connection:Disconnect()
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

UserInputService.InputBegan:Connect(function(InputObject, IsProcessed)
	if InputObject.UserInputType == Enum.UserInputType.Keyboard and not IsProcessed then
		local Key = InputObject.KeyCode
		if not KeysDown[Key] then
			KeysJustPressed[Key] = true
		end
		KeysDown[Key] = true
	end
end)

UserInputService.InputEnded:Connect(function(InputObject)
	if InputObject.UserInputType == Enum.UserInputType.Keyboard then
		KeysDown[InputObject.KeyCode] = false
	end
end)

UserInputService.InputChanged:Connect(function(InputObject)
	if InputObject.UserInputType == Enum.UserInputType.MouseWheel then
		MouseWheelDelta = InputObject.Position.Z
	end
end)

RunService.RenderStepped:Connect(function()
	for ActionName in pairs(JustPressedActions) do
		JustPressedActions[ActionName] = false
	end
	for ActionName in pairs(JustReleasedActions) do
		JustReleasedActions[ActionName] = false
	end
	for Key in pairs(KeysJustPressed) do
		KeysJustPressed[Key] = false
	end

	for ActionName, CustomAction in pairs(CustomActions) do
		local AllKeysDown = true
		for _, KeyCode in ipairs(CustomAction.KeyCodes) do
			if not KeysDown[KeyCode] then
				AllKeysDown = false
				break
			end
		end

		if AllKeysDown and not CustomAction.IsPressed then
			CustomAction.IsPressed = true
			JustPressedActions[ActionName] = true
			CurrentActionsDown[ActionName] = true
		elseif not AllKeysDown and CustomAction.IsPressed then
			CustomAction.IsPressed = false
			JustReleasedActions[ActionName] = true
			CurrentActionsDown[ActionName] = false
		end
	end

	local CurrentMousePosition = UserInputService:GetMouseLocation()
	MouseDelta = CurrentMousePosition - LastMousePosition
	LastMousePosition = CurrentMousePosition

	MouseWheelDelta = 0
end)

function Input.AddAction(ActionName, KeyCodes)
	assert(type(ActionName) == "string", "ActionName must be a string")
	assert(type(KeyCodes) == "table", "KeyCodes must be a table of Enum.KeyCode values")
	assert(not InputActions[ActionName], "Cannot override an existing InputAction")

	CustomActions[ActionName] = {
		KeyCodes = KeyCodes,
		IsPressed = false,
	}
end

function Input.RebindAction(ActionName, BindingName, NewInput)
	local InputAction = InputActions[ActionName]
	if not InputAction then return end
	local Binding = InputAction:FindFirstChild(BindingName)
	if Binding and NewInput.EnumType == Enum.KeyCode then
		Binding.KeyCode = NewInput
	end
end

function Input.IsActionPressed(ActionName)
	return CurrentActionsDown[ActionName] == true
end

function Input.IsActionJustPressed(ActionName)
	return JustPressedActions[ActionName] == true
end

function Input.IsActionJustReleased(ActionName)
	return JustReleasedActions[ActionName] == true
end

function Input.IsKeyJustPressed(KeyCode)
	return KeysJustPressed[KeyCode] == true
end

function Input.GetAxis(NegativeAction, PositiveAction)
	return (Input.IsActionPressed(PositiveAction) and 1 or 0) - (Input.IsActionPressed(NegativeAction) and 1 or 0)
end

function Input.GetVector(NegativeX, PositiveX, NegativeY, PositiveY)
	return Vector2.new(
		Input.GetAxis(NegativeX, PositiveX),
		Input.GetAxis(NegativeY, PositiveY)
	)
end

function Input.IsAnyPressed()
	return #UserInputService:GetKeysPressed() > 0 or #UserInputService:GetMouseButtonsPressed() > 0
end

function Input.IsKeyPressed(KeyCode)
	return UserInputService:IsKeyDown(KeyCode)
end

function Input.IsMouseButtonPressed(MouseButton)
	return UserInputService:IsMouseButtonPressed(MouseButton)
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
