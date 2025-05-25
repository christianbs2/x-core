Main.UI                        = {}
Main.UI.Menu                   = {}
Main.UI.Menu.RegisteredTypes   = {}
Main.UI.Menu.Opened            = {}

Main.UI.Menu.RegisterType = function(type, open, close)
	Main.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

Main.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		Main.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #Main.UI.Menu.Opened, 1 do
			if Main.UI.Menu.Opened[i] then
				if Main.UI.Menu.Opened[i].type == type and Main.UI.Menu.Opened[i].namespace == namespace and Main.UI.Menu.Opened[i].name == name then
					Main.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		Main.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	table.insert(Main.UI.Menu.Opened, menu)
	Main.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

Main.UI.Menu.Close = function(type, namespace, name)
	for i=1, #Main.UI.Menu.Opened, 1 do
		if Main.UI.Menu.Opened[i] then
			if Main.UI.Menu.Opened[i].type == type and Main.UI.Menu.Opened[i].namespace == namespace and Main.UI.Menu.Opened[i].name == name then
				Main.UI.Menu.Opened[i].close()
				Main.UI.Menu.Opened[i] = nil
			end
		end
	end
end

Main.UI.Menu.CloseAll = function()
	for i=1, #Main.UI.Menu.Opened, 1 do
		if Main.UI.Menu.Opened[i] then
			Main.UI.Menu.Opened[i].close()
			Main.UI.Menu.Opened[i] = nil
		end
	end
end

Main.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #Main.UI.Menu.Opened, 1 do
		if Main.UI.Menu.Opened[i] then
			if Main.UI.Menu.Opened[i].type == type and Main.UI.Menu.Opened[i].namespace == namespace and Main.UI.Menu.Opened[i].name == name then
				return Main.UI.Menu.Opened[i]
			end
		end
	end
end

Main.UI.Menu.GetOpenedMenus = function()
	return Main.UI.Menu.Opened
end

Main.UI.Menu.IsOpen = function(type, namespace, name)
	return Main.UI.Menu.GetOpened(type, namespace, name) ~= nil
end
