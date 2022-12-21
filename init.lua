minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_hp() > 0 then
			local pos = player:getpos()
			local inv = player:get_inventory()
			
			for _,object in ipairs(minetest.get_objects_inside_radius(pos, 0.75)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
							local itemstring = object:get_luaentity().itemstring
					if inv and inv:room_for_item("main", ItemStack(itemstring)) then
						inv:add_item("main", ItemStack(itemstring))
						if itemstring ~= "" then
							local itemname = ItemStack(itemstring):to_table().name
							if minetest.get_item_group(itemname, "rupee") ~= 0 then
							else
							end
						end
						object:get_luaentity().itemstring = ""
						object:remove()
					end
				end
			end
			
			for _,object in ipairs(minetest.get_objects_inside_radius(pos, 0.75)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					if object:get_luaentity().collect then
						if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
							local pos1 = pos
							pos1.y = pos1.y+0.5
							local pos2 = object:getpos()
							local v = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}
							v.x = v.x*6
							v.y = v.y*6
							v.z = v.z*6
							object:setvelocity(v)
							object:get_luaentity().physical_state = false
							object:get_luaentity().object:set_properties({
								physical = false
							})
							
							minetest.after(1, function(args)
								local lua = object:get_luaentity()
								if object == nil or lua == nil or lua.itemstring == nil then
									return
								end
								if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
									inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
									if object:get_luaentity().itemstring ~= "" then
										if minetest.get_item_group(object:get_luaentity().itemstring, "rupee") ~= 0 then
										minetest.sound_play("rupee", {pos = pos, gain = 0.3, max_hear_distance = 16})
										end
									end
									object:get_luaentity().itemstring = ""
									object:remove()
								else
									object:setvelocity({x = 0,y = 0,z = 0})
									object:get_luaentity().physical_state = true
									object:get_luaentity().object:set_properties({
										physical = true
									})
								end
							end, {player, object})
							
						end
					end
				end
			end
		end
	end
end)