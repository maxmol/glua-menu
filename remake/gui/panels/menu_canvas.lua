
local PANEL = {}

function PANEL:Init()
	--self.spaces = 0
	self.hovered_btn_width = 0
	self.hovered_btn_alpha = 0
end

function PANEL:CreateButton(name, command, parent) -- internal
	local button = vgui.Create("MenuButton", parent)
	button:SetText(name)
	button:SetCommand(command)
	--button:SizeToContentsX(2)
	button:SizeToContentsY(24)
	
	button:SetEnlarged(self.enlarged) -- this affects size!
	
	return button
end

function PANEL:AddOption(name, command)
	local button = self:CreateButton(name, command, self)
	
	--button:DockMargin(0, 0, 0, 0)
	button:Dock(TOP)
	
	return button
end

function PANEL:AddSelector(callback)
	local selector = self:Add("MenuSelector")
	
	if callback then
		selector.OnSelect = callback
	end
	
	selector:Dock(TOP)
	
	return selector
end

function PANEL:PlaceSubPanel(panel, parent) -- internal
	if parent:IsSelectable() then
		local dep = parent:GetDependant()
		
		if not dep then
			dep = self:Add("Panel")
			dep:Dock(TOP)
			
			parent:SetDependant(dep)
		end
		
		panel:SetParent(dep)
	else
		panel:SetParent(self)
	end
end

function PANEL:AddSubOption(parent, name, command)
	local button = self:CreateButton(name, command)
	button:SetSubsidary(true)
	
	self:PlaceSubPanel(button, parent)
	
	button:DockMargin(4, 0, 0, 0)
	button:Dock(TOP)
	
	return button
end

function PANEL:AddSubSelector(parent, callback)
	local selector = self:Add("MenuSelector")
	
	if callback then
		selector.OnSelect = callback
	end
	
	self:PlaceSubPanel(selector, parent)
	
	selector:DockMargin(4, 0, 0, 0)
	selector:Dock(TOP)
	
	return selector
end

function PANEL:AddSelectableOption(selector, name, command)
	local button = self:CreateButton(name, command, selector)
	
	if not selector:HasParent(self) then
		button:SetSubsidary(true)
	end
	
	button:SetSelectable(true)
	
	--button:DockMargin(0, 0, 0, 0)
	button:Dock(TOP)
	
	return button
end

local function spaceSetEnlarged(pnl, state)
	pnl:SetTall(state and 24 or 24)
end

function PANEL:InsertSpace()
	--self.spaces = self.spaces + 1
	
	local space = self:Add("Panel")
	space.SetEnlarged = spaceSetEnlarged
	space:SetEnlarged(self.enlarged)
	
	space:Dock(TOP)
end

function PANEL:SetEnlarged(state)
	self.enlarged = state
	
	self:DockPadding(0, state and 41 or 30, 0, 0)
	
	for k, v in pairs(self:GetChildren()) do
		if v.SetEnlarged then
			v:SetEnlarged(state)
			
			--if v.SetText then -- FIXME
				--v:DockMargin(0, 0, 0, 0)
			--end
		end
	end
	
	self:InvalidateLayout(true)
end

function PANEL:Paint()
	local btn = self.hovered_button
	local alpha = self.hovered_btn_alpha

	if IsValid(btn) and alpha > 0 then
		local hovered = vgui.GetHoveredPanel() 
		if IsValid(hovered) and not hovered.MenuButton then
			self.hovered_btn_alpha = alpha - FrameTime() * 600
		end

		surface.SetDrawColor(197, 71, 133, alpha)
		surface.SetFont(btn:GetFont())
		local x, y = btn:GetPos()
		local w, h = surface.GetTextSize(btn:GetText())

		if not self.hovered_btn_y then
			self.hovered_btn_y = y
		end

		self.hovered_btn_width = Lerp(FrameTime() * 10, self.hovered_btn_width, w)
		self.hovered_btn_y = Lerp(FrameTime() * 16, self.hovered_btn_y, y)
		surface.DrawRect(x, self.hovered_btn_y + 6, self.hovered_btn_width + 8, h)
	end
end

vgui.Register("MenuOptions", PANEL, "Panel")
