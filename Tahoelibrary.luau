--[[
	MadUI · v1.0.0
	Liquid Glass UI Library for Roblox
	Inspired by macOS Tahoe

	Load:
		local MadUI = loadstring(game:HttpService:GetAsync("https://raw.githubusercontent.com/hamaddddds/Tahoe-library/main/Tahoelibrary.luau"))()

	Quick Start:
		local Window = MadUI:CreateWindow({
			Title    = "My App",
			Subtitle = "v1.0",
			Size     = UDim2.fromOffset(580, 400),
		})

		local Tab = Window:CreateTab({ Name = "General", Icon = "⚙" })

		Tab:CreateButton({
			Name        = "Execute",
			Description = "Runs the script",
			Callback    = function() print("clicked") end,
		})

		Tab:CreateToggle({
			Name     = "Auto Farm",
			Default  = false,
			Callback = function(state) print(state) end,
		})

		Tab:CreateSlider({
			Name      = "Walk Speed",
			Min       = 16,
			Max       = 200,
			Default   = 16,
			Increment = 1,
			Callback  = function(val) print(val) end,
		})

		Tab:CreateDropdown({
			Name     = "Team",
			Options  = {"Red", "Blue", "Green"},
			Default  = "Red",
			Callback = function(opt) print(opt) end,
		})

		Tab:CreateInput({
			Name        = "Target",
			Placeholder = "Username...",
			Callback    = function(text) print(text) end,
		})

		Tab:CreateKeybind({
			Name     = "Toggle UI",
			Default  = Enum.KeyCode.RightShift,
			Callback = function() print("pressed") end,
		})

		MadUI:Notify({
			Title    = "Ready",
			Content  = "MadUI loaded successfully.",
			Duration = 3,
			Type     = "success",
		})
]]

local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local UserInput     = game:GetService("UserInputService")
local player        = Players.LocalPlayer

-- ── Easing ──────────────────────────────────────────

local Ease = {
	smooth = TweenInfo.new(0.30, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	spring = TweenInfo.new(0.42, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
	quick  = TweenInfo.new(0.14, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
	slow   = TweenInfo.new(0.50, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	linear = function(d)
		return TweenInfo.new(d, Enum.EasingStyle.Linear)
	end,
}

-- ── Palette (macOS Tahoe Dark) ──────────────────────

local C = {
	bg       = Color3.fromRGB(24, 24, 28),
	surface  = Color3.fromRGB(30, 30, 35),
	elevated = Color3.fromRGB(42, 42, 48),
	hover    = Color3.fromRGB(54, 54, 60),

	accent    = Color3.fromRGB(10, 132, 255),
	accentDim = Color3.fromRGB(8,  100, 200),

	text = Color3.fromRGB(255, 255, 255),
	sub  = Color3.fromRGB(142, 142, 148),
	dim  = Color3.fromRGB(88,  88,  96),

	border = Color3.fromRGB(52, 52, 58),
	glass  = Color3.fromRGB(255, 255, 255),

	red    = Color3.fromRGB(255, 69,  58),
	yellow = Color3.fromRGB(255, 189, 46),
	green  = Color3.fromRGB(50,  205, 75),
}

-- ── Utility ─────────────────────────────────────────

local function make(class: string, props: {[string]: any}, children: {Instance}?): Instance
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

local function tween(obj: Instance, info: TweenInfo, goals: {[string]: any})
	local tw = TweenService:Create(obj, info, goals)
	tw:Play()
	return tw
end

local function corner(parent: Instance, r: number)
	return make("UICorner", { CornerRadius = UDim.new(0, r), Parent = parent })
end

local function stroke(parent: Instance, col: Color3?, trans: number?, thick: number?)
	return make("UIStroke", {
		Color            = col or C.glass,
		Transparency     = trans or 0.92,
		Thickness        = thick or 1,
		ApplyStrokeMode  = Enum.ApplyStrokeMode.Border,
		Parent           = parent,
	})
end

local function pad(parent: Instance, t: number, b: number, l: number, r: number)
	return make("UIPadding", {
		PaddingTop    = UDim.new(0, t),
		PaddingBottom = UDim.new(0, b),
		PaddingLeft   = UDim.new(0, l),
		PaddingRight  = UDim.new(0, r),
		Parent        = parent,
	})
end

local function list(parent: Instance, dir: Enum.FillDirection?, gap: number?)
	return make("UIListLayout", {
		FillDirection = dir or Enum.FillDirection.Vertical,
		Padding       = UDim.new(0, gap or 4),
		SortOrder     = Enum.SortOrder.LayoutOrder,
		Parent        = parent,
	})
end

-- ── Library State ───────────────────────────────────

local MadUI           = {}
local screenGui       = nil
local dropBackdrop    = nil
local notifHolder     = nil
local conns: {RBXScriptConnection} = {}
local activeDropClose = nil

local function initGui()
	if screenGui then return end

	screenGui = make("ScreenGui", {
		Name              = "MadUI",
		DisplayOrder      = 9999,
		ZIndexBehavior    = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn      = false,
		IgnoreGuiInset    = true,
	})

	pcall(function()
		if syn then syn.protect_gui(screenGui) end
	end)

	local ok = pcall(function()
		screenGui.Parent = game:GetService("CoreGui")
	end)
	if not ok then
		pcall(function()
			screenGui.Parent = player:WaitForChild("PlayerGui")
		end)
	end

	dropBackdrop = make("TextButton", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text                 = "",
		ZIndex               = 50,
		Visible              = false,
		Parent               = screenGui,
	})
	dropBackdrop.MouseButton1Click:Connect(function()
		if activeDropClose then
			activeDropClose()
			activeDropClose = nil
		end
		dropBackdrop.Visible = false
	end)

	notifHolder = make("Frame", {
		Size                 = UDim2.new(0, 300, 1, -24),
		Position             = UDim2.new(1, -12, 0, 12),
		AnchorPoint          = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		ZIndex               = 100,
		Parent               = screenGui,
	})
	list(notifHolder, Enum.FillDirection.Vertical, 8)
end

-- ── Row Factory ─────────────────────────────────────

local function createRow(parent: Instance, cfg: {[string]: any}, order: number)
	local hasDesc = cfg.Description and #cfg.Description > 0
	local h = hasDesc and 58 or 42

	local row = make("Frame", {
		Size                 = UDim2.new(1, 0, 0, h),
		BackgroundColor3     = C.elevated,
		BackgroundTransparency = 0.45,
		LayoutOrder          = order,
		ClipsDescendants     = true,
		Parent               = parent,
	})
	corner(row, 8)
	stroke(row, C.glass, 0.94, 1)

	row.MouseEnter:Connect(function()
		tween(row, Ease.quick, { BackgroundTransparency = 0.25 })
	end)
	row.MouseLeave:Connect(function()
		tween(row, Ease.quick, { BackgroundTransparency = 0.45 })
	end)

	make("TextLabel", {
		Size                 = UDim2.new(0.52, 0, 0, 18),
		Position             = UDim2.fromOffset(14, hasDesc and 10 or 12),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 13,
		TextColor3           = C.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextTruncate         = Enum.TextTruncate.AtEnd,
		Text                 = cfg.Name or "",
		Parent               = row,
	})

	if hasDesc then
		make("TextLabel", {
			Size                 = UDim2.new(0.62, 0, 0, 14),
			Position             = UDim2.fromOffset(14, 32),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.Gotham,
			TextSize             = 11,
			TextColor3           = C.sub,
			TextXAlignment       = Enum.TextXAlignment.Left,
			TextTruncate         = Enum.TextTruncate.AtEnd,
			Text                 = cfg.Description,
			Parent               = row,
		})
	end

	return row
end

-- ═══════════════════════════════════════════════════
-- Window
-- ═══════════════════════════════════════════════════

function MadUI:CreateWindow(config)
	initGui()

	config = config or {}
	local title     = config.Title or "MadUI"
	local subtitle  = config.Subtitle or "v1.0"
	local winW      = config.Size and config.Size.X.Offset or 580
	local winH      = config.Size and config.Size.Y.Offset or 400
	local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
	local sideW     = 158

	-- Canvas wrapper for group transparency
	local canvas = make("CanvasGroup", {
		Size                 = UDim2.fromOffset(winW, winH),
		Position             = UDim2.fromScale(0.5, 0.5),
		AnchorPoint          = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		GroupTransparency    = 1,
		Parent               = screenGui,
	})

	-- Main frame
	local frame = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundColor3     = C.bg,
		ClipsDescendants     = true,
		Parent               = canvas,
	})
	corner(frame, 14)
	stroke(frame, C.glass, 0.86, 1.5)

	-- Glass sheen overlay
	local sheen = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundColor3     = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.97,
		Parent               = frame,
	})
	corner(sheen, 14)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0,    0.88),
			NumberSequenceKeypoint.new(0.3,  0.97),
			NumberSequenceKeypoint.new(0.65, 0.99),
			NumberSequenceKeypoint.new(1,    0.93),
		}),
		Rotation = 140,
		Parent   = sheen,
	})

	-- ── Sidebar ────────────────────────────────────

	local sidebar = make("Frame", {
		Size                 = UDim2.new(0, sideW, 1, 0),
		BackgroundColor3     = C.surface,
		BackgroundTransparency = 0.12,
		BorderSizePixel      = 0,
		Parent               = frame,
	})

	-- Divider
	make("Frame", {
		Size                 = UDim2.new(0, 1, 1, -20),
		Position             = UDim2.new(0, sideW, 0, 10),
		BackgroundColor3     = C.border,
		BackgroundTransparency = 0.35,
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
	list(trafficArea, Enum.FillDirection.Horizontal, 8)

	local lights = {}
	local function makeLight(color, sym)
		local btn = make("TextButton", {
			Size             = UDim2.fromOffset(12, 12),
			BackgroundColor3 = color,
			Text             = "",
			Font             = Enum.Font.GothamBold,
			TextSize         = 8,
			TextColor3       = Color3.fromRGB(0, 0, 0),
			TextTransparency = 0.3,
			AutoButtonColor  = false,
			Parent           = trafficArea,
		})
		corner(btn, 6)
		table.insert(lights, { btn = btn, sym = sym })
		return btn
	end

	local closeBtn = makeLight(C.red,    "✕")
	local minBtn   = makeLight(C.yellow, "–")
	makeLight(C.green, "+")

	trafficArea.MouseEnter:Connect(function()
		for _, l in lights do l.btn.Text = l.sym end
	end)
	trafficArea.MouseLeave:Connect(function()
		for _, l in lights do l.btn.Text = "" end
	end)

	-- Title block
	local titleLabel = make("TextLabel", {
		Size                 = UDim2.new(1, -24, 0, 17),
		Position             = UDim2.fromOffset(16, 40),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 14,
		TextColor3           = C.text,
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
		TextColor3           = C.dim,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = subtitle,
		Parent               = sidebar,
	})

	-- Tab list (scrollable)
	local tabScroll = make("ScrollingFrame", {
		Size                 = UDim2.new(1, -20, 1, -108),
		Position             = UDim2.fromOffset(10, 82),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		ScrollBarThickness   = 0,
		CanvasSize           = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize  = Enum.AutomaticSize.Y,
		Parent               = sidebar,
	})
	local tabListLayout = list(tabScroll, Enum.FillDirection.Vertical, 2)

	-- Branding
	make("TextLabel", {
		Size                 = UDim2.new(1, -24, 0, 14),
		Position             = UDim2.new(0, 16, 1, -26),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.Gotham,
		TextSize             = 10,
		TextColor3           = C.dim,
		TextTransparency     = 0.4,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = "MadUI",
		Parent               = sidebar,
	})

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
			startPos  = canvas.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	table.insert(conns, UserInput.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then return end

		local delta = input.Position - dragStart
		canvas.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end))

	-- ── Open Animation ─────────────────────────────

	canvas.Size             = UDim2.fromOffset(winW * 0.92, winH * 0.92)
	canvas.GroupTransparency = 1

	task.defer(function()
		tween(canvas, Ease.spring, {
			Size             = UDim2.fromOffset(winW, winH),
			GroupTransparency = 0,
		})
	end)

	-- ── Visibility Toggle ──────────────────────────

	local visible = true

	table.insert(conns, UserInput.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode ~= toggleKey then return end

		visible = not visible
		if visible then
			canvas.Visible = true
			tween(canvas, Ease.spring, {
				Size             = UDim2.fromOffset(winW, winH),
				GroupTransparency = 0,
			})
		else
			local tw = tween(canvas, Ease.smooth, {
				Size             = UDim2.fromOffset(winW * 0.95, winH * 0.95),
				GroupTransparency = 1,
			})
			tw.Completed:Connect(function()
				if not visible then canvas.Visible = false end
			end)
		end
	end))

	-- ── Close / Minimize ───────────────────────────

	closeBtn.MouseButton1Click:Connect(function()
		local tw = tween(canvas, Ease.smooth, {
			Size             = UDim2.fromOffset(winW * 0.88, winH * 0.88),
			GroupTransparency = 1,
		})
		tw.Completed:Connect(function()
			canvas:Destroy()
		end)
	end)

	minBtn.MouseButton1Click:Connect(function()
		visible = false
		local tw = tween(canvas, Ease.smooth, {
			Size             = UDim2.fromOffset(winW * 0.95, winH * 0.95),
			GroupTransparency = 1,
		})
		tw.Completed:Connect(function()
			if not visible then canvas.Visible = false end
		end)
	end)

	-- ═══════════════════════════════════════════════
	-- Tab System
	-- ═══════════════════════════════════════════════

	local Window      = {}
	local currentPage = nil
	local tabIndex    = 0

	function Window:CreateTab(tabCfg)
		tabCfg = tabCfg or {}
		tabIndex += 1
		local tabName = tabCfg.Name or "Tab"
		local tabIcon = tabCfg.Icon or ""
		local myIndex = tabIndex

		-- Sidebar button
		local tabBtn = make("TextButton", {
			Size             = UDim2.new(1, 0, 0, 30),
			BackgroundColor3 = C.accent,
			BackgroundTransparency = 1,
			Text             = "",
			AutoButtonColor  = false,
			LayoutOrder      = myIndex,
			Parent           = tabScroll,
		})
		corner(tabBtn, 7)

		local hasIcon = #tabIcon > 0
		if hasIcon then
			make("TextLabel", {
				Size                 = UDim2.fromOffset(20, 30),
				Position             = UDim2.fromOffset(10, 0),
				BackgroundTransparency = 1,
				Font                 = Enum.Font.Gotham,
				TextSize             = 14,
				TextColor3           = C.sub,
				Text                 = tabIcon,
				Parent               = tabBtn,
			})
		end

		local tabLabel = make("TextLabel", {
			Size                 = UDim2.new(1, hasIcon and -38 or -20, 1, 0),
			Position             = UDim2.fromOffset(hasIcon and 32 or 10, 0),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamMedium,
			TextSize             = 12,
			TextColor3           = C.sub,
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

		-- Page title
		make("TextLabel", {
			Size                 = UDim2.new(1, -36, 0, 20),
			Position             = UDim2.fromOffset(20, 12),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamBold,
			TextSize             = 16,
			TextColor3           = C.text,
			TextXAlignment       = Enum.TextXAlignment.Left,
			Text                 = tabName,
			Parent               = page,
		})

		-- Scrollable content
		local scroll = make("ScrollingFrame", {
			Size                 = UDim2.new(1, 0, 1, -46),
			Position             = UDim2.fromOffset(0, 46),
			BackgroundTransparency = 1,
			BorderSizePixel      = 0,
			ScrollBarThickness   = 3,
			ScrollBarImageColor3 = C.dim,
			ScrollBarImageTransparency = 0.35,
			CanvasSize           = UDim2.new(0, 0, 0, 0),
			TopImage             = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			MidImage             = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			BottomImage          = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			Parent               = page,
		})
		pad(scroll, 0, 14, 20, 20)

		local scrollList = list(scroll, Enum.FillDirection.Vertical, 5)
		scrollList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scroll.CanvasSize = UDim2.fromOffset(0, scrollList.AbsoluteContentSize.Y + 18)
		end)

		-- Switching
		local function activate()
			if currentPage then
				local old = currentPage
				tween(old.page, Ease.quick, { GroupTransparency = 1 })
				tween(old.btn, Ease.quick, { BackgroundTransparency = 1 })
				tween(old.lbl, Ease.quick, { TextColor3 = C.sub })
				task.delay(0.14, function()
					if currentPage ~= old then old.page.Visible = false end
				end)
			end

			page.Visible = true
			page.GroupTransparency = 1
			tween(page, Ease.smooth, { GroupTransparency = 0 })
			tween(tabBtn, Ease.smooth, { BackgroundTransparency = 0.84 })
			tween(tabLabel, Ease.smooth, { TextColor3 = C.text })

			currentPage = { page = page, btn = tabBtn, lbl = tabLabel }
		end

		tabBtn.MouseButton1Click:Connect(activate)

		tabBtn.MouseEnter:Connect(function()
			if currentPage and currentPage.btn == tabBtn then return end
			tween(tabBtn, Ease.quick, { BackgroundTransparency = 0.92 })
		end)
		tabBtn.MouseLeave:Connect(function()
			if currentPage and currentPage.btn == tabBtn then return end
			tween(tabBtn, Ease.quick, { BackgroundTransparency = 1 })
		end)

		if myIndex == 1 then task.defer(activate) end

		-- ═══════════════════════════════════════════
		-- Components
		-- ═══════════════════════════════════════════

		local Tab     = {}
		local compIdx = 0

		-- ── Section ────────────────────────────────

		function Tab:CreateSection(name: string)
			compIdx += 1

			local sec = make("Frame", {
				Size                 = UDim2.new(1, 0, 0, 30),
				BackgroundTransparency = 1,
				LayoutOrder          = compIdx,
				Parent               = scroll,
			})

			make("TextLabel", {
				Size                 = UDim2.new(1, 0, 0, 12),
				Position             = UDim2.fromOffset(2, 14),
				BackgroundTransparency = 1,
				Font                 = Enum.Font.GothamBold,
				TextSize             = 10,
				TextColor3           = C.dim,
				TextXAlignment       = Enum.TextXAlignment.Left,
				Text                 = string.upper(name),
				Parent               = sec,
			})

			-- Thin separator line
			make("Frame", {
				Size                 = UDim2.new(1, -4, 0, 1),
				Position             = UDim2.new(0, 2, 1, -1),
				BackgroundColor3     = C.border,
				BackgroundTransparency = 0.6,
				BorderSizePixel      = 0,
				Parent               = sec,
			})

			return sec
		end

		-- ── Label ──────────────────────────────────

		function Tab:CreateLabel(text: string)
			compIdx += 1

			local lbl = make("TextLabel", {
				Size                 = UDim2.new(1, 0, 0, 22),
				BackgroundTransparency = 1,
				Font                 = Enum.Font.GothamMedium,
				TextSize             = 12,
				TextColor3           = C.sub,
				TextXAlignment       = Enum.TextXAlignment.Left,
				Text                 = text,
				LayoutOrder          = compIdx,
				Parent               = scroll,
			})

			local obj = {}
			function obj:Set(t: string) lbl.Text = t end
			function obj:Destroy() lbl:Destroy() end
			return obj
		end

		-- ── Paragraph ──────────────────────────────

		function Tab:CreateParagraph(pCfg)
			compIdx += 1

			local row = make("Frame", {
				Size                 = UDim2.new(1, 0, 0, 0),
				AutomaticSize        = Enum.AutomaticSize.Y,
				BackgroundColor3     = C.elevated,
				BackgroundTransparency = 0.45,
				LayoutOrder          = compIdx,
				Parent               = scroll,
			})
			corner(row, 8)
			stroke(row, C.glass, 0.94, 1)
			pad(row, 12, 14, 14, 14)
			list(row, Enum.FillDirection.Vertical, 6)

			local pTitle = make("TextLabel", {
				Size                 = UDim2.new(1, 0, 0, 16),
				BackgroundTransparency = 1,
				Font                 = Enum.Font.GothamBold,
				TextSize             = 13,
				TextColor3           = C.text,
				TextXAlignment       = Enum.TextXAlignment.Left,
				Text                 = pCfg.Title or "",
				LayoutOrder          = 1,
				Parent               = row,
			})

			local pBody = make("TextLabel", {
				Size                 = UDim2.new(1, 0, 0, 0),
				AutomaticSize        = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Font                 = Enum.Font.Gotham,
				TextSize             = 11,
				TextColor3           = C.sub,
				TextXAlignment       = Enum.TextXAlignment.Left,
				TextWrapped          = true,
				Text                 = pCfg.Content or "",
				LayoutOrder          = 2,
				Parent               = row,
			})

			local obj = {}
			function obj:Set(cfg)
				if cfg.Title then pTitle.Text = cfg.Title end
				if cfg.Content then pBody.Text = cfg.Content end
			end
			function obj:Destroy() row:Destroy() end
			return obj
		end

		-- ── Button ─────────────────────────────────

		function Tab:CreateButton(bCfg)
			compIdx += 1
			local row = createRow(scroll, bCfg, compIdx)

			make("TextLabel", {
				Size                 = UDim2.fromOffset(16, 18),
				Position             = UDim2.new(1, -14, 0.5, 0),
				AnchorPoint          = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Font                 = Enum.Font.GothamBold,
				TextSize             = 16,
				TextColor3           = C.dim,
				Text                 = "›",
				Parent               = row,
			})

			local click = make("TextButton", {
				Size                 = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text                 = "",
				AutoButtonColor      = false,
				Parent               = row,
			})

			click.MouseButton1Click:Connect(function()
				tween(row, Ease.quick, { BackgroundTransparency = 0.08 })
				task.delay(0.1, function()
					tween(row, Ease.smooth, { BackgroundTransparency = 0.45 })
				end)
				if bCfg.Callback then task.spawn(bCfg.Callback) end
			end)

			local obj = {}
			function obj:Destroy() row:Destroy() end
			return obj
		end

		-- ── Toggle ─────────────────────────────────

		function Tab:CreateToggle(tCfg)
			compIdx += 1
			local row = createRow(scroll, tCfg, compIdx)

			local switchBg = make("Frame", {
				Size             = UDim2.fromOffset(38, 20),
				Position         = UDim2.new(1, -14, 0.5, 0),
				AnchorPoint      = Vector2.new(1, 0.5),
				BackgroundColor3 = C.hover,
				Parent           = row,
			})
			corner(switchBg, 10)

			local thumb = make("Frame", {
				Size             = UDim2.fromOffset(16, 16),
				Position         = UDim2.fromOffset(2, 2),
				BackgroundColor3 = C.text,
				Parent           = switchBg,
			})
			corner(thumb, 8)
			stroke(thumb, Color3.new(0, 0, 0), 0.86, 1)

			local toggled = tCfg.Default or false

			local function refresh(state, anim)
				toggled = state
				local info = anim ~= false and Ease.smooth or TweenInfo.new(0)
				tween(thumb, info, {
					Position = state
						and UDim2.fromOffset(20, 2)
						or  UDim2.fromOffset(2, 2),
				})
				tween(switchBg, info, {
					BackgroundColor3 = state and C.accent or C.hover,
				})
			end

			refresh(toggled, false)

			local click = make("TextButton", {
				Size             = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text             = "",
				AutoButtonColor  = false,
				Parent           = row,
			})

			click.MouseButton1Click:Connect(function()
				refresh(not toggled, true)
				if tCfg.Callback then task.spawn(tCfg.Callback, toggled) end
			end)

			local obj = {}
			function obj:Set(v)
				refresh(v, true)
				if tCfg.Callback then task.spawn(tCfg.Callback, toggled) end
			end
			function obj:Get() return toggled end
			function obj:Destroy() row:Destroy() end
			return obj
		end

		-- ── Slider ─────────────────────────────────

		function Tab:CreateSlider(sCfg)
			compIdx += 1
			local mn  = sCfg.Min or 0
			local mx  = sCfg.Max or 100
			local inc = sCfg.Increment or 1
			local def = math.clamp(sCfg.Default or mn, mn, mx)

			local hasDesc = sCfg.Description and #sCfg.Description > 0
			local row = createRow(scroll, sCfg, compIdx)
			row.Size = UDim2.new(1, 0, 0, hasDesc and 68 or 52)

			-- Value readout
			local valLbl = make("TextLabel", {
				Size                 = UDim2.fromOffset(52, 16),
				Position             = UDim2.new(1, -14, 0, hasDesc and 10 or 8),
				AnchorPoint          = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Font                 = Enum.Font.GothamMedium,
				TextSize             = 12,
				TextColor3           = C.sub,
				TextXAlignment       = Enum.TextXAlignment.Right,
				Text                 = tostring(def),
				Parent               = row,
			})

			-- Track
			local trackY = hasDesc and 46 or 34
			local track = make("Frame", {
				Size             = UDim2.new(1, -28, 0, 4),
				Position         = UDim2.fromOffset(14, trackY),
				BackgroundColor3 = C.hover,
				Parent           = row,
			})
			corner(track, 2)

			local fill = make("Frame", {
				Size             = UDim2.fromScale(0, 1),
				BackgroundColor3 = C.accent,
				Parent           = track,
			})
			corner(fill, 2)

			local knob = make("Frame", {
				Size             = UDim2.fromOffset(14, 14),
				Position         = UDim2.fromScale(0, 0.5),
				AnchorPoint      = Vector2.new(0.5, 0.5),
				BackgroundColor3 = C.text,
				ZIndex           = 3,
				Parent           = track,
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

				if fire and sCfg.Callback then
					task.spawn(sCfg.Callback, value)
				end
			end

			update((def - mn) / (mx - mn), false)

			track.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = true
					local p = math.clamp(
						(input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1
					)
					update(p, true)
				end
			end)

			knob.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = true
				end
			end)

			table.insert(conns, UserInput.InputChanged:Connect(function(input)
				if not sliding then return end
				if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
				local p = math.clamp(
					(input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1
				)
				update(p, true)
			end))

			table.insert(conns, UserInput.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = false
				end
			end))

			local obj = {}
			function obj:Set(v)
				value = math.clamp(v, mn, mx)
				update((value - mn) / (mx - mn), false)
			end
			function obj:Get() return value end
			function obj:Destroy() row:Destroy() end
			return obj
		end

		-- ── Dropdown ───────────────────────────────

		function Tab:CreateDropdown(dCfg)
			compIdx += 1
			local row = createRow(scroll, dCfg, compIdx)

			local options  = dCfg.Options or {}
			local selected = dCfg.Default or options[1] or ""

			local dropBtn = make("TextButton", {
				Size                 = UDim2.new(0.42, 0, 0, 24),
				Position             = UDim2.new(1, -14, 0.5, 0),
				AnchorPoint          = Vector2.new(1, 0.5),
				BackgroundColor3     = C.hover,
				BackgroundTransparency = 0.15,
				Font                 = Enum.Font.GothamMedium,
				TextSize             = 11,
				TextColor3           = C.text,
				Text                 = " " .. selected .. "  ▾",
				AutoButtonColor      = false,
				ClipsDescendants     = true,
				TextTruncate         = Enum.TextTruncate.AtEnd,
				Parent               = row,
			})
			corner(dropBtn, 6)
			stroke(dropBtn, C.border, 0.6, 1)
			pad(dropBtn, 0, 0, 8, 4)

			-- Floating popup
			local popup = make("Frame", {
				BackgroundColor3     = C.surface,
				BackgroundTransparency = 0.04,
				Visible              = false,
				ZIndex               = 55,
				ClipsDescendants     = true,
				Parent               = screenGui,
			})
			corner(popup, 8)
			stroke(popup, C.border, 0.45, 1)
			pad(popup, 4, 4, 4, 4)
			local popList = list(popup, Enum.FillDirection.Vertical, 2)

			local isOpen     = false
			local optBtns    = {}
			local closePopup -- forward decl

			local function buildOpts()
				for _, b in optBtns do b:Destroy() end
				optBtns = {}

				for i, opt in options do
					local ob = make("TextButton", {
						Size                 = UDim2.new(1, 0, 0, 26),
						BackgroundColor3     = C.elevated,
						BackgroundTransparency = 0.5,
						Font                 = Enum.Font.GothamMedium,
						TextSize             = 11,
						TextColor3           = opt == selected and C.accent or C.text,
						Text                 = opt,
						AutoButtonColor      = false,
						LayoutOrder          = i,
						Parent               = popup,
					})
					corner(ob, 5)

					ob.MouseEnter:Connect(function()
						tween(ob, Ease.quick, { BackgroundTransparency = 0.15 })
					end)
					ob.MouseLeave:Connect(function()
						tween(ob, Ease.quick, { BackgroundTransparency = 0.5 })
					end)

					ob.MouseButton1Click:Connect(function()
						selected = opt
						dropBtn.Text = " " .. opt .. "  ▾"
						closePopup()
						if dCfg.Callback then task.spawn(dCfg.Callback, opt) end
					end)

					table.insert(optBtns, ob)
				end
			end

			closePopup = function()
				if not isOpen then return end
				isOpen = false
				tween(popup, Ease.quick, {
					Size = UDim2.fromOffset(popup.AbsoluteSize.X, 0),
				})
				task.delay(0.14, function()
					if not isOpen then popup.Visible = false end
				end)
				dropBackdrop.Visible = false
			end

			local function openPopup()
				buildOpts()
				local ap = dropBtn.AbsolutePosition
				local as = dropBtn.AbsoluteSize

				popup.Position = UDim2.fromOffset(ap.X, ap.Y + as.Y + 4)
				popup.Size     = UDim2.fromOffset(math.max(as.X, 130), 0)
				popup.Visible  = true

				local targetH = #options * 28 + math.max(#options - 1, 0) * 2 + 8
				tween(popup, Ease.spring, {
					Size = UDim2.fromOffset(math.max(as.X, 130), targetH),
				})

				dropBackdrop.Visible = true
				isOpen = true
			end

			dropBtn.MouseButton1Click:Connect(function()
				if isOpen then
					closePopup()
				else
					if activeDropClose and activeDropClose ~= closePopup then
						activeDropClose()
					end
					activeDropClose = closePopup
					openPopup()
				end
			end)

			local obj = {}
			function obj:Set(val)
				selected     = val
				dropBtn.Text = " " .. val .. "  ▾"
				if dCfg.Callback then task.spawn(dCfg.Callback, val) end
			end
			function obj:Refresh(newOpts)
				options = newOpts
				if not table.find(options, selected) then
					selected     = options[1] or ""
					dropBtn.Text = " " .. selected .. "  ▾"
				end
			end
			function obj:Get() return selected end
			function obj:Destroy()
				popup:Destroy()
				row:Destroy()
			end
			return obj
		end

		-- ── Input ──────────────────────────────────

		function Tab:CreateInput(iCfg)
			compIdx += 1
			local row = createRow(scroll, iCfg, compIdx)

			local box = make("TextBox", {
				Size                 = UDim2.new(0.42, 0, 0, 24),
				Position             = UDim2.new(1, -14, 0.5, 0),
				AnchorPoint          = Vector2.new(1, 0.5),
				BackgroundColor3     = C.bg,
				BackgroundTransparency = 0.12,
				Font                 = Enum.Font.GothamMedium,
				TextSize             = 11,
				TextColor3           = C.text,
				PlaceholderText      = iCfg.Placeholder or "Type...",
				PlaceholderColor3    = C.dim,
				Text                 = iCfg.Default or "",
				ClearTextOnFocus     = false,
				ClipsDescendants     = true,
				Parent               = row,
			})
			corner(box, 6)
			local boxStroke = stroke(box, C.border, 0.55, 1)
			pad(box, 0, 0, 8, 8)

			box.Focused:Connect(function()
				tween(boxStroke, Ease.quick, { Color = C.accent, Transparency = 0.15 })
			end)

			box.FocusLost:Connect(function(enter)
				tween(boxStroke, Ease.quick, { Color = C.border, Transparency = 0.55 })
				if enter and iCfg.Callback then
					task.spawn(iCfg.Callback, box.Text)
				end
			end)

			local obj = {}
			function obj:Set(v) box.Text = v end
			function obj:Get() return box.Text end
			function obj:Destroy() row:Destroy() end
			return obj
		end

		-- ── Keybind ────────────────────────────────

		function Tab:CreateKeybind(kCfg)
			compIdx += 1
			local row = createRow(scroll, kCfg, compIdx)

			local currentKey = kCfg.Default
			local binding    = false

			local keyBtn = make("TextButton", {
				Size                 = UDim2.fromOffset(82, 24),
				Position             = UDim2.new(1, -14, 0.5, 0),
				AnchorPoint          = Vector2.new(1, 0.5),
				BackgroundColor3     = C.hover,
				BackgroundTransparency = 0.15,
				Font                 = Enum.Font.GothamMedium,
				TextSize             = 11,
				TextColor3           = C.sub,
				Text                 = currentKey and currentKey.Name or "None",
				AutoButtonColor      = false,
				Parent               = row,
			})
			corner(keyBtn, 6)
			stroke(keyBtn, C.border, 0.6, 1)

			keyBtn.MouseButton1Click:Connect(function()
				if binding then return end
				binding = true
				keyBtn.Text = "..."
				tween(keyBtn, Ease.quick, {
					BackgroundColor3     = C.accent,
					BackgroundTransparency = 0.55,
				})

				local c
				c = UserInput.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
					c:Disconnect()
					binding = false

					tween(keyBtn, Ease.quick, {
						BackgroundColor3     = C.hover,
						BackgroundTransparency = 0.15,
					})

					if input.KeyCode == Enum.KeyCode.Escape then
						keyBtn.Text = currentKey and currentKey.Name or "None"
						return
					end

					currentKey  = input.KeyCode
					keyBtn.Text = currentKey.Name

					if kCfg.Callback then task.spawn(kCfg.Callback, currentKey) end
					if kCfg.ChangedCallback then task.spawn(kCfg.ChangedCallback, currentKey) end
				end)
			end)

			-- Passive listener
			table.insert(conns, UserInput.InputBegan:Connect(function(input, gpe)
				if gpe or binding then return end
				if currentKey and input.KeyCode == currentKey then
					if kCfg.Callback then task.spawn(kCfg.Callback, currentKey) end
				end
			end))

			local obj = {}
			function obj:Set(k)
				currentKey  = k
				keyBtn.Text = k and k.Name or "None"
			end
			function obj:Get() return currentKey end
			function obj:Destroy() row:Destroy() end
			return obj
		end

		return Tab
	end

	function Window:SetTitle(t)
		titleLabel.Text = t
	end

	function Window:Toggle()
		visible = not visible
		if visible then
			canvas.Visible = true
			tween(canvas, Ease.spring, {
				Size             = UDim2.fromOffset(winW, winH),
				GroupTransparency = 0,
			})
		else
			local tw = tween(canvas, Ease.smooth, {
				Size             = UDim2.fromOffset(winW * 0.95, winH * 0.95),
				GroupTransparency = 1,
			})
			tw.Completed:Connect(function()
				if not visible then canvas.Visible = false end
			end)
		end
	end

	function Window:Destroy()
		canvas:Destroy()
	end

	return Window
end

-- ═══════════════════════════════════════════════════
-- Notifications
-- ═══════════════════════════════════════════════════

function MadUI:Notify(nCfg)
	initGui()
	nCfg = nCfg or {}

	local typeCol = {
		info    = C.accent,
		success = C.green,
		warning = C.yellow,
		error   = C.red,
	}
	local accentCol = typeCol[nCfg.Type or "info"] or C.accent
	local dur       = nCfg.Duration or 3

	local notif = make("CanvasGroup", {
		Size                 = UDim2.new(1, 0, 0, 0),
		BackgroundColor3     = C.surface,
		GroupTransparency    = 1,
		ClipsDescendants     = true,
		ZIndex               = 100,
		Parent               = notifHolder,
	})
	corner(notif, 10)
	stroke(notif, C.glass, 0.86, 1)

	-- Accent bar
	local bar = make("Frame", {
		Size                 = UDim2.new(0, 3, 1, -18),
		Position             = UDim2.fromOffset(10, 9),
		BackgroundColor3     = accentCol,
		ZIndex               = 101,
		Parent               = notif,
	})
	corner(bar, 2)

	-- Title
	make("TextLabel", {
		Size                 = UDim2.new(1, -40, 0, 15),
		Position             = UDim2.fromOffset(24, 12),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 12,
		TextColor3           = C.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = nCfg.Title or "Notification",
		ZIndex               = 101,
		Parent               = notif,
	})

	-- Content
	make("TextLabel", {
		Size                 = UDim2.new(1, -40, 0, 26),
		Position             = UDim2.fromOffset(24, 30),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.Gotham,
		TextSize             = 10,
		TextColor3           = C.sub,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextYAlignment       = Enum.TextYAlignment.Top,
		TextWrapped          = true,
		Text                 = nCfg.Content or "",
		ZIndex               = 101,
		Parent               = notif,
	})

	-- Progress bar
	local prog = make("Frame", {
		Size                 = UDim2.new(1, -20, 0, 2),
		Position             = UDim2.new(0, 10, 1, -7),
		BackgroundColor3     = accentCol,
		BackgroundTransparency = 0.4,
		ZIndex               = 101,
		Parent               = notif,
	})
	corner(prog, 1)

	-- Animate in
	tween(notif, Ease.spring, {
		Size             = UDim2.new(1, 0, 0, 66),
		GroupTransparency = 0,
	})

	-- Countdown
	tween(prog, Ease.linear(dur), {
		Size = UDim2.new(0, 0, 0, 2),
	})

	-- Dismiss
	task.delay(dur, function()
		tween(notif, Ease.smooth, { GroupTransparency = 1 })
		task.delay(0.28, function()
			tween(notif, Ease.smooth, { Size = UDim2.new(1, 0, 0, 0) })
			task.delay(0.28, function()
				notif:Destroy()
			end)
		end)
	end)
end

-- ═══════════════════════════════════════════════════
-- Cleanup
-- ═══════════════════════════════════════════════════

function MadUI:Destroy()
	for _, c in conns do
		if typeof(c) == "RBXScriptConnection" then
			c:Disconnect()
		end
	end
	table.clear(conns)

	if screenGui then
		screenGui:Destroy()
		screenGui = nil
	end
end

return MadUI
