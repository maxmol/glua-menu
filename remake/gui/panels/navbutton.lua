
surface.CreateFont("Menu_ControlButton", {
	font	= "Helvetica Neue",
	size	= 13,
	weight	= 650
})


local col_hovered_outline = Color(100, 176, 222)
local col_pressed = Color(135, 192, 228)
local col_label_default = Color(51, 51, 51)

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetDrawBorder(false)
	self:SetDrawBackground(false)
	
	self:SetTall(40)
	
	self:SetCursor("hand")
	
	self:SetContentAlignment(6)
	self:SetFont("Menu_ControlButton")
	
	self:SetText("")
	self.sat = 230
end

function PANEL:PerformLayout()
	if self.m_Image then
		if self:GetText() == "" then
			self.m_Image:SetPos(
				(self:GetWide() - self.m_Image:GetWide()) * 0.5,
				(self:GetTall() - self.m_Image:GetTall()) * 0.5
			)
			
			return
		end
		
		self.m_Image:SetPos(5, (self:GetTall() - self.m_Image:GetTall()) * 0.5)
		
		self:SetTextInset(self.m_Image:GetWide() - 16, 0)
	end
	
	return DLabel.PerformLayout(self)
end

function PANEL:IsDown()
	return self.Depressed
end

function PANEL:UpdateColours(skin)
	local col
	
	--if self:GetDisabled() then
	if self.Depressed or self.m_bSelected then
		col = skin.Colours.Button.Down
	elseif self.Hovered then
		col = skin.Colours.Button.Hover
	else
		col = col_label_default
	end
	
	self:SetTextStyleColor(col)
end

function PANEL:SizeToContentsX(addval)
	self:InvalidateLayout(true)
	
	local w, h = self:GetContentSize()
	
	if self.m_Image then
		w = w + 5 + self.m_Image:GetWide() + 8
	else
		w = w + 16
	end
	
	--w = w + 16
	
	self:SetWide(w)
end

function PANEL:SetImage(img)
	if img == nil then
		if self.m_Image then
			self.m_Image:Remove()
		end
	
		return
	end
	
	if not self.m_Image then
		self.m_Image = self:Add("GMLogo") -- костыль
	end
	
	local mat = Material(img)
	
	self.m_Image:SetMaterial(mat)
	self.m_Image:SetWide(self.m_Image.w)
end

PANEL.SetIcon = PANEL.SetImage

function PANEL:Paint(w, h)
	local sat
	if self:IsDown() then
		sat = 40
	elseif self:IsHovered() then
		sat = 64
	else
		sat = 240
	end

	sat = Lerp(FrameTime()*20, self.sat, sat)
	self.sat = sat

	local clr = Color(sat, sat, sat)
	draw.RoundedBox(32, 0, 0, w, h, clr)
end

vgui.Register("ControlButton", PANEL, "DButton")
