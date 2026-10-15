## ErrorPrompt Documentation

### Installation

Load the module from the provided URL using `loadstring`:

```lua
loadstring(game:HttpGet("https://darahub.pages.dev/Module/Library/GUI/ErrorPrompt.lua"))()
```

It is also loaded automatically by `LoadAll.lua`. After loading, the following globals are available:

| Global | Description |
|--------|-------------|
| `ShowErrorPrompt(data)` | Shows the prompt. |
| `ErrorPrompt` | The prompt object, used for `ErrorPrompt:configure({...})`. |

They are set on `getgenv()`, so you can call them directly by name, without writing `getgenv()`.

Loading the module twice is safe: if `ShowErrorPrompt` already exists, the second load does nothing.

### Overview

`ShowErrorPrompt` shows a Roblox-style error window (title, message, optional icon and buttons) inside `CoreGui.RobloxGui`. Only one prompt exists at a time; calling it again while it is open replaces the content.

```lua
-- Minimal call. Only Title is really needed.
ShowErrorPrompt({
    Title = "Something went wrong",
})

-- Full call with every field a typical prompt uses.
ShowErrorPrompt({
    Title = "Session Expired",
    Message = "Your session token is no longer valid. Please rejoin the server.",
    Code = 401,
    Icon = "clock",
    IconOrder = "Top",
    IconSize = 28,
    IconColor = Color3.fromRGB(255, 200, 120),
    TitleTextSize = 24,
    MessageTextSize = 18,
    Options = {
        CornerRadius = 10,
        Animation = true,
        Overlay = true,
        OverlayTransparency = 0.6,
    },
    Buttons = {
        { Text = "Dismiss", Type = "Ghost" },
        { Text = "Rejoin", Type = "Primary", Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end },
    },
})
```

### Basic Syntax

```lua
ShowErrorPrompt({
    Title = "Reset Character",
    Message = "Are you sure you want to reset your character?",
    Buttons = {
        { Text = "Cancel", Type = "Secondary", Stroke = true },
        {
            Text = "Reset",
            Type = "Primary",
            WaitTimeClick = 5,
            Callback = function()
                local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum.Health = 0 end
            end,
        },
    },
})
```

### Data Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Title` | `string` | `""` | Title text. |
| `Message` (or `Desc` / `Description`) | `string` | `""` | Main message. |
| `Code` | `any` | `nil` | If set, `(Error Code: X)` is added under the message. |
| `Icon` | `string` | `nil` | `rbxassetid://` or `rbxasset://` path, an `http(s)://` URL, or a BuilderIcons name such as `"clock"`. |
| `IconOrder` | `string` | `"Bottom"` | `"Top"` or `"Bottom"`, relative to the title. |
| `IconSize` | `number` or `UDim2` | `30` | Icon size. A number gives a square. |
| `IconColor` | `Color3` | white | Icon tint. |
| `TitleTextSize` | `number` | `25` | Title font size. |
| `MessageTextSize` (or `DescTextSize`) | `number` | `20` | Message font size. |
| `Buttons` | `table` | `nil` | List of button tables. With no buttons, no button row is shown. |
| `Options` | `table` | `nil` | Window options, see below. |

Examples:

```lua
-- Title only. No message, no icon, no buttons.
ShowErrorPrompt({ Title = "Done" })

-- Message set three equivalent ways.
ShowErrorPrompt({ Title = "Oops", Message = "Something failed." })
ShowErrorPrompt({ Title = "Oops", Desc = "Something failed." })
ShowErrorPrompt({ Title = "Oops", Description = "Something failed." })

-- Error code appended under the message.
ShowErrorPrompt({
    Title = "Request Failed",
    Message = "The server rejected the request.",
    Code = 403,
})
-- Renders as:
--   The server rejected the request.
--   (Error Code: 403)

-- Icon as a Roblox asset id.
ShowErrorPrompt({
    Title = "Warning",
    Icon = "rbxassetid://1234567890",
})

-- Icon as an http URL. Requires executor HTTP functions.
ShowErrorPrompt({
    Title = "Warning",
    Icon = "https://example.com/icon.png",
})

-- Icon as a BuilderIcons glyph name.
ShowErrorPrompt({
    Title = "Warning",
    Icon = "clock",
    IconOrder = "Top",
    IconSize = 32,
    IconColor = Color3.fromRGB(255, 180, 80),
})

-- Icon size as UDim2 instead of a number.
ShowErrorPrompt({
    Title = "Warning",
    Icon = "clock",
    IconSize = UDim2.fromOffset(48, 24),
})

-- Custom font sizes.
ShowErrorPrompt({
    Title = "Big Warning",
    Message = "Small footnote.",
    TitleTextSize = 32,
    MessageTextSize = 14,
})
-- DescTextSize is an alias for MessageTextSize.
ShowErrorPrompt({
    Title = "Big Warning",
    Message = "Small footnote.",
    TitleTextSize = 32,
    DescTextSize = 14,
})

-- No buttons at all. The row is hidden entirely.
ShowErrorPrompt({ Title = "Info", Message = "No action needed." })
```

### Text Colors

Every text element can be recolored, either globally through `Options` / `ErrorPrompt:configure`, per-prompt through data keys, or at runtime through the prompt's methods.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `TitleColor` | `Color3` | white | Title text color. |
| `MessageColor` | `Color3` | pumice | Message text color. |
| `BackgroundColor` | `Color3` | flint | Window background color. |
| `SplitColor` | `Color3` | pumice | Color of the divider line between title and message. |

Per-prompt:

```lua
ShowErrorPrompt({
    Title = "Warning",
    Message = "Something needs your attention.",
    TitleColor = Color3.fromRGB(255, 120, 120),
    MessageColor = Color3.fromRGB(255, 200, 200),
    BackgroundColor = Color3.fromRGB(30, 30, 40),
    SplitColor = Color3.fromRGB(255, 120, 120),
    Buttons = {
        { Text = "OK", Type = "Primary" },
    },
})
```

Via `Options`:

```lua
ShowErrorPrompt({
    Title = "Themed",
    Message = "Colors applied through Options.",
    Options = {
        TitleColor = Color3.fromRGB(120, 200, 255),
        MessageColor = Color3.fromRGB(200, 220, 240),
        BackgroundColor = Color3.fromRGB(20, 25, 35),
    },
    Buttons = {
        { Text = "OK", Type = "Primary" },
    },
})
```

Globally, applied to every future prompt:

```lua
ErrorPrompt:configure({
    TitleColor = Color3.fromRGB(255, 255, 255),
    MessageColor = Color3.fromRGB(200, 200, 200),
    BackgroundColor = Color3.fromRGB(40, 40, 40),
    SplitColor = Color3.fromRGB(80, 80, 80),
})
```

At runtime, on the returned prompt object:

```lua
local prompt = ShowErrorPrompt({
    Title = "Loading…",
    Message = "Please wait.",
    Buttons = { { Text = "Cancel", Type = "Ghost" } },
})

-- Change the message color and text together.
prompt:setMessage("Loaded successfully.", Color3.fromRGB(120, 255, 120))

-- Change the title and its color together.
prompt:setTitle("Done", Color3.fromRGB(120, 255, 120))

-- Change colors independently.
prompt:setTitleColor(Color3.fromRGB(255, 220, 100))
prompt:setMessageColor(Color3.fromRGB(180, 220, 255))
prompt:setBackgroundColor(Color3.fromRGB(25, 25, 30))
prompt:setSplitColor(Color3.fromRGB(80, 100, 140))
```

Runtime color methods:

| Method | Description |
|--------|-------------|
| `prompt:setTitle(text, color?)` | Sets title text. Optional second argument recolors it. |
| `prompt:setMessage(text, color?)` | Sets message text. Optional second argument recolors it. |
| `prompt:setTitleColor(color)` | Recolors the title only. |
| `prompt:setMessageColor(color)` | Recolors the message only. |
| `prompt:setBackgroundColor(color)` | Recolors the window background. |
| `prompt:setSplitColor(color)` | Recolors the divider line. |

### Button Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Text` | `string` | `"OK"` | Button label. |
| `Type` | `string` | `"Secondary"` | `"Primary"`, `"Secondary"`, `"Danger"` or `"Ghost"`. |
| `Color` / `TextColor` | `Color3` | by type | Override the type colors. |
| `TextSize` | `number` | `20` | Label font size. |
| `CornerRadius` | `number` | window default | Corner radius for this button only. |
| `Stroke` | `boolean` or `table` | `nil` | No stroke unless set. `true` for default, or `{ Color = Color3, Thickness = number }`. |
| `WaitTimeClick` | `number` | `nil` | Seconds the button stays disabled, with a progress overlay that clears left to right. |
| `Disabled` | `boolean` | `false` | Dimmed and not clickable. |
| `Glow` | `boolean` | `false` | Gradient shimmer that starts when the button is clicked. |
| `GlowColor` | `Color3` | gray | Shimmer color. |
| `GlowSpeed` | `number` | `1.5` | Seconds per shimmer sweep. |
| `Callback` | `function` | `nil` | Runs when clicked. |
| `LayoutOrder` | `number` | index | Button order. |

All buttons have the same outer size, with or without a stroke.

Examples:

```lua
-- One of each type.
ShowErrorPrompt({
    Title = "Pick one",
    Buttons = {
        { Text = "Primary",   Type = "Primary" },
        { Text = "Secondary", Type = "Secondary" },
        { Text = "Danger",    Type = "Danger" },
        { Text = "Ghost",     Type = "Ghost" },
    },
})

-- Overriding colors on top of a type.
ShowErrorPrompt({
    Title = "Custom colors",
    Buttons = {
        {
            Text = "Purple",
            Type = "Primary",
            Color = Color3.fromRGB(120, 80, 200),
            TextColor = Color3.fromRGB(255, 255, 255),
        },
    },
})

-- Custom font size on one button.
ShowErrorPrompt({
    Title = "Big label",
    Buttons = {
        { Text = "OK", Type = "Primary", TextSize = 28 },
    },
})

-- Custom corner radius on one button. Does not change other buttons.
ShowErrorPrompt({
    Title = "Round button",
    Buttons = {
        { Text = "Square", Type = "Secondary" },
        { Text = "Round",  Type = "Primary", CornerRadius = 24 },
    },
})

-- Three stroke setups, all equivalent outer size.
ShowErrorPrompt({
    Title = "Strokes",
    Buttons = {
        { Text = "No stroke" },
        { Text = "Default",   Stroke = true },
        { Text = "Custom",    Stroke = { Thickness = 2, Color = Color3.fromRGB(255, 80, 80) } },
    },
})

-- WaitTimeClick. The button cannot be pressed for 5 seconds.
ShowErrorPrompt({
    Title = "Cooling down",
    Message = "You can confirm again in five seconds.",
    Buttons = {
        { Text = "Cancel",  Type = "Secondary" },
        { Text = "Confirm", Type = "Danger", WaitTimeClick = 5 },
    },
})

-- Disabled button. It is dimmed and unclickable, but still visible.
ShowErrorPrompt({
    Title = "Unavailable",
    Buttons = {
        { Text = "Disabled", Type = "Secondary", Disabled = true },
        { Text = "Close",    Type = "Primary" },
    },
})

-- Glow on click.
ShowErrorPrompt({
    Title = "Click me",
    Buttons = {
        {
            Text = "Sparkle",
            Type = "Primary",
            Glow = true,
            GlowColor = Color3.fromRGB(255, 220, 120),
            GlowSpeed = 0.8,
        },
    },
})

-- Callback runs on click, prompt closes after it returns.
ShowErrorPrompt({
    Title = "Log something",
    Buttons = {
        {
            Text = "Log",
            Type = "Primary",
            Callback = function()
                print("clicked at", os.time())
            end,
        },
    },
})

-- Callback that yields keeps the prompt open until it finishes.
-- Clicks on all buttons are ignored during this time.
ShowErrorPrompt({
    Title = "Loading",
    Message = "Fetching data, please wait.",
    Buttons = {
        {
            Text = "Fetch",
            Type = "Primary",
            Callback = function()
                task.wait(3)
                print("done")
            end,
        },
        { Text = "Cancel", Type = "Secondary" },  -- ignored while Fetch is running
    },
})

-- Callback that errors: a warning is printed, prompt still closes.
ShowErrorPrompt({
    Title = "This will warn",
    Buttons = {
        {
            Text = "Break",
            Type = "Danger",
            Callback = function()
                error("intentional failure")
            end,
        },
    },
})

-- LayoutOrder overrides visual order without changing table order.
ShowErrorPrompt({
    Title = "Reordered",
    Buttons = {
        { Text = "Right", Type = "Primary",   LayoutOrder = 2 },
        { Text = "Left",  Type = "Secondary", LayoutOrder = 1 },
    },
})
```

### Click Behavior

- When a button is clicked its `Callback` runs first, and the prompt closes after the callback returns. A callback that yields (for example `task.wait(5)`) keeps the prompt open until it finishes.
- While a callback is running, clicks on the buttons are ignored.
- If a callback errors, a warning is printed and the prompt still closes.
- Buttons are the only way to close the prompt.

```lua
-- Replacing the prompt while it is open swaps the content.
ShowErrorPrompt({ Title = "Step 1" })
ShowErrorPrompt({ Title = "Step 2" })  -- replaces Step 1

-- There is no built-in way to programmatically close it.
-- The user must click a button. If you need a "close" affordance,
-- add one yourself:
ShowErrorPrompt({
    Title = "Forced exit",
    Buttons = {
        { Text = "Close", Type = "Primary" },  -- empty callback still closes
    },
})
```

### Window Options

Pass them in `Options` of `ShowErrorPrompt`, or at any time with `ErrorPrompt:configure({...})`.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `CornerRadius` | `number` | `8` | Window corner radius. |
| `ButtonCornerRadius` | `number` | `6` | Default button corner radius. |
| `Animation` | `boolean` | `true` | Open and close animation. |
| `AnimationTime` | `number` | `0.15` | Animation length in seconds. |
| `Overlay` | `boolean` | `true` | Dark background behind the window. When `false` it is invisible and does not block clicks. |
| `OverlayColor` | `Color3` | black | Overlay color. |
| `OverlayTransparency` | `number` | `0.5` | Overlay transparency. |
| `BackgroundColor` | `Color3` | flint | Window background color. |
| `TitleColor` | `Color3` | white | Title text color. |
| `MessageColor` | `Color3` | pumice | Message text color. |
| `SplitColor` | `Color3` | pumice | Divider line color. |

Examples:

```lua
-- Per prompt, via Options.
ShowErrorPrompt({
    Title = "Instant",
    Options = {
        Animation = false,
        Overlay = false,
    },
})

-- Globally, applied to every future prompt.
ErrorPrompt:configure({ Animation = false, Overlay = false })

-- Everything at once.
ErrorPrompt:configure({
    CornerRadius = 12,
    ButtonCornerRadius = 10,
    Animation = true,
    AnimationTime = 0.25,
    Overlay = true,
    OverlayColor = Color3.fromRGB(20, 20, 30),
    OverlayTransparency = 0.65,
    BackgroundColor = Color3.fromRGB(30, 30, 45),
    TitleColor = Color3.fromRGB(255, 255, 255),
    MessageColor = Color3.fromRGB(200, 210, 230),
    SplitColor = Color3.fromRGB(80, 90, 120),
})

-- Partial configure. Only the listed keys change.
ErrorPrompt:configure({ CornerRadius = 4 })  -- other options keep their current values
```

### Migrating from RblxCallDialog

| RblxCallDialog | ShowErrorPrompt |
|----------------|-----------------|
| `Desc` | `Message` |
| `Button1`, `Button2` | `Buttons = { {...}, {...} }` |
| `Button.Title` | `Text` |
| `Type = "White"` | `Type = "Primary"` |
| `Type = "GreyOutline"` | `Type = "Secondary"`, `Stroke = true` |
| `WaitTimeClick`, `Disabled`, `Callback`, `TextSize` | same names |

The checkbox option was not carried over.

Before (RblxCallDialog):

```lua
RblxCallDialog({
    Title = "Reset Character",
    Desc = "Are you sure you want to reset your character?",
    Button1 = {
        Title = "Reset",
        Type = "White",
        WaitTimeClick = 5,
        Callback = function()
            local hum = game.Players.LocalPlayer.Character
                and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.Health = 0 end
        end,
    },
    Button2 = {
        Title = "Cancel",
        Type = "GreyOutline",
    },
})
```

After (ShowErrorPrompt):

```lua
ShowErrorPrompt({
    Title = "Reset Character",
    Message = "Are you sure you want to reset your character?",
    Buttons = {
        {
            Text = "Reset",
            Type = "Primary",
            WaitTimeClick = 5,
            Callback = function()
                local hum = game.Players.LocalPlayer.Character
                    and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum.Health = 0 end
            end,
        },
        {
            Text = "Cancel",
            Type = "Secondary",
            Stroke = true,
        },
    },
})
```

Single button (only `Button1` set):

```lua
-- Before:
RblxCallDialog({
    Title = "Notice",
    Desc = "Saved.",
    Button1 = { Title = "OK", Type = "White" },
})

-- After:
ShowErrorPrompt({
    Title = "Notice",
    Message = "Saved.",
    Buttons = {
        { Text = "OK", Type = "Primary" },
    },
})
```

No buttons (message only):

```lua
-- Before:
RblxCallDialog({ Title = "Notice", Desc = "Saved." })

-- After:
ShowErrorPrompt({ Title = "Notice", Message = "Saved." })
```
