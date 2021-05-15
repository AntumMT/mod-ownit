
core.register_craftitem(ownit.modname .. ":wand", {
	description = "Tool for setting node owner",
	short_description = "Ownit Wand",
	inventory_image = "ownit_wand.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if not user:is_player() then return end
		if pointed_thing.type ~= "node" then return end
		local pos = core.get_pointed_thing_position(pointed_thing, false)
		local node = core.get_node_or_nil(pos)
		if not node then return end

		local pname = user:get_player_name()
		local nmeta = core.get_meta(pos)
		local current_owner = nmeta:get_string("owner")

		if current_owner ~= "" and pname ~= current_owner then
			core.chat_send_player("You cannot take ownership of a node owned by another player")
			return
		end

		local unown = false
		if pname == current_owner then unown = true end

		if unown then
			nmeta:set_string("owner", nil)
			core.chat_send_player(pname, "You no longer own this node")
		else
			-- FIXME: should only be able to set ownership of nodes in protected areas owned by same player
			nmeta:set_string("owner", pname)
			core.chat_send_player(pname, "You now own this node")
		end
	end,
})
