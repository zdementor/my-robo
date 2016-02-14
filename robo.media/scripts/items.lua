
function OnCollectItem(node_ptr, item_ptr)

	local node = tolua.cast(node_ptr, "game::IGameNode") 
	local item = tolua.cast(item_ptr, "game::IGameNodeItem") 
	local item_scene_node  = item:getSceneNode()
	local text_node  = item_scene_node:getCaption()
	local scene_node = tolua.cast(text_node, "scn::ISceneNode")

	if scene_node~=nil then
		local root_node = MyScnMgr:getRootSceneNode()
		scene_node:setParent(root_node)
		item_scene_node:detachCaption()
		scene_node:setVisible(true)
		MyScnMgr:addToDeletionQueue(scene_node, 1000)
		MyScnMgr:addToVisibilityChangeQueue(scene_node, false, 1000)
	end
	MustRefreshGUI=true
end

function OnThrowItem(node_ptr, item_ptr)

	local node = tolua.cast(node_ptr, "game::IGameNode") 
	local item = tolua.cast(item_ptr, "game::IGameNodeItem")
	MustRefreshGUI=true
end

function OnUseItem(node_ptr, item_ptr)

	local node      = tolua.cast(node_ptr, "game::IGameNode")
	local item = tolua.cast(item_ptr, "game::IGameNodeItem") 
	local node_type = node:getGameNodeType()
	local item_key  = item:getItemKeyName()

	if (node_type==game.EGNT_MAIN_PLAYER) then
		local node_ai = tolua.cast(node, "game::IGameNodeAI") 
		if item_key=="Blaster" then
			-- nothing to do
			return
		elseif item_key=="Chainmachine" then
			-- nothing to do
			return
		elseif item_key=="Rocketlauncher" then
			-- nothing to do
			return
		elseif item_key=="SmallMedkit" then
			-- +10% life up
			node_ai:addLife(node_ai:getMaxLife()*0.1)
		elseif item_key=="MediumMedkit" then
			-- +25% life up		
			node_ai:addLife(node_ai:getMaxLife()*0.25)
		elseif item_key=="LargeMedkit" then
			-- +50% life up
			node_ai:addLife(node_ai:getMaxLife()*0.5)
		else
			-- feel ammo here
			local feel_ammo_count=0

			if item_key=="SmallBulletAmmo" then
				-- +50 bullet ammo
				feel_ammo_count=50
			elseif item_key=="MediumBulletAmmo" then
				-- +100 bullet ammo
				feel_ammo_count=100
			elseif item_key=="LargeBulletAmmo" then
				-- +250 bullet ammo
				feel_ammo_count=250
			elseif item_key=="SmallRocketAmmo" then
				-- +3 rocket ammo
				feel_ammo_count=3
			elseif item_key=="MediumRocketAmmo" then
				-- +5 rocket ammo
				feel_ammo_count=5
			elseif item_key=="LargeRocketAmmo" then
				-- +10 rocket ammo
				feel_ammo_count=10
			end
			local inventory=node_ai:getInventory()
			local weapon_count = inventory:getWeaponsCount()
			local weapons_to_feel_ammo = {}
			local weapons_to_feel_ammo_count=0
			for w=0,weapon_count-1 do
				local weapon_sub_count = inventory:getWeaponsSubCount(w)
				for wi=0,weapon_sub_count-1 do
					local weapon = inventory:getWeapon(w,wi)
					local bullet_idx = weapon:getBulletIndexByKeyName(item_key)
					if bullet_idx~=-1 then
						weapons_to_feel_ammo[weapons_to_feel_ammo_count] = {}
						weapons_to_feel_ammo[weapons_to_feel_ammo_count][0]= weapon
						weapons_to_feel_ammo[weapons_to_feel_ammo_count][1]= bullet_idx
						weapons_to_feel_ammo_count=weapons_to_feel_ammo_count+1
					end
				end
			end
			if weapons_to_feel_ammo_count>0 then
				feel_ammo_count = feel_ammo_count/weapons_to_feel_ammo_count
			end
			for w=0,weapons_to_feel_ammo_count-1 do
				local weapon    = weapons_to_feel_ammo[w][0]
				local bullet_idx= weapons_to_feel_ammo[w][1]
				weapon:feelBulletAmmo(bullet_idx,feel_ammo_count)
			end
		end
	end
	local item_scene_node = item:getSceneNode()
	MyScnMgr:addToDeletionQueue(item_scene_node, 0)
end
