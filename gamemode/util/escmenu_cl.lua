local ESC = {}

local MenuParent
local CallFromMenu = false
local HasOpened = false
local ShouldUseMenu = true
local MenuOpen = false
local LMenuOpen = false
local Dialogs = {
	disconnect = "disconnect",
	benchmark = "openbenchmarkdialog",
	changegame = "openchangegamedialog",
	createmultiplayergame = "opencreatemultiplayergamedialog",
	custommaps = "opencustommapsdialog",
	friends = "openfriendsdialog",
	gamemenu = "opengamemenu",
	loadcommentary = "openloadcommentarydialog",
	loaddemo = "openloaddemodialog",
	loadgame = "openloadgamedialog",
	newgame = "opennewgamedialog",
	options = "openoptionsdialog",
	playerlist = "openplayerlistdialog",
	savegame = "opensavegamedialog",
	serverbrowser = "openserverbrowser",
	quit = "quit",
	quitnoconfirm = "quitnoconfirm",
	resumegame = "resumegame"
}

function ESC.Register(menu)
	if(type(menu) == "Panel") then
		MenuParent = menu
	else
		error("that's not a panel you cockass")
	end
	if(MenuParent:IsVisible()) then MenuParent:SetVisible(false) end
end

function ESC.Unregister(b)
	if LMenuOpen then
		LMenuOpen = false
		MenuParent:SetVisible(false)
		gui.EnableScreenClicker(false)
	end
	if b then
		MenuParent:Close()
	end
	MenuParent = nil
end

function ESC.GetMenu()
	return MenuParent
end

function ESC.MenuExists()
	return not MenuParent == nil
end

function ESC.DisableMenu()
	ShouldUseMenu = false
end

function ESC.EnableMenu()
	ShouldUseMenu = true
end

function ESC.MenuEnabled()
	return ShouldUseMenu and not MenuParent == nil
end

function ESC.IsMenuOpen()
	return LMenuOpen
end

function ESC.IsDefaultMenuOpen()
	return MenuOpen
end

function ESC.OpenDefaultMenu()
	CallFromMenu = true
	HasOpened = false
	timer.Simple(0, RunConsoleCommand, "gameui_activate")
end

function ESC.OpenConsole()
	if not MenuOpen then
		ESC.OpenDefaultMenu()
	end
	RunConsoleCommand("showconsole")
end

function ESC.RunCommand(dlg)
	dlg = dlg:lower()
	if not(Dialogs[dlg] or table.KeyFromValue(Dialogs, dlg)) then
		Error("pick a real command you blueberry")
	else
		if(Dialogs[dlg]) then
			RunConsoleCommand("gamemenucommand", Dialogs[dlg])
		else
			RunConsoleCommand("gamemnuecommand", dlg)
		end
		ESC.OpenDefaultMenu() //:(
	end
end

local function HUDPaint()
	if(MenuParent and ShouldUseMenu) then
		if(HasOpened and CallFromMenu) then
			CallFromMenu = false
			HasOpened = false
		end
	end
	MenuOpen = false
	if(LMenuOpen) then
		return
	end
end
gmodz.hook.Add("HUDPaint", "_HP_lcem", HUDPaint)

local Elements = {}
for k,v in pairs( {"CHudCrosshair", "CHudBattery", "CHudSuitPower", "CHudAmmo", "CHudSecondaryAmmo", "CHudChat", "CHudCloseCaption", "CHudMessage", "CHudWeaponSelection", "CHudDamageIndicator", "CHudZoom" } )do
	Elements[ v ] = true ;	
end
gmodz.hook.Add( 'HUDShouldDraw', function( thing )
	if Elements[ thing ] then return not LMenuOpen  end
end);

gmodz.hook.Add("PostRenderVGUI", function()
	if(MenuParent and ShouldUseMenu) then
		if(MenuOpen) then
			if(CallFromMenu) then
				if not(HasOpened) then
					HasOpened = true
				end
			else
				RunConsoleCommand("cancelselect")
				LMenuOpen = not LMenuOpen
				MenuParent:SetVisible(LMenuOpen)
				gui.EnableScreenClicker(LMenuOpen)
			end
		end
	end
	MenuOpen = true
end);

gmodz.hook.Add("PlayerBindPress",function( Player, Bind, Pressed )
	if(LMenuOpen) then
		print("TEST!");
		if(string.find(Bind, "toggleconsole")) then
			ESC.OpenConsole()
		end
		if not(string.find(Bind, "cancelselect")) then
			return true
		end
	end
end);