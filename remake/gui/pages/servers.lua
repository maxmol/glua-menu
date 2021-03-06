
surface.CreateFont("Menu_ServersSubtitle", {
	font = "Arial",
	size = 15,
	weight = 500,
	shadow = true,
	extended = true
})


local PANEL = {}

PANEL.Title = "#server_list"

local query_data

local function refreshDoClick(pnl)
	pnl:ChangeRefresh(pnl.is_off)
end

local function refreshChangeRefresh(pnl, state)
	if state then
		pnl:SetText("#servers_stoprefresh")
		pnl:SizeToContentsX()
		
		RunCommand("servers_refresh")
	else
		pnl:SetText("#servers_refresh")
		pnl:SizeToContentsX()
		
		RunCommand("servers_stoprefresh")
	end
	
	pnl.is_off = not state
end

function PANEL:SetupMenuControls(panel)
	local function queryTypeCallback(pnl, button, id)
		query_data.Type = id
		
		self:ChangeRefresh(true)
	end
	
	local selector = panel:AddSelector(queryTypeCallback)
	
		selector:AddOption("#servers_internet", "internet")
		selector:AddOption("#servers_favorites", "favorite")
		selector:AddOption("#servers_history", "history")
		selector:AddOption("#servers_local", "lan")
	
	panel:InsertSpace()
	
	local but_refresh =
		panel:AddOption("#servers_stoprefresh", refreshDoClick)
	but_refresh.ChangeRefresh = refreshChangeRefresh
	
	self.M_RefreshButton = but_refresh
	
	panel:InsertSpace()
	
	panel:AddOption("#legacy_browser", "legacy_browser")
end

function PANEL:ChangeRefresh(state)
	self.M_RefreshButton:ChangeRefresh(state)
end

function PANEL:InitEx()
	self.ServerGamemodesList = self:Add("ServerGamemodesList")
	
	self.ServerGamemodesList.OnChoose = function(pnl, gm_data)
		self:GoToServerList(gm_data)
	end
	
	self.ServerList = self:Add("ServerList")
	self.ServerList:Hide()
	
	self.ServerGamemodesList:DockMargin(0, 0, 0, 20)--120, 20)
	self.ServerGamemodesList:Dock(FILL)
	
	self.ServerList:DockMargin(0, 0, 0, 20)
	self.ServerList:Dock(FILL)
	
	self:StartRefreshing()
end

function PANEL:Open()
	if not self.loaded then
		self.loaded = true
		
		self:InitEx()
	end
end

function PANEL:Close()
	self:ChangeRefresh(false)
end

function PANEL:GoToServerList(gm_data)
	self.ServerGamemodesList:Hide()
	self.ServerList:Show()
	
	self.ServerList:ClearServers()
	self.ServerList:SetGamemodeData(gm_data)
	
	local servers = gm_data
	
	for i = 1, #servers do
		local server_data = servers[i]
		
		self.ServerList:AddServer(server_data)
	end
end
function PANEL:GoToGamemodeList()
	self.ServerGamemodesList:Show()
	self.ServerList:Hide()
end

function PANEL:StartRefreshing()
	self.ServerList:ClearServers()
	self.ServerGamemodesList:ClearData()
	
	if self.ServersTable then
		self:StopRefreshing()
	end
	
	self.ServersTable = {}
	
	serverlist.StartQuerying(self.ServersTable, self, query_data)
end
function PANEL:StopRefreshing()
	serverlist.StopQuerying(self.ServersTable)
end

function PANEL:OnServerFound(query_id, data)
	--[[
	data:
		ping,
		name,
		desc,
		map,
		players,
		maxplayers,
		botplayers,
		pass,
		lastplayed,
		address,
		gamemode,
		wsid
	]]
	
	data.hasmap = GetMapIndex()[data.map] ~= nil
	
	local gm_data = self.ServersTable[data.gamemode]
	
	if not gm_data then
		gm_data = {
			Name = data.gamemode,
			Title = data.desc,
			TitleVariatons = {},
			WorkshopID = data.wsid,
			WorkshopIDVariatons = {},
			IsSubscribed = true,
		}
		
		self.ServersTable[data.gamemode] = gm_data
		
		self.ServerGamemodesList:AddElement(gm_data)
	else
		-- weird
		
		local vars = gm_data.TitleVariatons
		vars[data.desc] = (vars[data.desc] or 0) + 1
		
		gm_data.Title = table.GetWinningKey(vars)
		
		local vars = gm_data.WorkshopIDVariatons
		vars[data.wsid] = (vars[data.wsid] or 0) + 1
		
		gm_data.WorkshopID = table.GetWinningKey(vars)
	end
	
	local wsid = gm_data.WorkshopID
	
	if wsid and wsid ~= "" then
		local is_subscr = steamworks.IsSubscribed(wsid)
		
		gm_data.IsSubscribed = is_subscr
	else
		gm_data.IsSubscribed = true
	end
	
	self.ServerGamemodesList:UpdateInfo(gm_data, data)
	
	if self.ServerList:IsVisible() then
		local gm_data = self.ServerList:GetGamemodeData()
		
		if gm_data.Name == data.gamemode then
			self.ServerList:AddServer(data)
		end
		
		self.ServerList:UpdateGamemodeData(gm_data)
	end
	
	-- remove useless fields
	data.desc = nil
	data.gamemode = nil
	data.wsid = nil
	
	table.insert(gm_data, data)
end

function PANEL:OnSearchFinished()
	print("Search finished!")
	
	self:ChangeRefresh(false)
end

query_data = {
	Type = "internet",
	GameDir = "garrysmod",
	AppID = 4000,
	
	Callback = PANEL.OnServerFound,
	Finished = PANEL.OnSearchFinished,
}

function PANEL:OnReturnToGamemodesRequested()
	self:GoToGamemodeList()
end

function PANEL:Paint(w, h)
	
end

MainMenuView.Pages.Servers = vgui.RegisterTable(PANEL, "Panel")
