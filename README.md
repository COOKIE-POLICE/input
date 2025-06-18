
---

## Best Input Library for Roblox (No Bias)

**Author:** bennyuiuy

GODOTTT!!!!! As a Godot developer that migrated to Roblox very recently, I created this library to handle inputs in Roblox in a Godot-like fashion because my tiny brain cannot handle inputs in a Robloxian way.

---

## Table of Contents... If You're That Lazy
- [Best Input Library for Roblox (No Bias)](#best-input-library-for-roblox-no-bias)
- [Table of Contents... If You're That Lazy](#table-of-contents-if-youre-that-lazy)
- [Why Use This Over `UserInputService`?](#why-use-this-over-userinputservice)
- [How To Use This?](#how-to-use-this)
	- [Setup](#setup)
- [Loading the Module](#loading-the-module)
- [Most Important Stuff](#most-important-stuff)
	- [Check if an action is continuously pressed:](#check-if-an-action-is-continuously-pressed)
	- [Check for a one-time press:](#check-for-a-one-time-press)
	- [Check for a one-time release:](#check-for-a-one-time-release)
- [Axis and Vector Inputs](#axis-and-vector-inputs)
- [Mouse Inputs](#mouse-inputs)
- [Device Data](#device-data)
- [Rebinding Actions](#rebinding-actions)
- [Check if Any Input is Pressed](#check-if-any-input-is-pressed)
- [Cheatsheet](#cheatsheet)
- [Testimonials](#testimonials)

---

## Why Use This Over `UserInputService`?

You might be asking. Why would anyone use this over the original Roblox UserInputService?  
Well, in my totally and absolutely unbiased opinion this library, module or whatever you wanna call it, is way easier to use.  
1. It is very Godot-like, do I need to say more?  
2. It allows you to detect Input Actions easily (Roblox Beta Feature).  
3. It correctly gets the physical mouse delta. In my tests, I saw that the built-in mouse delta only changes when camera moves.  
4. It allows a easier way to get device rotation, acceleration and gravity.  
5. It allows an easier way to get mouse scroll delta.  
6. Yap, yap and blah... some other things that I am too lazy to include.

---

## How To Use This?

### Setup

Place your `InputContext`, `InputAction`, and `InputBinding` instances inside this module script.

**Example Structure:**

```

InputModule
├─ InputContext (instance of InputContext)
│    ├─ MoveLeft (InputAction)
│    │    └─ KeyboardBinding (InputBinding)
│    ├─ MoveRight (InputAction)
│    │    └─ KeyboardBinding (InputBinding)
│    └─ Jump (InputAction)
│         └─ KeyboardBinding (InputBinding)

````

---

## Loading the Module

```lua
local Input = require(path.to.InputModule)
````

---

## Most Important Stuff

### Check if an action is continuously pressed:

```lua
if Input.IsActionPressed("Jump") then
	print("Jumping!")
end
```

### Check for a one-time press:

```lua
if Input.IsActionJustPressed("Fire") then
	print("Fire button was just pressed")
end
```

### Check for a one-time release:

```lua
if Input.IsActionJustReleased("Fire") then
	print("Fire button was just released")
end
```

---

## Axis and Vector Inputs

Use for movement or directional input:

```lua
local moveX = Input.GetAxis("MoveLeft", "MoveRight")
local moveY = Input.GetAxis("MoveDown", "MoveUp")

local moveVector = Input.GetVector("MoveLeft", "MoveRight", "MoveDown", "MoveUp")
```

---

## Mouse Inputs

```lua
local mousePos = Input.GetMousePosition()
local mouseDelta = Input.GetMouseDelta()
local scrollDelta = Input.GetMouseWheelDelta()
```

---

## Device Data

```lua
local acceleration = Input.GetDeviceAcceleration()
local gravity = Input.GetDeviceGravity()
local rotation = Input.GetDeviceRotation()
```

---

## Rebinding Actions

```lua
Input.RebindAction("Jump", "KeyboardBinding", Enum.KeyCode.Space)
```

---

## Check if Any Input is Pressed

```lua
if Input.IsAnyPressed() then
	print("Some input is being held down")
end
```

---

## Cheatsheet 
There are more methods to come... when I am not too lazy.
| Method                               | Description                                                         | Returns   | Use Case                                      |
| ------------------------------------ | ------------------------------------------------------------------- | --------- | --------------------------------------------- |
| `IsActionPressed(name)`              | Checks if an InputAction is currently held.                         | `bool`    | Detecting if a specific action is being held. |
| `IsActionJustPressed(name)`          | Checks if an InputAction was pressed this frame.                    | `bool`    | Trigger something once when pressed.          |
| `IsActionJustReleased(name)`         | Checks if an InputAction was released this frame.                   | `bool`    | Trigger something once when released.         |
| `IsAnyPressed()`                     | Checks if **any input** is being pressed.                           | `bool`    | Detect when *anything* is currently pressed.  |
| `GetAxis(negAction, posAction)`      | Returns `-1`, `0`, or `1` based on negative/positive action states. | `number`  | Horizontal/vertical directional input.        |
| `GetVector(negX, posX, negY, posY)`  | Returns a `Vector2` from direction pairs.                           | `Vector2` | Movement or aiming input.                     |
| `GetMousePosition()`                 | Current mouse position on screen.                                   | `Vector2` | For UIs or custom mouse systems.              |
| `GetMouseDelta()`                    | Mouse movement delta since last frame.                              | `Vector2` | For look or aim control.                      |
| `GetMouseWheelDelta()`               | Scroll wheel delta (resets each frame).                             | `number`  | Scroll actions or zoom systems.               |
| `IsKeyPressed(KeyCode)`              | Continuously check if a key is pressed.                             | `bool`    | For inputs not tied to InputActions.          |
| `IsMouseButtonPressed(Button)`       | Check if a mouse button is pressed.                                 | `bool`    | For direct mouse input checks.                |
| `GetDeviceAcceleration()`            | Returns current device acceleration vector.                         | `Vector3` | Mobile tilting controls.                      |
| `GetDeviceGravity()`                 | Returns device gravity vector.                                      | `Vector3` | Detect device orientation.                    |
| `GetDeviceRotation()`                | Returns device rotation vector.                                     | `Vector3` | Advanced motion control.                      |
| `RebindAction(name, binding, input)` | Change the input binding for an action.                             | `void`    | Allow rebinding keys in your game.            |


---

## Testimonials

bennyuiuy: "As someone who is definitely not the author of this library, I can safely say that this is the best input library I ever used on Roblox. This feels super Godoty."

---