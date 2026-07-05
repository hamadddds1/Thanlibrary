--[[
	TahoeUI · v2.0.0
	Liquid Glass UI Library for Roblox
	Inspired by macOS Tahoe

	Load:
		local TahoeUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/hamaddddds/Tahoe-library/main/Tahoelibrary.luau"))()

	Quick Start:
		local Window = TahoeUI:CreateWindow({
			Title    = "My App",
			Subtitle = "v2.0",
			Theme    = "Dark",        -- Dark, Transparent, Midnight, Rose, Ocean
		})

		-- Tab Section (collapsible group in sidebar)
		local Combat = Window:CreateTabSection({ Name = "Combat" })
		local AimbotTab = Combat:CreateTab({ Name = "Aimbot", Icon = "crosshair" })
		local ESPTab    = Combat:CreateTab({ Name = "ESP",    Icon = "eye" })

		-- Direct Tab
		local General = Window:CreateTab({ Name = "General", Icon = "settings" })

		-- Content Section (collapsible component group)
		local Settings = General:CreateSection({ Name = "Settings" })
		Settings:CreateToggle({ Name = "Feature", Callback = function(v) end })
		Settings:CreateSlider({ Name = "Speed", Min = 0, Max = 100, Callback = function(v) end })

		-- Direct components
		General:CreateButton({ Name = "Execute", Callback = function() end })

		-- Icons (Lucide)
		TahoeUI.Icons:Register("myicon", "rbxassetid://12345")
		TahoeUI.Icons:BatchRegister({ sword = "rbxassetid://111", shield = "rbxassetid://222" })

		-- Notifications
		TahoeUI:Notify({ Title = "Done", Content = "Ready!", Duration = 3, Type = "success" })
]]

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInput    = game:GetService("UserInputService")
local player       = Players.LocalPlayer

-- ── Easing ──────────────────────────────────────────

local Ease = {
	smooth = TweenInfo.new(0.30, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	spring = TweenInfo.new(0.42, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
	quick  = TweenInfo.new(0.14, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
	slow   = TweenInfo.new(0.50, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	bounce = TweenInfo.new(0.28, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
	linear = function(d)
		return TweenInfo.new(d, Enum.EasingStyle.Linear)
	end,
}

-- ── Themes ──────────────────────────────────────────

local Themes = {
	Dark = {
		windowBg    = Color3.fromRGB(24, 24, 28),
		windowTrans = 0,
		sidebarBg   = Color3.fromRGB(30, 30, 35),
		sidebarTrans = 0.12,
		surface     = Color3.fromRGB(32, 32, 36),
		elevated    = Color3.fromRGB(42, 42, 48),
		hover       = Color3.fromRGB(54, 54, 60),
		accent      = Color3.fromRGB(10, 132, 255),
		accentDim   = Color3.fromRGB(8,  100, 200),
		text        = Color3.fromRGB(255, 255, 255),
		sub         = Color3.fromRGB(142, 142, 148),
		dim         = Color3.fromRGB(88,  88,  96),
		border      = Color3.fromRGB(52, 52, 58),
		glass       = Color3.fromRGB(255, 255, 255),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
	Transparent = {
		windowBg    = Color3.fromRGB(12, 12, 16),
		windowTrans = 0.38,
		sidebarBg   = Color3.fromRGB(16, 16, 20),
		sidebarTrans = 0.42,
		surface     = Color3.fromRGB(20, 20, 24),
		elevated    = Color3.fromRGB(32, 32, 38),
		hover       = Color3.fromRGB(44, 44, 50),
		accent      = Color3.fromRGB(10, 132, 255),
		accentDim   = Color3.fromRGB(8,  100, 200),
		text        = Color3.fromRGB(255, 255, 255),
		sub         = Color3.fromRGB(142, 142, 148),
		dim         = Color3.fromRGB(88,  88,  96),
		border      = Color3.fromRGB(66, 66, 72),
		glass       = Color3.fromRGB(255, 255, 255),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
	Midnight = {
		windowBg    = Color3.fromRGB(14, 14, 30),
		windowTrans = 0.06,
		sidebarBg   = Color3.fromRGB(18, 16, 36),
		sidebarTrans = 0.1,
		surface     = Color3.fromRGB(22, 20, 40),
		elevated    = Color3.fromRGB(34, 32, 54),
		hover       = Color3.fromRGB(46, 44, 66),
		accent      = Color3.fromRGB(138, 92, 255),
		accentDim   = Color3.fromRGB(110, 72, 210),
		text        = Color3.fromRGB(235, 235, 255),
		sub         = Color3.fromRGB(138, 136, 166),
		dim         = Color3.fromRGB(88,  86,  108),
		border      = Color3.fromRGB(54, 52, 74),
		glass       = Color3.fromRGB(200, 200, 255),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
	Rose = {
		windowBg    = Color3.fromRGB(28, 18, 24),
		windowTrans = 0.04,
		sidebarBg   = Color3.fromRGB(34, 22, 28),
		sidebarTrans = 0.08,
		surface     = Color3.fromRGB(38, 26, 32),
		elevated    = Color3.fromRGB(52, 36, 44),
		hover       = Color3.fromRGB(66, 48, 56),
		accent      = Color3.fromRGB(255, 82, 120),
		accentDim   = Color3.fromRGB(210, 62, 100),
		text        = Color3.fromRGB(255, 242, 246),
		sub         = Color3.fromRGB(166, 136, 148),
		dim         = Color3.fromRGB(108, 86,  96),
		border      = Color3.fromRGB(68, 50, 58),
		glass       = Color3.fromRGB(255, 225, 238),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
	Ocean = {
		windowBg    = Color3.fromRGB(14, 22, 28),
		windowTrans = 0.04,
		sidebarBg   = Color3.fromRGB(16, 28, 34),
		sidebarTrans = 0.08,
		surface     = Color3.fromRGB(20, 32, 38),
		elevated    = Color3.fromRGB(30, 46, 54),
		hover       = Color3.fromRGB(42, 58, 66),
		accent      = Color3.fromRGB(0, 210, 178),
		accentDim   = Color3.fromRGB(0, 168, 142),
		text        = Color3.fromRGB(235, 255, 250),
		sub         = Color3.fromRGB(126, 160, 152),
		dim         = Color3.fromRGB(76, 100, 94),
		border      = Color3.fromRGB(40, 60, 66),
		glass       = Color3.fromRGB(215, 255, 245),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
}

local T = Themes.Dark -- active theme ref

-- ── Utility ─────────────────────────────────────────

local function make(class, props, children)
	local inst = Instance.new(class)
	for k, v in props do
		if k ~= "Parent" then
			(inst :: any)[k] = v
		end
	end
	if children then
		for _, ch in children do
			ch.Parent = inst
		end
	end
	if props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

local function tween(obj, info, goals)
	local tw = TweenService:Create(obj, info, goals)
	tw:Play()
	return tw
end

local function corner(parent, r)
	return make("UICorner", { CornerRadius = UDim.new(0, r), Parent = parent })
end

local function stroke(parent, col, trans, thick)
	return make("UIStroke", {
		Color           = col or T.glass,
		Transparency    = trans or 0.92,
		Thickness       = thick or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent          = parent,
	})
end

local function pad(parent, t, b, l, r)
	return make("UIPadding", {
		PaddingTop    = UDim.new(0, t),
		PaddingBottom = UDim.new(0, b),
		PaddingLeft   = UDim.new(0, l),
		PaddingRight  = UDim.new(0, r),
		Parent        = parent,
	})
end

local function lay(parent, dir, gap)
	return make("UIListLayout", {
		FillDirection = dir or Enum.FillDirection.Vertical,
		Padding       = UDim.new(0, gap or 4),
		SortOrder     = Enum.SortOrder.LayoutOrder,
		Parent        = parent,
	})
end

local function mergeTheme(base, over)
	local r = table.clone(base)
	for k, v in over do r[k] = v end
	return r
end

-- ── Icon System (Lucide-compatible) ─────────────────

local IconMap = {}
local FluentIcons = {}
pcall(function()
	FluentIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/src/Icons.lua"))().assets
end)


local IconsAPI = {}

function IconsAPI:Register(name, assetId)
	IconMap[name] = assetId
end

function IconsAPI:BatchRegister(map)
	for name, id in map do
		IconMap[name] = id
	end
end

function IconsAPI:Render(parent, name, size, color)
	if not name or name == "" then return nil end
	size  = size or 16
	color = color or T.sub

	local asset = IconMap[name] or FluentIcons[name] or FluentIcons["lucide-" .. name]
	if asset then
		return make("ImageLabel", {
			Size                 = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1,
			Image                = asset,
			ImageColor3          = color,
			ScaleType            = Enum.ScaleType.Fit,
			Parent               = parent,
		})
	end

	-- check if name is already an rbxassetid
	if string.find(name, "rbxasset") then
		return make("ImageLabel", {
			Size                 = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1,
			Image                = name,
			ImageColor3          = color,
			ScaleType            = Enum.ScaleType.Fit,
			Parent               = parent,
		})
	end

	return nil
end

local function tween(obj, info, goals)
	local tw = TweenService:Create(obj, info, goals)
	tw:Play()
	return tw
end

local function corner(parent, r)
	return make("UICorner", { CornerRadius = UDim.new(0, r), Parent = parent })
end

local function stroke(parent, col, trans, thick)
	return make("UIStroke", {
		Color           = col or T.glass,
		Transparency    = trans or 0.92,
		Thickness       = thick or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent          = parent,
	})
end

local function pad(parent, t, b, l, r)
	return make("UIPadding", {
		PaddingTop    = UDim.new(0, t),
		PaddingBottom = UDim.new(0, b),
		PaddingLeft   = UDim.new(0, l),
		PaddingRight  = UDim.new(0, r),
		Parent        = parent,
	})
end

local function lay(parent, dir, gap)
	return make("UIListLayout", {
		FillDirection = dir or Enum.FillDirection.Vertical,
		Padding       = UDim.new(0, gap or 4),
		SortOrder     = Enum.SortOrder.LayoutOrder,
		Parent        = parent,
	})
end

local function mergeTheme(base, over)
	local r = table.clone(base)
	for k, v in over do r[k] = v end
	return r
end

-- ── Library State ───────────────────────────────────

local TahoeUI         = { Icons = IconsAPI, Flags = {} }
local screenGui     = nil
local dropBackdrop  = nil
local notifHolder   = nil
local conns         = {}
local activeDropFn  = nil

local function initGui()
	if screenGui then return end

	screenGui = make("ScreenGui", {
		Name             = "TahoeUI",
		DisplayOrder     = 9999,
		ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn     = false,
		IgnoreGuiInset   = true,
	})

	pcall(function() if syn then syn.protect_gui(screenGui) end end)

	local ok = pcall(function()
		screenGui.Parent = game:GetService("CoreGui")
	end)
	if not ok then
		pcall(function() screenGui.Parent = player:WaitForChild("PlayerGui") end)
	end

	dropBackdrop = make("TextButton", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text    = "",
		ZIndex  = 50,
		Visible = false,
		Parent  = screenGui,
	})
	dropBackdrop.MouseButton1Click:Connect(function()
		if activeDropFn then activeDropFn(); activeDropFn = nil end
		dropBackdrop.Visible = false
	end)

	notifHolder = make("Frame", {
		Size                 = UDim2.new(0, 300, 1, -24),
		Position             = UDim2.new(1, -12, 0, 12),
		AnchorPoint          = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		ZIndex  = 100,
		Parent  = screenGui,
	})
	lay(notifHolder, Enum.FillDirection.Vertical, 8)
end

-- ── Row Factory ─────────────────────────────────────

local function createRow(parent, cfg, order)
	local hasDesc = cfg.Description and #cfg.Description > 0
	local h = hasDesc and 54 or 42

	local row = make("Frame", {
		Size                 = UDim2.new(1, 0, 0, h),
		BackgroundColor3     = T.elevated,
		BackgroundTransparency = 0.45,
		LayoutOrder          = order,
		ClipsDescendants     = true,
		Parent               = parent,
	})
	corner(row, 10)
	stroke(row, T.glass, 0.93, 1)

	row.MouseEnter:Connect(function()
		tween(row, Ease.quick, { BackgroundTransparency = 0.22 })
	end)
	row.MouseLeave:Connect(function()
		tween(row, Ease.quick, { BackgroundTransparency = 0.45 })
	end)

	make("TextLabel", {
		Size                 = UDim2.new(0.50, 0, 0, 18),
		Position             = UDim2.fromOffset(14, hasDesc and 10 or 12),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 13,
		TextColor3           = T.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextYAlignment       = Enum.TextYAlignment.Top,
		TextTruncate         = Enum.TextTruncate.AtEnd,
		Text                 = cfg.Name or "",
		Parent               = row,
	})

	if hasDesc then
		make("TextLabel", {
			Size                 = UDim2.new(0.60, 0, 0, 14),
			Position             = UDim2.fromOffset(14, 26),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.Gotham,
			TextSize             = 11,
			TextColor3           = T.sub,
			TextXAlignment       = Enum.TextXAlignment.Left,
			TextYAlignment       = Enum.TextYAlignment.Top,
			TextTruncate         = Enum.TextTruncate.AtEnd,
			Text                 = cfg.Description,
			Parent               = row,
		})
	end

	return row
end

local function applyLockOverlay(row, state, reason)
	local lockOverlay = row:FindFirstChild("LockOverlay")
	if state then
		if not lockOverlay then
			lockOverlay = make("Frame", {
				Name = "LockOverlay",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = T.windowBg,
				BackgroundTransparency = 1,
				ZIndex = 40,
				Parent = row
			})
			corner(lockOverlay, 10)
			
			local icon = IconsAPI:Render(lockOverlay, "lock", 16, T.text)
			if icon then
				icon.AnchorPoint = Vector2.new(0, 0.5)
				icon.Position = UDim2.new(0, 16, 0.5, 0)
				icon.ZIndex = 41
				icon.ImageTransparency = 1
			end
			
			local lbl = make("TextLabel", {
				Name = "ReasonLbl",
				Size = UDim2.new(1, -44, 1, 0),
				Position = UDim2.fromOffset(40, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextColor3 = T.text,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = "LOCKED" .. (reason and (" - " .. reason) or ""),
				TextTransparency = 1,
				ZIndex = 41,
				Parent = lockOverlay
			})
			
			tween(lockOverlay, Ease.quick, { BackgroundTransparency = 0.25 })
			if icon then tween(icon, Ease.quick, { ImageTransparency = 0 }) end
			tween(lbl, Ease.quick, { TextTransparency = 0 })
		else
			local lbl = lockOverlay:FindFirstChild("ReasonLbl")
			if lbl then lbl.Text = "LOCKED" .. (reason and (" - " .. reason) or "") end
		end
	else
		if lockOverlay then
			tween(lockOverlay, Ease.quick, { BackgroundTransparency = 1 })
			for _, ch in lockOverlay:GetChildren() do
				if ch:IsA("ImageLabel") then tween(ch, Ease.quick, { ImageTransparency = 1 }) end
				if ch:IsA("TextLabel") then tween(ch, Ease.quick, { TextTransparency = 1 }) end
			end
			task.delay(0.2, function() lockOverlay:Destroy() end)
		end
	end
end

-- ═══════════════════════════════════════════════════
-- Component Factories
-- ═══════════════════════════════════════════════════

local function _label(scroll, order, text)
	local lbl = make("TextLabel", {
		Size                 = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 12,
		TextColor3           = T.sub,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = text,
		LayoutOrder          = order,
		Parent               = scroll,
	})
	local obj = {}
	function obj:Set(t) lbl.Text = t end
	function obj:Destroy() lbl:Destroy() end
	return obj
end

local function _paragraph(scroll, order, cfg)
	local row = make("Frame", {
		Size                 = UDim2.new(1, 0, 0, 0),
		AutomaticSize        = Enum.AutomaticSize.Y,
		BackgroundColor3     = T.elevated,
		BackgroundTransparency = 0.45,
		LayoutOrder          = order,
		Parent               = scroll,
	})
	corner(row, 10)
	stroke(row, T.glass, 0.93, 1)
	pad(row, 12, 14, 14, 14)
	lay(row, Enum.FillDirection.Vertical, 6)

	local pTitle = make("TextLabel", {
		Size                 = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 13,
		TextColor3           = T.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = cfg.Title or "",
		LayoutOrder = 1,
		Parent      = row,
	})
	local pBody = make("TextLabel", {
		Size                 = UDim2.new(1, 0, 0, 0),
		AutomaticSize        = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Font                 = Enum.Font.Gotham,
		TextSize             = 11,
		TextColor3           = T.sub,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextWrapped          = true,
		Text                 = cfg.Content or "",
		LayoutOrder = 2,
		Parent      = row,
	})
	local obj = {}
	function obj:Set(c)
		if c.Title   then pTitle.Text = c.Title end
		if c.Content then pBody.Text  = c.Content end
	end
	function obj:Destroy() row:Destroy() end
	return obj
end

local function _button(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)
	local locked = false
	local originalName = cfg.Name or ""
	local nameLabel = row:FindFirstChildWhichIsA("TextLabel")

	make("TextLabel", {
		Size                 = UDim2.fromOffset(16, 18),
		Position             = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint          = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 16,
		TextColor3           = T.dim,
		Text                 = "›",
		Parent               = row,
	})

	local click = make("TextButton", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text    = "",
		AutoButtonColor = false,
		Parent  = row,
	})

	click.MouseButton1Click:Connect(function()
		if locked then return end
		tween(row, Ease.quick, { BackgroundTransparency = 0.06 })
		task.delay(0.1, function()
			tween(row, Ease.smooth, { BackgroundTransparency = 0.45 })
		end)
		if cfg.Callback then task.spawn(cfg.Callback) end
	end)

	local obj = {}
	function obj:Lock(reason)
		locked = true
		tween(row, Ease.quick, { BackgroundTransparency = 0.7 })
		if nameLabel then nameLabel.Text = originalName .. " [LOCKED" .. (reason and ": " .. reason or "") .. "]" end
	end
	function obj:Unlock()
		locked = false
		tween(row, Ease.quick, { BackgroundTransparency = 0.45 })
		if nameLabel then nameLabel.Text = originalName end
	end
	function obj:Destroy() row:Destroy() end
	
	if cfg.Name then TahoeUI.Flags[cfg.Name] = obj end
	return obj
end

local function _toggle(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)
	local locked = false
	local originalName = cfg.Name or ""
	local nameLabel = row:FindFirstChildWhichIsA("TextLabel")

	-- Track (pill)
	local track = make("Frame", {
		Size             = UDim2.fromOffset(42, 22),
		Position         = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint      = Vector2.new(1, 0.5),
		BackgroundColor3 = T.hover,
		Parent           = row,
	})
	corner(track, 11)

	-- Inner glow track (shows when ON)
	local glow = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundColor3     = T.accent,
		BackgroundTransparency = 1,
		Parent               = track,
	})
	corner(glow, 11)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.6),
			NumberSequenceKeypoint.new(0.5, 0.3),
			NumberSequenceKeypoint.new(1, 0.6),
		}),
		Parent = glow,
	})

	-- Thumb
	local thumb = make("Frame", {
		Size             = UDim2.fromOffset(18, 18),
		Position         = UDim2.fromOffset(2, 2),
		BackgroundColor3 = T.text,
		Parent           = track,
	})
	corner(thumb, 9)
	local thumbStroke = stroke(thumb, Color3.new(0, 0, 0), 0.86, 1)

	local toggled = cfg.Default or false

	local function refresh(state, anim)
		toggled = state
		if anim == false then
			thumb.Position       = state and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
			track.BackgroundColor3 = state and T.accent or T.hover
			glow.BackgroundTransparency = state and 0 or 1
			thumbStroke.Color    = state and T.accent or Color3.new(0, 0, 0)
			thumbStroke.Transparency = state and 0.4 or 0.86
			return
		end

		-- Squish stretch → slide → snap back
		tween(thumb, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(22, 18),
		})
		tween(thumb, Ease.bounce, {
			Position = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2),
		})
		task.delay(0.14, function()
			tween(thumb, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(18, 18),
			})
		end)
		tween(track, Ease.smooth, { BackgroundColor3 = state and T.accent or T.hover })
		tween(glow, Ease.smooth, { BackgroundTransparency = state and 0 or 1 })
		tween(thumbStroke, Ease.smooth, {
			Color        = state and T.accent or Color3.new(0, 0, 0),
			Transparency = state and 0.4 or 0.86,
		})
	end

	refresh(toggled, false)

	local click = make("TextButton", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text    = "",
		AutoButtonColor = false,
		Parent  = row,
	})

	click.MouseButton1Click:Connect(function()
		if locked then return end
		refresh(not toggled, true)
		if cfg.Callback then task.spawn(cfg.Callback, toggled) end
	end)

	local obj = {}
	function obj:Lock(reason)
		locked = true
		applyLockOverlay(row, true, reason)
	end
	function obj:Unlock()
		locked = false
		applyLockOverlay(row, false)
	end
	function obj:Set(v) refresh(v, true); if cfg.Callback then task.spawn(cfg.Callback, toggled) end end
	function obj:Get() return toggled end
	function obj:Destroy() row:Destroy() end
	
	if cfg.Name then TahoeUI.Flags[cfg.Name] = obj end
	return obj
end

local function _slider(scroll, order, cfg)
	local mn  = cfg.Min or 0
	local mx  = cfg.Max or 100
	local inc = cfg.Increment or 1
	local def = math.clamp(cfg.Default or mn, mn, mx)
	local hasDesc = cfg.Description and #cfg.Description > 0

	local row = createRow(scroll, cfg, order)
	row.Size = UDim2.new(1, 0, 0, hasDesc and 62 or 52)
	local locked = false
	local originalName = cfg.Name or ""
	local nameLabel = row:FindFirstChildWhichIsA("TextLabel")

	local valLbl = make("TextLabel", {
		Size                 = UDim2.fromOffset(52, 16),
		Position             = UDim2.new(1, -14, 0, hasDesc and 10 or 8),
		AnchorPoint          = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 12,
		TextColor3           = T.sub,
		TextXAlignment       = Enum.TextXAlignment.Right,
		Text                 = tostring(def),
		Parent               = row,
	})

	local trackY = hasDesc and 44 or 34
	local trackFrame = make("Frame", {
		Size             = UDim2.new(1, -28, 0, 4),
		Position         = UDim2.fromOffset(14, trackY),
		BackgroundColor3 = T.hover,
		Parent           = row,
	})
	corner(trackFrame, 2)

	local fill = make("Frame", {
		Size             = UDim2.fromScale(0, 1),
		BackgroundColor3 = T.accent,
		Parent           = trackFrame,
	})
	corner(fill, 2)

	local knob = make("Frame", {
		Size             = UDim2.fromOffset(14, 14),
		Position         = UDim2.fromScale(0, 0.5),
		AnchorPoint      = Vector2.new(0.5, 0.5),
		BackgroundColor3 = T.text,
		ZIndex           = 3,
		Parent           = trackFrame,
	})
	corner(knob, 7)
	stroke(knob, Color3.new(0, 0, 0), 0.84, 1)

	local value   = def
	local sliding = false

	local function update(pct, fire)
		pct = math.clamp(pct, 0, 1)
		local raw = mn + (mx - mn) * pct
		value = math.floor(raw / inc + 0.5) * inc
		value = math.clamp(value, mn, mx)
		local p = (value - mn) / (mx - mn)
		fill.Size     = UDim2.new(p, 0, 1, 0)
		knob.Position = UDim2.new(p, 0, 0.5, 0)
		valLbl.Text   = tostring(value)
		if fire and cfg.Callback then task.spawn(cfg.Callback, value) end
	end

	update((def - mn) / (mx - mn), false)

	trackFrame.InputBegan:Connect(function(input)
		if locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = true
			update(math.clamp((input.Position.X - trackFrame.AbsolutePosition.X) / trackFrame.AbsoluteSize.X, 0, 1), true)
		end
	end)
	knob.InputBegan:Connect(function(input)
		if locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
	end)
	table.insert(conns, UserInput.InputChanged:Connect(function(input)
		if not sliding or locked then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		update(math.clamp((input.Position.X - trackFrame.AbsolutePosition.X) / trackFrame.AbsoluteSize.X, 0, 1), true)
	end))
	table.insert(conns, UserInput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
	end))

	local obj = {}
	function obj:Lock(reason)
		locked = true
		sliding = false
		applyLockOverlay(row, true, reason)
	end
	function obj:Unlock()
		locked = false
		applyLockOverlay(row, false)
	end
	function obj:Set(v) value = math.clamp(v, mn, mx); update((value - mn) / (mx - mn), false) end
	function obj:Get() return value end
	function obj:Destroy() row:Destroy() end
	
	if cfg.Name then TahoeUI.Flags[cfg.Name] = obj end
	return obj
end

local function _dropdown(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)
	local options  = cfg.Options or {}
	local selected
	if cfg.Multi then
		selected = type(cfg.Default) == "table" and cfg.Default or {}
	else
		selected = cfg.Default or options[1] or ""
	end
	local locked = false
	local originalName = cfg.Name or ""
	local nameLabel = row:FindFirstChildWhichIsA("TextLabel")

	local dropBtn = make("TextButton", {
		Size                 = UDim2.new(0.55, 0, 0, 24),
		Position             = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint          = Vector2.new(1, 0.5),
		BackgroundColor3     = T.hover,
		BackgroundTransparency = 0.15,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 11,
		TextColor3           = T.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = "",
		AutoButtonColor      = false,
		ClipsDescendants     = true,
		TextTruncate         = Enum.TextTruncate.AtEnd,
		Parent               = row,
	})
	corner(dropBtn, 8)
	stroke(dropBtn, T.border, 0.55, 1)
	pad(dropBtn, 0, 0, 8, 24)

	local chev = IconsAPI:Render(dropBtn, "chevron-down", 12, T.sub)
	if chev then
		chev.AnchorPoint = Vector2.new(1, 0.5)
		chev.Position = UDim2.new(1, -6, 0.5, 0)
	end

	local popup = make("Frame", {
		BackgroundColor3     = T.surface,
		BackgroundTransparency = 0.04,
		Visible  = false,
		ZIndex   = 55,
		ClipsDescendants = true,
		Parent   = screenGui,
	})
	corner(popup, 10)
	stroke(popup, T.border, 0.4, 1)
	pad(popup, 4, 4, 4, 4)
	local popLay = lay(popup, Enum.FillDirection.Vertical, 4)

	local searchBox = make("TextBox", {
		Size                 = UDim2.new(1, 0, 0, 26),
		BackgroundColor3     = T.windowBg,
		BackgroundTransparency = 0.3,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 11,
		TextColor3           = T.text,
		PlaceholderText      = "Search...",
		PlaceholderColor3    = T.dim,
		Text                 = "",
		ClearTextOnFocus     = false,
		LayoutOrder          = 0,
		Parent               = popup,
	})
	corner(searchBox, 6)
	stroke(searchBox, T.border, 0.5, 1)
	pad(searchBox, 0, 0, 8, 8)

	local scrollOpts = make("ScrollingFrame", {
		Size                 = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness   = 2,
		ScrollBarImageColor3 = T.text,
		BorderSizePixel      = 0,
		CanvasSize           = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize  = Enum.AutomaticSize.Y,
		Active               = true,
		LayoutOrder          = 1,
		Parent               = popup,
	})
	local soLay = lay(scrollOpts, Enum.FillDirection.Vertical, 2)

	local isOpen  = false
	local optBtns = {}
	local closeFn

	local function getSelectedText()
		if type(selected) == "table" then
			if #selected == 0 then return "None" end
			if #selected <= 2 then return table.concat(selected, ", ") end
			return tostring(#selected) .. " Selected"
		else
			return selected
		end
	end
	
	dropBtn.Text = getSelectedText()

	local function isSelected(opt)
		if type(selected) == "table" then
			return table.find(selected, opt) ~= nil
		end
		return selected == opt
	end

	local function toggleSelection(opt, ob)
		if type(selected) == "table" then
			local idx = table.find(selected, opt)
			if idx then
				table.remove(selected, idx)
				tween(ob, Ease.quick, { TextColor3 = T.text })
			else
				table.insert(selected, opt)
				tween(ob, Ease.quick, { TextColor3 = T.accent })
			end
			dropBtn.Text = getSelectedText()
			if cfg.Callback then task.spawn(cfg.Callback, selected) end
		else
			selected = opt
			dropBtn.Text = getSelectedText()
			closeFn()
			if cfg.Callback then task.spawn(cfg.Callback, opt) end
		end
	end

	local function buildOpts(filterText)
		for _, b in optBtns do b:Destroy() end
		optBtns = {}
		local count = 0
		local lowerFilter = filterText and filterText:lower() or ""
		
		for i, opt in options do
			if lowerFilter ~= "" and not string.find(opt:lower(), lowerFilter, 1, true) then continue end
			count = count + 1
			local ob = make("TextButton", {
				Size                 = UDim2.new(1, 0, 0, 26),
				BackgroundColor3     = T.elevated,
				BackgroundTransparency = 0.5,
				Font                 = Enum.Font.GothamMedium,
				TextSize             = 11,
				TextColor3           = isSelected(opt) and T.accent or T.text,
				Text                 = opt,
				AutoButtonColor      = false,
				LayoutOrder          = i,
				Parent               = scrollOpts,
			})
			corner(ob, 6)
			ob.MouseEnter:Connect(function() tween(ob, Ease.quick, { BackgroundTransparency = 0.12 }) end)
			ob.MouseLeave:Connect(function() tween(ob, Ease.quick, { BackgroundTransparency = 0.5 }) end)
			ob.MouseButton1Click:Connect(function() toggleSelection(opt, ob) end)
			table.insert(optBtns, ob)
		end
		
		local sh = count * 28 - 2
		if count == 0 then sh = 0 end
		local clampedSh = math.min(sh, 4 * 28 - 2)
		scrollOpts.Size = UDim2.new(1, 0, 0, clampedSh)
		return clampedSh
	end

	searchBox.Changed:Connect(function(prop)
		if prop == "Text" and isOpen then
			local clampedSh = buildOpts(searchBox.Text)
			local totalHeight = 4 + 26 + 4 + clampedSh + 4
			if clampedSh == 0 then totalHeight = 4 + 26 + 4 end
			tween(popup, Ease.quick, { Size = UDim2.new(0, popup.AbsoluteSize.X, 0, totalHeight) })
		end
	end)

	closeFn = function()
		if not isOpen then return end
		isOpen = false
		if chev then tween(chev, Ease.smooth, { Rotation = 0 }) end
		tween(popup, Ease.quick, { Size = UDim2.fromOffset(popup.AbsoluteSize.X, 0) })
		task.delay(0.14, function() if not isOpen then popup.Visible = false end end)
		dropBackdrop.Visible = false
	end

	local function openFn()
		searchBox.Text = ""
		local clampedSh = buildOpts("")
		if chev then tween(chev, Ease.smooth, { Rotation = 180 }) end
		local ap, as = dropBtn.AbsolutePosition, dropBtn.AbsoluteSize
		popup.Position = UDim2.fromOffset(ap.X, ap.Y + as.Y + 4)
		popup.Size     = UDim2.fromOffset(math.max(as.X, 130), 0)
		popup.Visible  = true
		local totalHeight = 4 + 26 + 4 + clampedSh + 4
		if clampedSh == 0 then totalHeight = 4 + 26 + 4 end
		tween(popup, Ease.spring, { Size = UDim2.fromOffset(math.max(as.X, 130), totalHeight) })
		dropBackdrop.Visible = true
		isOpen = true
	end

	dropBtn.MouseButton1Click:Connect(function()
		if locked then return end
		if isOpen then
			closeFn()
		else
			if activeDropFn and activeDropFn ~= closeFn then activeDropFn() end
			activeDropFn = closeFn
			openFn()
		end
	end)

	local obj = {}
	function obj:Lock(reason)
		locked = true
		if isOpen then closeFn() end
		applyLockOverlay(row, true, reason)
	end
	function obj:Unlock()
		locked = false
		applyLockOverlay(row, false)
	end
	function obj:Set(v) 
		selected = v
		dropBtn.Text = getSelectedText()
		if cfg.Callback then task.spawn(cfg.Callback, v) end 
	end
	function obj:Refresh(n) 
		options = n
		if type(selected) ~= "table" and not table.find(options, selected) then 
			selected = options[1] or ""
		end
		dropBtn.Text = getSelectedText() 
	end
	function obj:Get() return selected end
	function obj:Destroy() popup:Destroy(); row:Destroy() end
	
	if cfg.Name then TahoeUI.Flags[cfg.Name] = obj end
	return obj
end

local function _input(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)
	local locked = false
	local originalName = cfg.Name or ""
	local nameLabel = row:FindFirstChildWhichIsA("TextLabel")

	local box = make("TextBox", {
		Size                 = UDim2.new(0.55, 0, 0, 24),
		Position             = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint          = Vector2.new(1, 0.5),
		BackgroundColor3     = T.windowBg,
		BackgroundTransparency = 0.1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 11,
		TextColor3           = T.text,
		PlaceholderText      = cfg.Placeholder or "Type...",
		PlaceholderColor3    = T.dim,
		Text                 = cfg.Default or "",
		ClearTextOnFocus     = false,
		ClipsDescendants     = true,
		TextTruncate         = Enum.TextTruncate.AtEnd,
		Parent               = row,
	})
	corner(box, 8)
	local bxStroke = stroke(box, T.border, 0.5, 1)
	pad(box, 0, 0, 8, 8)

	box.Focused:Connect(function()
		if locked then box:ReleaseFocus(); return end
		tween(bxStroke, Ease.quick, { Color = T.accent, Transparency = 0.12 })
	end)
	box.FocusLost:Connect(function(enter)
		tween(bxStroke, Ease.quick, { Color = T.border, Transparency = 0.5 })
		if enter and cfg.Callback then task.spawn(cfg.Callback, box.Text) end
	end)

	local obj = {}
	function obj:Lock(reason)
		locked = true
		box.TextEditable = false
		applyLockOverlay(row, true, reason)
	end
	function obj:Unlock()
		locked = false
		box.TextEditable = true
		applyLockOverlay(row, false)
	end
	function obj:Set(v) box.Text = v end
	function obj:Get() return box.Text end
	function obj:Destroy() row:Destroy() end
	
	if cfg.Name then TahoeUI.Flags[cfg.Name] = obj end
	return obj
end

local function _keybind(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)
	local currentKey = cfg.Default
	local binding    = false
	local locked = false
	local originalName = cfg.Name or ""
	local nameLabel = row:FindFirstChildWhichIsA("TextLabel")

	local keyBtn = make("TextButton", {
		Size                 = UDim2.fromOffset(82, 24),
		Position             = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint          = Vector2.new(1, 0.5),
		BackgroundColor3     = T.hover,
		BackgroundTransparency = 0.15,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 11,
		TextColor3           = T.sub,
		Text                 = currentKey and currentKey.Name or "None",
		AutoButtonColor      = false,
		Parent               = row,
	})
	corner(keyBtn, 8)
	stroke(keyBtn, T.border, 0.55, 1)

	keyBtn.MouseButton1Click:Connect(function()
		if locked then return end
		if binding then return end
		binding = true
		keyBtn.Text = "..."
		tween(keyBtn, Ease.quick, { BackgroundColor3 = T.accent, BackgroundTransparency = 0.55 })
		local c
		c = UserInput.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			c:Disconnect()
			binding = false
			tween(keyBtn, Ease.quick, { BackgroundColor3 = T.hover, BackgroundTransparency = 0.15 })
			if input.KeyCode == Enum.KeyCode.Escape then
				keyBtn.Text = currentKey and currentKey.Name or "None"
				return
			end
			currentKey  = input.KeyCode
			keyBtn.Text = currentKey.Name
			if cfg.Callback then task.spawn(cfg.Callback, currentKey) end
			if cfg.ChangedCallback then task.spawn(cfg.ChangedCallback, currentKey) end
		end)
	end)

	table.insert(conns, UserInput.InputBegan:Connect(function(input, gpe)
		if locked then return end
		if gpe or binding then return end
		if currentKey and input.KeyCode == currentKey then
			if cfg.Callback then task.spawn(cfg.Callback, currentKey) end
		end
	end))

	local obj = {}
	function obj:Lock(reason)
		locked = true
		if binding then binding = false; keyBtn.Text = currentKey and currentKey.Name or "None" end
		applyLockOverlay(row, true, reason)
	end
	function obj:Unlock()
		locked = false
		applyLockOverlay(row, false)
	end
	function obj:Set(k) currentKey = k; keyBtn.Text = k and k.Name or "None" end
	function obj:Get() return currentKey end
	function obj:Destroy() row:Destroy() end
	
	if cfg.Name then TahoeUI.Flags[cfg.Name] = obj end
	return obj
end

-- ═══════════════════════════════════════════════════
-- Component Mixins
-- ═══════════════════════════════════════════════════

local function attachBase(target, scroll, nextOrd)
	function target:CLabel(text)     return _label(scroll, nextOrd(), text) end
	function target:CParagraph(cfg)  return _paragraph(scroll, nextOrd(), cfg) end
	function target:CButton(cfg)     return _button(scroll, nextOrd(), cfg) end
	function target:CToggle(cfg)     return _toggle(scroll, nextOrd(), cfg) end
	function target:CSlider(cfg)     return _slider(scroll, nextOrd(), cfg) end
	function target:CDropdown(cfg)   return _dropdown(scroll, nextOrd(), cfg) end
	function target:CInput(cfg)      return _input(scroll, nextOrd(), cfg) end
	function target:CKeybind(cfg)    return _keybind(scroll, nextOrd(), cfg) end
end

local function attachAll(target, scroll, nextOrd)
	attachBase(target, scroll, nextOrd)

	function target:CSection(sCfg)
		sCfg = sCfg or {}
		local idx = nextOrd()

		local outer = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			AutomaticSize        = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder          = idx,
			Parent               = scroll,
		})
		lay(outer, Enum.FillDirection.Vertical, 0)

		-- Header
		local hdr = make("TextButton", {
			Size                 = UDim2.new(1, 0, 0, 32),
			BackgroundColor3     = T.elevated,
			BackgroundTransparency = 0.55,
			Text    = "",
			AutoButtonColor = false,
			LayoutOrder = 0,
			Parent  = outer,
		})
		corner(hdr, 10)

		local chevron = IconsAPI:Render(hdr, "chevron-down", 14, T.sub)
		if chevron then
			chevron.Position = UDim2.fromOffset(10, 9)
		end

		local hasIcon = sCfg.Icon and #sCfg.Icon > 0
		if hasIcon then
			local sIcon = IconsAPI:Render(hdr, sCfg.Icon, 14, T.text)
			if sIcon then sIcon.Position = UDim2.fromOffset(28, 9) end
		end

		make("TextLabel", {
			Size                 = UDim2.new(1, -40, 1, 0),
			Position             = UDim2.fromOffset(hasIcon and 48 or 28, 0),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamBold,
			TextSize             = 12,
			TextColor3           = T.text,
			TextXAlignment       = Enum.TextXAlignment.Left,
			Text                 = sCfg.Name or "Section",
			Parent               = hdr,
		})

		hdr.MouseEnter:Connect(function() tween(hdr, Ease.quick, { BackgroundTransparency = 0.35 }) end)
		hdr.MouseLeave:Connect(function() tween(hdr, Ease.quick, { BackgroundTransparency = 0.55 }) end)

		-- Clip wrapper
		local clip = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants     = true,
			LayoutOrder          = 1,
			Parent               = outer,
		})

		-- Content
		local content = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			AutomaticSize        = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent               = clip,
		})
		pad(content, 6, 2, 4, 0)
		local cLay = lay(content, Enum.FillDirection.Vertical, 5)

		local isOpen  = sCfg.Open ~= false
		local targetH = 0

		local function recalc()
			targetH = cLay.AbsoluteContentSize.Y + 12
			if isOpen then tween(clip, Ease.smooth, { Size = UDim2.new(1, 0, 0, targetH) }) end
		end
		cLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(recalc)
		task.defer(recalc)

		hdr.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			if isOpen then
				recalc()
				if chevron then tween(chevron, Ease.smooth, { Rotation = 0 }) end
			else
				tween(clip, Ease.smooth, { Size = UDim2.new(1, 0, 0, 0) })
				if chevron then tween(chevron, Ease.smooth, { Rotation = -90 }) end
			end
		end)

		if not isOpen then
			if chevron then chevron.Rotation = -90 end
			clip.Size = UDim2.new(1, 0, 0, 0)
		end

		local Section = {}
		local sIdx = 0
		attachBase(Section, content, function() sIdx += 1; return sIdx end)
		function Section:Toggle()
			isOpen = not isOpen
			if isOpen then 
				recalc()
				tween(clip, Ease.smooth, { Size = UDim2.new(1, 0, 0, targetH) })
				if chevron then tween(chevron, Ease.smooth, { Rotation = 0 }) end
			else 
				tween(clip, Ease.smooth, { Size = UDim2.new(1, 0, 0, 0) })
				if chevron then tween(chevron, Ease.smooth, { Rotation = -90 }) end
			end
		end
		function Section:Destroy() outer:Destroy() end
		return Section
	end
end

-- ═══════════════════════════════════════════════════
-- Window
-- ═══════════════════════════════════════════════════

function TahoeUI:CreateWindow(config)
	initGui()

	config = config or {}
	local title     = config.Title or "TahoeUI"
	local subtitle  = config.Subtitle or "v2.0"
	local winW      = config.Size and config.Size.X.Offset or 580
	local winH      = config.Size and config.Size.Y.Offset or 400
	local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
	local sideW     = 158

	-- Resolve theme
	local themeCfg = config.Theme or "Dark"
	if type(themeCfg) == "string" then
		T = table.clone(Themes[themeCfg] or Themes.Dark)
	elseif type(themeCfg) == "table" then
		T = mergeTheme(Themes.Dark, themeCfg)
	end

	-- Window Container (Handles positioning & size)
	local windowContainer = make("Frame", {
		Size                 = UDim2.fromOffset(winW, winH),
		Position             = UDim2.fromScale(0.5, 0.5),
		AnchorPoint          = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent               = screenGui,
	})

	-- DPI / Resolution Scaling
	local uiScale = make("UIScale", { Parent = windowContainer })
	local floatScale = nil -- will be created after floatBtn
	
	local function UpdateUIScale()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local vp = cam.ViewportSize
		-- If resolution is small (mobile), scale down appropriately
		if vp.X < 1000 or vp.Y < 700 then
			local sX = math.clamp(vp.X / 1100, 0.75, 1)
			local sY = math.clamp(vp.Y / 750, 0.75, 1)
			local finalScale = math.min(sX, sY)
			uiScale.Scale = finalScale
			if floatScale then floatScale.Scale = finalScale end
		else
			uiScale.Scale = 1
			if floatScale then floatScale.Scale = 1 end
		end
	end
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateUIScale)
	
	-- Canvas (For clipping and GroupTransparency)
	local canvas = make("CanvasGroup", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		GroupTransparency    = 1,
		BorderSizePixel      = 0,
		Parent               = windowContainer,
	})
	corner(canvas, 14)

	-- Stroke Frame (Separate to avoid CanvasGroup ghosting bug)
	local strokeFrame = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent               = windowContainer,
	})
	corner(strokeFrame, 14)
	local mainStroke = stroke(strokeFrame, T.glass, 0.84, 1.5)
	mainStroke.Transparency = 1

	-- Floating Toggle Button (For Hide/Show)
	local floatBtn = make("TextButton", {
		Size                 = UDim2.fromOffset(46, 46),
		AnchorPoint          = Vector2.new(1, 0.5),
		Position             = UDim2.new(1, 60, 0.5, 0),
		BackgroundColor3     = T.windowBg,
		BackgroundTransparency = 1,
		Text                 = "",
		Visible              = false,
		Parent               = screenGui,
	})
	corner(floatBtn, 23)
	local fStroke = stroke(floatBtn, T.glass, 1, 1.5)

	local floatIcon = IconsAPI:Render(floatBtn, "chevron-left", 24, T.text)
	if floatIcon then
		floatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		floatIcon.Position = UDim2.fromScale(0.5, 0.5)
		floatIcon.ImageTransparency = 1
	end
	
	floatScale = make("UIScale", { Parent = floatBtn })
	UpdateUIScale()
	
	local floatDragging, floatDragStart, floatStartPos = false, Vector3.zero, UDim2.new()
	floatBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			floatDragging = true
			floatDragStart = input.Position
			floatStartPos = floatBtn.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then floatDragging = false end
			end)
		end
	end)
	table.insert(conns, UserInput.InputChanged:Connect(function(input)
		if not floatDragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - floatDragStart
			tween(floatBtn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + d.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + d.Y)
			})
		end
	end))

	-- Frame (Main content background)
	local frame = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundColor3     = T.windowBg,
		BackgroundTransparency = T.windowTrans,
		BorderSizePixel      = 0,
		ClipsDescendants     = true,
		Parent               = canvas,
	})

	-- Glass sheen
	local sheen = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundColor3     = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.97,
		Parent               = frame,
	})
	corner(sheen, 14)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0,    0.86),
			NumberSequenceKeypoint.new(0.3,  0.96),
			NumberSequenceKeypoint.new(0.65, 0.99),
			NumberSequenceKeypoint.new(1,    0.92),
		}),
		Rotation = 140,
		Parent   = sheen,
	})

	-- ── Sidebar ────────────────────────────────────

	local sidebar = make("Frame", {
		Size                 = UDim2.new(0, sideW, 1, 0),
		BackgroundColor3     = T.sidebarBg,
		BackgroundTransparency = T.sidebarTrans,
		BorderSizePixel      = 0,
		Parent               = frame,
	})

	make("Frame", {
		Size                 = UDim2.new(0, 1, 1, -16),
		Position             = UDim2.new(0, sideW, 0, 8),
		BackgroundColor3     = T.border,
		BackgroundTransparency = 0.3,
		BorderSizePixel      = 0,
		Parent               = frame,
	})

	-- Traffic lights
	local trafficArea = make("Frame", {
		Size                 = UDim2.fromOffset(60, 14),
		Position             = UDim2.fromOffset(16, 15),
		BackgroundTransparency = 1,
		Parent               = sidebar,
	})
	lay(trafficArea, Enum.FillDirection.Horizontal, 8)

	local lights = {}
	local function makeLight(color, iconName)
		local btn = make("TextButton", {
			Size             = UDim2.fromOffset(12, 12),
			BackgroundColor3 = color,
			Text             = "",
			AutoButtonColor  = false,
			Parent           = trafficArea,
		})
		corner(btn, 6)
		local ic = IconsAPI:Render(btn, iconName, 8, Color3.new(0, 0, 0))
		if ic then
			ic.AnchorPoint = Vector2.new(0.5, 0.5)
			ic.Position = UDim2.fromScale(0.5, 0.5)
			ic.ImageTransparency = 1
		end
		table.insert(lights, { btn = btn, ic = ic })
		return btn
	end

	local closeBtn = makeLight(T.red,    "x")
	local minBtn   = makeLight(T.yellow, "minus")
	local maxBtn   = makeLight(T.green,  "plus")

	trafficArea.MouseEnter:Connect(function()
		for _, l in lights do if l.ic then l.ic.ImageTransparency = 0.4 end end
	end)
	trafficArea.MouseLeave:Connect(function()
		for _, l in lights do if l.ic then l.ic.ImageTransparency = 1 end end
	end)
	-- Title
	local titleLabel = make("TextLabel", {
		Size                 = UDim2.new(1, -24, 0, 17),
		Position             = UDim2.fromOffset(16, 40),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 14,
		TextColor3           = T.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextTruncate         = Enum.TextTruncate.AtEnd,
		Text                 = title,
		Parent               = sidebar,
	})

	make("TextLabel", {
		Size                 = UDim2.new(1, -24, 0, 12),
		Position             = UDim2.fromOffset(16, 59),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.Gotham,
		TextSize             = 10,
		TextColor3           = T.dim,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = subtitle,
		Parent               = sidebar,
	})

	-- Tab scroll
	local tabScroll = make("ScrollingFrame", {
		Size                 = UDim2.new(1, -20, 1, -108),
		Position             = UDim2.fromOffset(10, 82),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		ScrollBarThickness   = 0,
		CanvasSize           = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize  = Enum.AutomaticSize.Y,
		Active               = true,
		Parent               = sidebar,
	})
	lay(tabScroll, Enum.FillDirection.Vertical, 3)

	-- Branding (Removed for Tag support)

	-- ── Content Area ───────────────────────────────

	local contentArea = make("Frame", {
		Size                 = UDim2.new(1, -sideW - 1, 1, 0),
		Position             = UDim2.fromOffset(sideW + 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants     = true,
		Parent               = frame,
	})

	-- ── Dragging ───────────────────────────────────

	local dragging, dragStart, startPos = false, Vector3.zero, UDim2.new()

	local dragZone = make("Frame", {
		Size                 = UDim2.new(1, 0, 0, 40),
		Position             = UDim2.fromOffset(sideW + 1, 0),
		BackgroundTransparency = 1,
		Parent               = frame,
	})

	dragZone.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = input.Position
			startPos  = windowContainer.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then 
					dragging = false 
					tween(windowContainer, Ease.smooth, { Rotation = 0 })
				end
			end)
		end
	end)

	local resizing, resDragStart, resStartSize = false, Vector3.zero, UDim2.new()
	
	local resizeHandle = make("TextButton", {
		Size = UDim2.fromOffset(24, 24),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -2, 1, -2),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 10,
		Parent = frame,
	})
	local resIcon = IconsAPI:Render(resizeHandle, "scaling", 16, T.sub) or IconsAPI:Render(resizeHandle, "arrow-down-right", 16, T.sub)
	if resIcon then
		resIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		resIcon.Position = UDim2.fromScale(0.5, 0.5)
	end
	
	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resDragStart = input.Position
			resStartSize = windowContainer.Size
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then resizing = false end
			end)
		end
	end)

	local lastRot = 0
	table.insert(conns, UserInput.InputChanged:Connect(function(input)
		if dragging then
			if input.UserInputType ~= Enum.UserInputType.MouseMovement
				and input.UserInputType ~= Enum.UserInputType.Touch then return end
			local d = input.Position - dragStart
			
			local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			tween(windowContainer, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos })
			
			local deltaX = input.Delta.X
			local targetRot = math.clamp(deltaX * 0.15, -1.5, 1.5)
			lastRot = lastRot + (targetRot - lastRot) * 0.3
			tween(windowContainer, TweenInfo.new(0.1), { Rotation = lastRot })
			return
		end
		
		if resizing then
			if input.UserInputType ~= Enum.UserInputType.MouseMovement
				and input.UserInputType ~= Enum.UserInputType.Touch then return end
			local d = input.Position - resDragStart
			local newW = math.clamp(resStartSize.X.Offset + d.X, 400, 1600)
			local newH = math.clamp(resStartSize.Y.Offset + d.Y, 300, 1200)
			
			tween(windowContainer, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(newW, newH) })
			return
		end
	end))

	-- ── Open Animation ─────────────────────────────

	windowContainer.Size = UDim2.fromOffset(winW * 0.91, winH * 0.91)
	canvas.GroupTransparency = 1
	task.defer(function()
		tween(windowContainer, Ease.spring, { Size = UDim2.fromOffset(winW, winH) })
		tween(canvas, Ease.spring, { GroupTransparency = 0 })
		tween(mainStroke, Ease.spring, { Transparency = 0.84 })
	end)

	-- ── Toggle Visibility ──────────────────────────

	local visible = true
	local savedWinPos = UDim2.fromScale(0.5, 0.5)
	
	local function setVisibility(state)
		if visible == state then return end
		visible = state
		
		if visible then
			windowContainer.Visible = true
			tween(windowContainer, Ease.bounce, { Position = savedWinPos })
			tween(canvas, Ease.bounce, { GroupTransparency = 0 })
			
			tween(floatBtn, Ease.smooth, { Position = UDim2.new(1, 60, 0.5, 0), BackgroundTransparency = 1 })
			tween(fStroke, Ease.smooth, { Transparency = 1 })
			if floatIcon then tween(floatIcon, Ease.smooth, { ImageTransparency = 1 }) end
			task.delay(0.2, function() if visible then floatBtn.Visible = false end end)
		else
			savedWinPos = windowContainer.Position
			local tw = tween(windowContainer, Ease.quick, { Position = UDim2.new(1, winW * 1.5, savedWinPos.Y.Scale, savedWinPos.Y.Offset) })
			tween(canvas, Ease.quick, { GroupTransparency = 0.5 })
			tw.Completed:Connect(function() if not visible then windowContainer.Visible = false end end)
			
			floatBtn.Visible = true
			floatBtn.Position = UDim2.new(1, 60, 0.5, 0)
			tween(floatBtn, Ease.bounce, { Position = UDim2.new(1, -16, 0.5, 0), BackgroundTransparency = T.windowTrans })
			tween(fStroke, Ease.bounce, { Transparency = 0.8 })
			if floatIcon then tween(floatIcon, Ease.bounce, { ImageTransparency = 0 }) end
		end
	end

	floatBtn.MouseButton1Click:Connect(function()
		if not floatDragging then setVisibility(true) end
	end)

	table.insert(conns, UserInput.InputBegan:Connect(function(input, gpe)
		if gpe or input.KeyCode ~= toggleKey then return end
		setVisibility(not visible)
	end))

	-- ── Close / Minimize ───────────────────────────

	closeBtn.MouseButton1Click:Connect(function()
		local tw = tween(windowContainer, Ease.smooth, { Size = UDim2.fromOffset(winW * 0.88, winH * 0.88) })
		tween(canvas, Ease.smooth, { GroupTransparency = 1 })
		tween(mainStroke, Ease.smooth, { Transparency = 1 })
		tw.Completed:Connect(function() windowContainer:Destroy(); floatBtn:Destroy() end)
	end)

	minBtn.MouseButton1Click:Connect(function()
		setVisibility(false)
	end)

	-- ═══════════════════════════════════════════════
	-- Tab System
	-- ═══════════════════════════════════════════════

	local Window      = {}
	local currentPage = nil
	local tabGlobalIdx = 0

	local function createTabCore(btnParent, tabCfg)
		tabCfg = tabCfg or {}
		tabGlobalIdx += 1
		local myIdx   = tabGlobalIdx
		local tabName = tabCfg.Name or "Tab"
		local tabIcon = tabCfg.Icon

		-- Sidebar button
		local tabBtn = make("TextButton", {
			Size                 = UDim2.new(1, 0, 0, 30),
			BackgroundColor3     = T.accent,
			BackgroundTransparency = 1,
			Text    = "",
			AutoButtonColor = false,
			Parent  = btnParent,
		})
		corner(tabBtn, 8)

		local hasIcon = tabIcon and #tabIcon > 0
		local iconEl
		if hasIcon then
			iconEl = IconsAPI:Render(tabBtn, tabIcon, 16, T.sub)
			if iconEl then iconEl.Position = UDim2.fromOffset(10, 7) end
		end

		local tabLabel = make("TextLabel", {
			Size                 = UDim2.new(1, hasIcon and -38 or -20, 1, 0),
			Position             = UDim2.fromOffset(hasIcon and 32 or 10, 0),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamMedium,
			TextSize             = 12,
			TextColor3           = T.sub,
			TextXAlignment       = Enum.TextXAlignment.Left,
			TextTruncate         = Enum.TextTruncate.AtEnd,
			Text                 = tabName,
			Parent               = tabBtn,
		})

		-- Content page
		local page = make("CanvasGroup", {
			Size                 = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			GroupTransparency    = 1,
			Visible              = false,
			Parent               = contentArea,
		})

		make("TextLabel", {
			Size                 = UDim2.new(1, -36, 0, 20),
			Position             = UDim2.fromOffset(20, 12),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamBold,
			TextSize             = 16,
			TextColor3           = T.text,
			TextXAlignment       = Enum.TextXAlignment.Left,
			Text                 = tabName,
			Parent               = page,
		})

		local scr = make("ScrollingFrame", {
			Size                 = UDim2.new(1, 0, 1, -46),
			Position             = UDim2.fromOffset(0, 46),
			BackgroundTransparency = 1,
			BorderSizePixel      = 0,
			ScrollBarThickness   = 3,
			ScrollBarImageColor3 = T.dim,
			ScrollBarImageTransparency = 0.35,
			CanvasSize           = UDim2.new(0, 0, 0, 0),
			TopImage             = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			MidImage             = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			BottomImage          = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			Active               = true,
			Parent               = page,
		})
		pad(scr, 0, 14, 20, 20)
		local scrLay = lay(scr, Enum.FillDirection.Vertical, 5)
		scrLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scr.CanvasSize = UDim2.fromOffset(0, scrLay.AbsoluteContentSize.Y + 18)
		end)

		-- Slide + fade switching
		local function activate()
			local oldIdx = currentPage and currentPage.idx or myIdx
			local dir    = myIdx >= oldIdx and 1 or -1
			local slide  = 28

			if currentPage and currentPage.page ~= page then
				local old = currentPage
				tween(old.page, Ease.smooth, {
					GroupTransparency = 1,
					Position = UDim2.fromOffset(-slide * dir, 0),
				})
				tween(old.btn, Ease.quick, { BackgroundTransparency = 1 })
				tween(old.lbl, Ease.quick, { TextColor3 = T.sub })
				if old.icon then
					pcall(function()
						tween(old.icon, Ease.quick, { ImageColor3 = T.sub })
					end)
					pcall(function()
						tween(old.icon, Ease.quick, { TextColor3 = T.sub })
					end)
				end
				task.delay(0.28, function()
					if currentPage and currentPage.page ~= old.page then
						old.page.Visible  = false
						old.page.Position = UDim2.fromOffset(0, 0)
					end
				end)
			end

			page.Position         = UDim2.fromOffset(slide * dir, 0)
			page.Visible          = true
			page.GroupTransparency = 1
			tween(page, Ease.smooth, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) })
			tween(tabBtn, Ease.smooth, { BackgroundTransparency = 0.82 })
			tween(tabLabel, Ease.smooth, { TextColor3 = T.text })
			if iconEl then
				pcall(function() tween(iconEl, Ease.smooth, { ImageColor3 = T.text }) end)
				pcall(function() tween(iconEl, Ease.smooth, { TextColor3 = T.text }) end)
			end

			currentPage = { page = page, btn = tabBtn, lbl = tabLabel, idx = myIdx, icon = iconEl }
		end

		tabBtn.MouseButton1Click:Connect(activate)

		tabBtn.MouseEnter:Connect(function()
			if currentPage and currentPage.btn == tabBtn then return end
			tween(tabBtn, Ease.quick, { BackgroundTransparency = 0.9 })
		end)
		tabBtn.MouseLeave:Connect(function()
			if currentPage and currentPage.btn == tabBtn then return end
			tween(tabBtn, Ease.quick, { BackgroundTransparency = 1 })
		end)

		if not currentPage then task.defer(activate) end

		-- Build Tab API
		local Tab   = {}
		local cIdx  = 0
		attachAll(Tab, scr, function() cIdx += 1; return cIdx end)
		return Tab
	end

	-- ── Window API ─────────────────────────────────

	local tagArea
	function Window:Tag(cfg)
		if not tagArea then
			tagArea = make("Frame", {
				Size = UDim2.new(1, -32, 0, 26),
				Position = UDim2.new(0, 16, 1, -38),
				BackgroundTransparency = 1,
				Parent = sidebar
			})
			local tLay = lay(tagArea, Enum.FillDirection.Horizontal, 6)
			tLay.HorizontalAlignment = Enum.HorizontalAlignment.Left
		end
		
		local activeTag = make("Frame", {
			Size = UDim2.fromOffset(0, 26),
			BackgroundColor3 = cfg.Color or T.accent,
			Parent = tagArea
		})
		corner(activeTag, cfg.Radius ~= nil and cfg.Radius or 100)
		activeTag.AutomaticSize = Enum.AutomaticSize.X
		
		local padFrm = make("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0,0,1,0),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = activeTag
		})
		local innerLay = lay(padFrm, Enum.FillDirection.Horizontal, 6)
		innerLay.VerticalAlignment = Enum.VerticalAlignment.Center
		pad(padFrm, 0, 0, 8, 8)
		
		local ctext = Color3.new(0,0,0)
		
		if cfg.Icon then
			local ic = IconsAPI:Render(padFrm, cfg.Icon, 14, ctext)
			if ic then ic.LayoutOrder = 1 end
		end
		
		if cfg.Title then
			make("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextColor3 = ctext,
				Text = cfg.Title,
				LayoutOrder = 2,
				Parent = padFrm
			})
		end
		
		local obj = {}
		function obj:Destroy() activeTag:Destroy() end
		return obj
	end

	function Window:Popup(cfg)
		local popupBackdrop = make("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = T.surface,
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 100,
			Parent = screenGui
		})
		
		local modal = make("Frame", {
			Size = UDim2.fromOffset(360, 140),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = T.elevated,
			BackgroundTransparency = 0.05,
			ZIndex = 101,
			ClipsDescendants = true,
			Parent = popupBackdrop
		})
		local uis = make("UIScale", { Scale = 0.8, Parent = modal })
		corner(modal, 12)
		stroke(modal, T.border, 0.5, 1)
		
		tween(popupBackdrop, Ease.quick, { BackgroundTransparency = 0.4 })
		tween(uis, Ease.bounce, { Scale = 1 })
		
		local closePopup = function()
			tween(popupBackdrop, Ease.quick, { BackgroundTransparency = 1 })
			tween(uis, Ease.quick, { Scale = 0.8 })
			task.delay(0.2, function() popupBackdrop:Destroy() end)
		end
		
		local hdr = make("Frame", {
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundTransparency = 1,
			ZIndex = 102,
			Parent = modal
		})
		
		local iconSize = 0
		if cfg.Icon then
			iconSize = 24
			local ic = IconsAPI:Render(hdr, cfg.Icon, 18, T.dim)
			if ic then
				ic.AnchorPoint = Vector2.new(0, 0.5)
				ic.Position = UDim2.new(0, 16, 0.5, 0)
				ic.ZIndex = 102
			end
		end
		
		make("TextLabel", {
			Size = UDim2.new(1, -(32 + iconSize), 1, 0),
			Position = UDim2.fromOffset(16 + iconSize + (iconSize > 0 and 6 or 0), 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = T.text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = cfg.Title or "Popup",
			ZIndex = 102,
			Parent = hdr
		})
		
		local content = make("TextLabel", {
			Size = UDim2.new(1, -32, 1, -94),
			Position = UDim2.fromOffset(16, 44),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = T.sub,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Text = cfg.Content or "",
			ZIndex = 102,
			Parent = modal
		})
		
		local btnArea = make("Frame", {
			Size = UDim2.new(1, -32, 0, 32),
			Position = UDim2.new(0, 16, 1, -44),
			BackgroundTransparency = 1,
			ZIndex = 102,
			Parent = modal
		})
		local btnLay = lay(btnArea, Enum.FillDirection.Horizontal, 8)
		btnLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
		
		if cfg.Buttons then
			for _, bCfg in cfg.Buttons do
				local btn = make("TextButton", {
					Size = UDim2.fromOffset(90, 32),
					BackgroundColor3 = bCfg.Color or T.hover,
					BackgroundTransparency = bCfg.Color and 0.4 or 0.15,
					Font = Enum.Font.GothamMedium,
					TextSize = 12,
					TextColor3 = bCfg.Color and Color3.new(0,0,0) or T.text,
					Text = bCfg.Name or "Button",
					AutoButtonColor = false,
					ZIndex = 103,
					Parent = btnArea
				})
				corner(btn, 8)
				if not bCfg.Color then stroke(btn, T.border, 0.5, 1) end
				
				btn.MouseEnter:Connect(function() tween(btn, Ease.quick, { BackgroundTransparency = bCfg.Color and 0.2 or 0.05 }) end)
				btn.MouseLeave:Connect(function() tween(btn, Ease.quick, { BackgroundTransparency = bCfg.Color and 0.4 or 0.15 }) end)
				
				btn.MouseButton1Click:Connect(function()
					closePopup()
					if bCfg.Callback then task.spawn(bCfg.Callback) end
				end)
			end
		end
		
		local bH = content.TextBounds.Y
		local totalH = 44 + bH + 8 + 44
		modal.Size = UDim2.fromOffset(360, math.max(140, totalH))
	end

	function Window:CTab(cfg)
		return createTabCore(tabScroll, cfg)
	end

	function Window:CTabSection(tsCfg)
		tsCfg = tsCfg or {}

		local outer = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			AutomaticSize        = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent               = tabScroll,
		})
		lay(outer, Enum.FillDirection.Vertical, 0)

		local hdr = make("TextButton", {
			Size                 = UDim2.new(1, 0, 0, 22),
			BackgroundColor3     = T.elevated,
			BackgroundTransparency = 1,
			Text    = "",
			AutoButtonColor = false,
			LayoutOrder = 0,
			Parent  = outer,
		})
		corner(hdr, 4)

		make("TextLabel", {
			Size                 = UDim2.new(1, -24, 1, 0),
			Position             = UDim2.fromOffset(6, 0),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamBold,
			TextSize             = 9,
			TextColor3           = T.dim,
			TextXAlignment       = Enum.TextXAlignment.Left,
			Text                 = string.upper(tsCfg.Name or "Section"),
			Parent               = hdr,
		})

		local chev = IconsAPI:Render(hdr, "chevron-down", 12, T.dim)
		if chev then
			chev.AnchorPoint = Vector2.new(1, 0.5)
			chev.Position = UDim2.new(1, -6, 0.5, 0)
		end

		hdr.MouseEnter:Connect(function() tween(hdr, Ease.quick, { BackgroundTransparency = 0.82 }) end)
		hdr.MouseLeave:Connect(function() tween(hdr, Ease.quick, { BackgroundTransparency = 1 }) end)

		local tabClip = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants     = true,
			LayoutOrder          = 1,
			Parent               = outer,
		})

		local tabContent = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			AutomaticSize        = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent               = tabClip,
		})
		pad(tabContent, 2, 2, 0, 0)
		local tcLay = lay(tabContent, Enum.FillDirection.Vertical, 2)

		local tsOpen  = tsCfg.Open ~= false
		local tsH     = 0

		local function tsRecalc()
			tsH = tcLay.AbsoluteContentSize.Y + 6
			if tsOpen then tween(tabClip, Ease.smooth, { Size = UDim2.new(1, 0, 0, tsH) }) end
		end
		tcLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(tsRecalc)
		task.defer(tsRecalc)

		hdr.MouseButton1Click:Connect(function()
			tsOpen = not tsOpen
			if tsOpen then
				tsRecalc()
				if chev then tween(chev, Ease.smooth, { Rotation = 0 }) end
			else
				tween(tabClip, Ease.smooth, { Size = UDim2.new(1, 0, 0, 0) })
				if chev then tween(chev, Ease.smooth, { Rotation = -90 }) end
			end
		end)

		if not tsOpen and chev then chev.Rotation = -90 end

		local TabSection = {}
		function TabSection:CTab(cfg)
			return createTabCore(tabContent, cfg)
		end
		return TabSection
	end

	function Window:SetTitle(t) titleLabel.Text = t end

	function Window:Toggle()
		setVisibility(not visible)
	end

	function Window:Destroy()
		windowContainer:Destroy()
	end

	return Window
end

-- ═══════════════════════════════════════════════════
-- Notifications
-- ═══════════════════════════════════════════════════

function TahoeUI:Notify(nCfg)
	initGui()
	nCfg = nCfg or {}

	local typeCol = {
		info    = T.accent,
		success = T.green,
		warning = T.yellow,
		error   = T.red,
	}
	local nType     = string.lower(nCfg.Type or "info")
	local accentCol = typeCol[nType] or T.accent
	local dur       = nCfg.Duration or 3

	local notifContainer = make("Frame", {
		Size                 = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent               = notifHolder,
	})

	local notif = make("CanvasGroup", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		GroupTransparency    = 1,
		ZIndex               = 100,
		Parent               = notifContainer,
	})
	corner(notif, 12)
	
	local notifStroke = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex               = 100,
		Parent               = notifContainer,
	})
	corner(notifStroke, 12)
	stroke(notifStroke, T.glass, 0.84, 1)
	
	local notifBg = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundColor3     = T.windowBg,
		BackgroundTransparency = 0.1,
		ClipsDescendants     = true,
		ZIndex               = 100,
		Parent               = notif,
	})

	local bar = make("Frame", {
		Size                 = UDim2.new(0, 3, 1, -18),
		Position             = UDim2.fromOffset(10, 9),
		BackgroundColor3     = accentCol,
		ZIndex               = 101,
		Parent               = notifBg,
	})
	corner(bar, 2)
	
	local iconMap = {
		info    = "info",
		success = "check-circle-2",
		warning = "alert-triangle",
		error   = "x-circle",
	}
	local iName = iconMap[nType] or "info"
	local nIcon = IconsAPI:Render(notif, iName, 22, accentCol)
	local textOffset = 24
	if nIcon then
		nIcon.Position = UDim2.fromOffset(20, 22)
		nIcon.AnchorPoint = Vector2.new(0, 0.5)
		nIcon.ZIndex = 101
		textOffset = 52
		
		-- Icon pop animation
		nIcon.Size = UDim2.fromOffset(0, 0)
		nIcon.Rotation = -45
		task.delay(0.1, function()
			tween(nIcon, Ease.bounce, { Size = UDim2.fromOffset(22, 22), Rotation = 0 })
		end)
	end

	make("TextLabel", {
		Size                 = UDim2.new(1, -textOffset - 16, 0, 15),
		Position             = UDim2.fromOffset(textOffset, 12),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 12,
		TextColor3           = T.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = nCfg.Title or "Notification",
		ZIndex               = 101,
		Parent               = notif,
	})

	make("TextLabel", {
		Size                 = UDim2.new(1, -textOffset - 16, 0, 26),
		Position             = UDim2.fromOffset(textOffset, 30),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.Gotham,
		TextSize             = 10,
		TextColor3           = T.sub,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextYAlignment       = Enum.TextYAlignment.Top,
		TextWrapped          = true,
		Text                 = nCfg.Content or "",
		ZIndex               = 101,
		Parent               = notif,
	})

	local prog = make("Frame", {
		Size                 = UDim2.new(1, -20, 0, 2),
		Position             = UDim2.new(0, 10, 1, -7),
		BackgroundColor3     = accentCol,
		BackgroundTransparency = 0.4,
		ZIndex               = 101,
		Parent               = notif,
	})
	corner(prog, 1)

	local height = 64
	notifContainer.Size = UDim2.new(1, 0, 0, height + 4)
	
	-- Intro
	tween(notif, Ease.spring, { GroupTransparency = 0 })
	tween(prog, Ease.linear(dur), { Size = UDim2.new(0, 0, 0, 2) })

	task.delay(dur, function()
		tween(notif, Ease.smooth, { GroupTransparency = 1 })
		task.delay(0.28, function()
			tween(notifContainer, Ease.smooth, { Size = UDim2.new(1, 0, 0, 0) })
			task.delay(0.28, function() 
				notifContainer.Visible = false
				notifContainer:Destroy() 
			end)
		end)
	end)
end

-- ═══════════════════════════════════════════════════
-- Cleanup
-- ═══════════════════════════════════════════════════

function TahoeUI:Destroy()
	for _, c in conns do
		if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
	end
	table.clear(conns)
	if screenGui then screenGui:Destroy(); screenGui = nil end
end

function TahoeUI:SaveConfig(folderName, fileName)
	if not isfolder(folderName) then makefolder(folderName) end
	local data = {}
	for name, obj in TahoeUI.Flags do
		if obj.Get then
			local success, value = pcall(function() return obj:Get() end)
			if success then data[name] = value end
		end
	end
	writefile(folderName .. "/" .. fileName .. ".json", game:GetService("HttpService"):JSONEncode(data))
	TahoeUI:Notify({ Title = "Config Saved", Content = "Saved config: " .. fileName, Type = "success", Duration = 2 })
end

function TahoeUI:LoadConfig(folderName, fileName)
	local path = folderName .. "/" .. fileName .. ".json"
	if isfile(path) then
		local ok, decoded = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(path))
		end)
		if ok and type(decoded) == "table" then
			for name, value in decoded do
				if TahoeUI.Flags[name] and TahoeUI.Flags[name].Set then
					pcall(function() TahoeUI.Flags[name]:Set(value) end)
				end
			end
			TahoeUI:Notify({ Title = "Config Loaded", Content = "Loaded config: " .. fileName, Type = "success", Duration = 2 })
		else
			TahoeUI:Notify({ Title = "Config Error", Content = "Failed to parse config file.", Type = "error", Duration = 3 })
		end
	else
		TahoeUI:Notify({ Title = "Config Error", Content = "Config file not found.", Type = "error", Duration = 3 })
	end
end

return TahoeUI
