
local PANEL = {}

function PANEL:Init()
	self:MakePopup()
	self:SetPopupStayAtBack(true)
	--self:MoveToBack()
	
	if gui.IsConsoleVisible() then -- костыль
		RunConsoleCommand("showconsole")
	end

	self.HTML = vgui.Create("DHTML", self)
	self.HTML:SetSize(ScrW(), ScrH())
	self.HTML:SetHTML(MenuBackgroundHTML)
	self.HTML:SetVisible(not IsInGame())

	hook.Add("InGameStateChanged", 'BackgroundHTML', function(state)
		self.HTML:SetVisible(not state)
	end)
	
	self.UpperBar = self:Add("UpperBar")
	self.UpperBar:SetHeight(30)
	
	self.GMLogo = self:Add("GMLogo")
	
	self.NavBar = self:Add("NavigationBar")
	self.NavBar:SetHeight(50)
	
	self.Menu = self:Add("MenuContainer")
	--self.Menu:SetWidth(300)
	
	self:Dock(FILL)
	
	self.UpperBar:Dock(TOP)
	self.GMLogo:Dock(TOP)
	self.NavBar:Dock(BOTTOM)
	self.Menu:Dock(LEFT)
	
	--hook.Add("CurrentGamemodeChanged", self, self.OnGamemodeChanged)
	
	--self:OnGamemodeChanged(engine.ActiveGamemode())

	self.GMLogo:SetVisible(false)
end

function PANEL:PerformLayout(w, h)
	do -- keeping similar behaviour
		local left = w > 1280 and 85 or 70
		local top = h > 480 and 45 or -10
		
		if self.GMLogo:IsVisible() then
			self.GMLogo:DockMargin(left, top, 0, 0)
			self.Menu:DockMargin(left, 0, 0, 0)
		else
			self.Menu:DockMargin(left, top, 0, 0)
		end
		
		self.Menu:SetWidth(w > 1280 and 300 or 200) -- differs here
		
		self.Menu:SetEnlarged(w > 1280)
	end
end

local gradient = Material('vgui/gradient-l')
function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0)
	surface.SetMaterial(gradient)
	surface.DrawTexturedRect(0, 0, w, h)
end

function PANEL:PlacePage(page)
	page:SetParent(self)
	page:Dock(FILL)
	
	local title, menu_panel = page.Title, page.MenuOptionsPanel
	
	self.GMLogo:SetVisible(title == nil and menu_panel ~= nil)
	
	self.Menu:SetTitle(title)
	self.Menu:PlaceMenuOptions(menu_panel)
	
	self.Menu:SetVisible(menu_panel ~= nil)
	
	self:InvalidateLayout(true)
end

--[[function PANEL:SetOptions(options_table)
	if options_table then
		self.Menu:ReflectData(options_table)
	end
	
	self.Menu:SetVisible(options_table ~= nil)
end]]

function PANEL:OnGamemodeChanged(gamemode_name)
	local path = "gamemodes/" .. gamemode_name .. "/logo.png"
	local mat = Material(path, "smooth")
	
	self.GMLogo:SetMaterial(mat)
	
	if options.Get("menu_r_hidebg") ~= "1" then
		UpdateBackgroundImages(gamemode_name)
	end
end

--PANEL.Paint = DrawBackground

MainMenuView.MainPanelTable = vgui.RegisterTable(PANEL, "EditablePanel")

function MainMenuView.CreateMainPanel()
	return vgui.CreateFromTable(MainMenuView.MainPanelTable)
end
