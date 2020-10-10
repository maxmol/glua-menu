
local PANEL = {}

function PANEL:SetupMenuControls(panel)
	local in_game = IsInGame()
	
	if in_game then
		panel:AddOption("close", "resume_game")
		
		panel:InsertSpace()
	end
	
	panel:AddOption("lampserv.net", "lampserv")
	panel:AddOption("singleplayer", "new_game")
	panel:AddOption("multiplayer", "find_mp_game")
	
	panel:InsertSpace()
	
	panel:AddOption("addons", "addons")
	--panel:AddOption("#demos", "demos")
	--panel:AddOption("#saves", "saves")
	
	--panel:InsertSpace()
	
	panel:AddOption("options", "options")
	
	panel:InsertSpace()
	
	if in_game then
		panel:AddOption("disconnect", "disconnect")
	end
	
	panel:AddOption("quit", "quit")
end

function PANEL:Init()
	hook.Add("InGameStateChanged", self, self.InGameChanged)
end

function PANEL:Open()
	
end

function PANEL:Close()
	
end

function PANEL:InGameChanged(state)
	local menu_panel = self.MenuOptionsPanel
	
	if not menu_panel then return end
	
	menu_panel:Clear()
	
	-- I understand nothing
	-- FIXME
	
	timer.Simple(0, function()
		if self:IsValid() then
			menu_panel:InvalidateLayout(true)
			self:SetupMenuControls(menu_panel)
			
			menu_panel:InvalidateLayout(true)
			menu_panel:InvalidateLayout()
		end
	end)
end

--[[function PANEL:Paint(w, h)
	surface.SetDrawColor(color_white)
	surface.DrawRect(0, 0, w, h)
end]]

MainMenuView.Pages.Default = vgui.RegisterTable(PANEL, "Panel")
