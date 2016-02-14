
function LoadGameOptions()
	local file = io.open (OPTIONS.GameOptionsFileName, "r")
	if file==nil then
	-- use default options
		-- setting monitor brightness ( 0.5 - 3.0 )
		MyDevice:setMonitorBrightness(1.0)
		-- setting sound tracks volume (0.0 - 1.0) 
		MyGameMgr:setSoundTracksVolume(0.45)
		-- setting sound effects volume (0.0 - 1.0)
		MyGameMgr:setSoundEffectsVolume(0.45)
		-- setting mouse cursor default sensitivity
		MyCursor:setSensitivity(0.5)
		-- setting up game controls (keyboard and mouse)
		MyInpDisp:mapKey(io.EKC_D,             game.EGA_MOVE_RIGHT_STRAFE )
		MyInpDisp:mapKey(io.EKC_S,             game.EGA_MOVE_BACKWARD     ) 
		MyInpDisp:mapKey(io.EKC_W,             game.EGA_MOVE_FORWARD      ) 
		MyInpDisp:mapKey(io.EKC_A,             game.EGA_MOVE_LEFT_STRAFE  ) 
		MyInpDisp:mapKey(io.EKC_ADD,           game.EGA_VIEW_ZOOM_IN      ) 
		MyInpDisp:mapKey(io.EKC_MINUS,         game.EGA_VIEW_ZOOM_OUT     ) 
		MyInpDisp:mapKey(io.EKC_LBRACKET,      game.EGA_SELECT_PREV_WEAPON)
		MyInpDisp:mapKey(io.EKC_RBRACKET,      game.EGA_SELECT_NEXT_WEAPON)
		MyInpDisp:mapKey(io.EKC_1,             game.EGA_SELECT_WEAPON_0   )
		MyInpDisp:mapKey(io.EKC_2,             game.EGA_SELECT_WEAPON_1   ) 
		MyInpDisp:mapKey(io.EKC_3,             game.EGA_SELECT_WEAPON_2   )
		MyInpDisp:mapMouse(io.EMC_LMOUSE,      game.EGA_ATTACK_PRIMARY    )   
		MyInpDisp:mapMouse(io.EMC_MWHEEL_UP,   game.EGA_SELECT_PREV_WEAPON)
		MyInpDisp:mapMouse(io.EMC_MWHEEL_DOWN, game.EGA_SELECT_NEXT_WEAPON)
	else
    -- load options from file
		local i = 0
		local g = 0
		for line in file:lines() do 
			if i==0 then    
				local bright_val = tonumber(line)   
				-- setting monitor brightness ( 0.5 - 3.0 )
				MyDevice:setMonitorBrightness(bright_val)
			elseif i==1 then    
				local mus_vol = tonumber(line)
				-- setting music volume (0.0 - 1.0)
				MyGameMgr:setSoundTracksVolume(mus_vol)
			elseif i==2 then
				local snd_vol = tonumber(line)
				-- setting effects volume (0.0 - 1.0)
				MyGameMgr:setSoundEffectsVolume(snd_vol)
			elseif i==3 then
				local sens_val = tonumber(line)
				-- setting sensitivity value (0.0 - 1.0)
				MyCursor:setSensitivity(sens_val)
			elseif g<game.E_GAME_ACTION_COUNT then
				-- setting game controls
				local token = {}
				local to = 0        
				local t = 0
				while (t<3) do          
					from = to+1
					to = string.find(line, ";", to+1);
					if to==nil then
						break
					end
					token[t] = string.sub(line, from, to-1)         
					t = t + 1                       
				end     
				if t==3  then
					local kcode = tonumber(token[1])
					local mcode = tonumber(token[2])            
					if kcode>=0 and kcode<io.E_KEY_CODE_COUNT then
						MyInpDisp:mapKey(kcode, g)
					end
					if mcode>=0 and mcode<io.E_MOUSE_CODE_COUNT then
						MyInpDisp:mapMouse(mcode, g)
					end                     
				end 
				g = g + 1
			elseif i==(4+game.E_GAME_ACTION_COUNT) then
				CameraStyle = tonumber(line)
			elseif i==(5+game.E_GAME_ACTION_COUNT) then
				if tonumber(line)==1 then
					CameraAutoZoom = true
				else
					CameraAutoZoom = false
				end
	        end
	        i = i + 1   
	    end
	    file:close()
	end
end

function SaveGameOptions()
	local file = io.open (OPTIONS.GameOptionsFileName, "w")
	if file~=nil then    
		local bright_val = MyDevice:getMonitorBrightness()
		local mus_vol    = MyGameMgr:getSoundTracksVolume()
		local eff_vol    = MyGameMgr:getSoundEffectsVolume()
		local sens_val   = MyCursor:getSensitivity()
		file:write(string.format("%.2f\n",bright_val))
		file:write(string.format("%.2f\n",mus_vol))
		file:write(string.format("%.2f\n",eff_vol))
		file:write(string.format("%.2f\n",sens_val))
		for i=0, game.E_GAME_ACTION_COUNT-1 do              
			local kcode = MyInpDisp:getActionKey(i)
			local mcode = MyInpDisp:getActionMouse(i)
			file:write(string.format("%d;%d;%d;\n",i,kcode,mcode))
		end   
		file:write(string.format("%d\n",CameraStyle))
		if CameraAutoZoom then
			file:write(string.format("%d\n",1))
		else
			file:write(string.format("%d\n",0))
		end
		file:close()
	end
end

LoadGameOptions()

-- loading plugings
if dev.IDevice:isDebug() then
	MyPluginMgr:registerPlugin("robotroopers",	"RoboGame_d.dll"     )
else
	MyPluginMgr:registerPlugin("robotroopers",	"RoboGame.dll"     )
end

-- start main game plugin
MyPluginMgr:startPlugin("robotroopers")
