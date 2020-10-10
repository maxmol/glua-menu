
include( "mount/mount.lua" )
include( "getmaps.lua" )
include( "loading.lua" )
--include( "mainmenu.lua" )
include( "video.lua" )
include( "demo_to_video.lua" )

include( "menu_save.lua" )
include( "menu_demo.lua" )
include( "menu_addon.lua" )
include( "menu_dupe.lua" )
include( "errors.lua" )

include( "motionsensor.lua" )
include( "util.lua" )

-- i guess i'll just leave that here :/
MenuBackgroundHTML = [[
<html><head>
<style>
body {
	background-image: url('asset://garrysmod/lua/menu/remake/bg.gif');
	background-size: cover;
	
	height: 100vh;
	padding:0;
	margin:0;
}
#bg {
	width:100%;
	height:100%;
	opacity: 0.8;
	background-color: #000;
}
</style>
</head><body>
<div id="bg"></div>
</body></html>]]

include("remake/init.lua")