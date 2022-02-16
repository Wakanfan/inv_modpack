local S = minetest.get_translator("sfinv_home")

-- static spawn position
local statspawn = minetest.string_to_pos(
		minetest.settings:get("static_spawnpoint")) or {x = 0, y = 12, z = 0}

local get_formspec = function(name)

	local formspec = "size[6,2]"
		.. "button_exit[2,2.5;4,1;home_gui_go;" .. S("Go Home") .. "]"
		.. "button_exit[2,4.5;4,1;home_gui_set;" .. S("Set Home") .. "]"
		.. "button_exit[2,6.5;4,1;home_gui_spawn;" .. S("Spawn") .. "]"

	local home = sethome.get(name)

	if home then
		formspec = formspec
			.. "label[2,1.5;" .. S("Home set to:") .. "  "
			.. minetest.pos_to_string(vector.round(home)) .. "]"
	else
		formspec = formspec
			.. "label[2,1.5;" .. S("Home point has not been set!") .. "]"
	end

	return formspec
end


-- register homegui page
sfinv.register_page("sfinv_home:homegui", {

	title = S("Home"),

	get = function(self, player, context)

		local name = player:get_player_name()

		return sfinv.make_formspec(player, context, get_formspec(name))
	end,

	is_in_nav = function(self, player, context)

		local name = player:get_player_name()

		return minetest.get_player_privs(name).home
	end,

	on_enter = function(self, player, context) end,

	on_leave = function(self, player, context) end,

	on_player_receive_fields = function(self, player, context, fields)

		local name = player:get_player_name()

		if not minetest.get_player_privs(name).home then
			return
		end

		if fields.home_gui_set then

			sethome.set(name, player:get_pos())

			sfinv.set_player_inventory_formspec(player)

		elseif fields.home_gui_go then

			sethome.go(name)

		elseif fields.home_gui_spawn then

			player:set_pos(statspawn)
		end
	end
})


-- spawn command
minetest.register_chatcommand("spawn", {
	description = S("Go to Spawn"),
	privs = {home = true},
	func = function(name)

		local player = minetest.get_player_by_name(name)

		player:set_pos(statspawn)
	end
})
