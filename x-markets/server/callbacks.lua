MySQL.ready(function()
	local fetchSqlQuery = [[
		SELECT
			*
		FROM
			x_markets
	]]

	MySQL.Async.fetchAll(fetchSqlQuery, {}, function(response)
		if not response[1] then Heap["fetching"] = false return end

		for index, data in ipairs(response) do
			local cacheId = data["marketName"]
            local decodedData = json.decode(data["marketData"])
            local account = exports["x-jobpanel"]:GetAccount(cacheId)
			
			Heap["markets"][cacheId] = {}
			Heap["markets"][cacheId]["marketOwner"] = data["marketOwner"]
			Heap["markets"][cacheId]["marketName"] = data["marketName"]
			Heap["markets"][cacheId]["marketUUID"] = data["uuid"]
			Heap["markets"][cacheId]["marketState"] = data["marketState"]
            Heap["markets"][cacheId]["marketAccount"] = account
            
			if decodedData then
				Heap["markets"][cacheId]["marketData"] = decodedData
			end
		end

		Heap["fetching"] = false
	end)
end)

Citizen.CreateThread(function()
    X.CreateCallback("x-markets:completePurchase", function(source, callback, shoppingList, marketName)
        local character = exports["x-character"]:FetchCharacter(source)

        if not character then return callback(false) end
        if not marketName then return callback(false) end

        local totalPrice = 0

        for _, shoppingItem in ipairs(shoppingList) do
            totalPrice = totalPrice + (shoppingItem["price"] * shoppingItem["amount"])
        end

        local canAfford = false

        if character["cash"]["balance"] >= totalPrice then
            character["cash"]["remove"](totalPrice)

            -- exports["x-logs"]:Log("MARKET RECEIPT | CASH | MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. totalPrice .. " kr", "Handlade på affär " .. marketName .. " för " .. totalPrice .. " kr.", "MARKETS_RECEIPT")
            exports.JD_logs:createLog({
                EmbedMessage = "MARKET RECEIPT | CASH | MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. totalPrice .. " kr", "Handlade på affär " .. marketName .. " för " .. totalPrice .. " kr.",
                channel = "market",
            })

            canAfford = true
        elseif character["bank"]["balance"] >= totalPrice then
            character["bank"]["remove"](totalPrice, {
                ["type"] = "removed",
                ["description"] = "Köpt " .. #shoppingList .. " föremål på en affär.",
                ["amount"] = totalPrice
            })

            -- exports["x-logs"]:Log("MARKET RECEIPT | BANK | MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. totalPrice .. " kr", "Handlade på affär " .. marketName .. " för " .. totalPrice .. " kr.", "MARKETS_RECEIPT")
            exports.JD_logs:createLog({
                EmbedMessage = "MARKET RECEIPT | BANK | MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. totalPrice .. " kr", "Handlade på affär " .. marketName .. " för " .. totalPrice .. " kr.",
                channel = "market",
            })
            
            canAfford = true
        end

        if canAfford then
            for _, shoppingItem in ipairs(shoppingList) do
                local added = exports["x-inventory"]:AddInventoryItem(character, {
                    Item = {
                        Name = shoppingItem["item"],
                        Count = shoppingItem["amount"]
                    },
                })
            end

            if Heap["markets"][marketName] then
                local marketAccount = exports["x-jobpanel"]:GetAccount(marketName)

                marketAccount["Deposit"](totalPrice * Config.PurchasePercentage, function(deposited)
                    if deposited then
                        Heap["markets"][marketName]["marketAccount"] = marketAccount

                        -- exports["x-logs"]:Log("OWNED MARKET REVENUE | MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. totalPrice * Config.PurchasePercentage .. " kr", marketName .. " tjänade " .. totalPrice * Config.PurchasePercentage .. " kr på senaste köpet.", "MARKETS_OWNED_MARKET_REVENUE")
                        exports.JD_logs:createLog({
                            EmbedMessage = "OWNED MARKET REVENUE | MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. totalPrice * Config.PurchasePercentage .. " kr", marketName .. " tjänade " .. totalPrice * Config.PurchasePercentage .. " kr på senaste köpet.",
                            channel = "market",
                        })
                    end
                end)
            end

            TriggerClientEvent("x-markets:updateMarkets", -1, Heap["markets"])
        end

        callback(canAfford)
    end)

    X.CreateCallback("x-markets:safeHandler", function(source, callback, amount, type, marketName)
        local character = exports["x-character"]:FetchCharacter(source)
        local marketAccount = exports["x-jobpanel"]:GetAccount(marketName)

        if type == "deposit" then
            marketAccount["Deposit"](amount, function(deposited)
                if deposited then
                    Heap["markets"][marketName]["marketAccount"] = marketAccount

                    callback(true)
                else
                    callback(false)

                    return
                end
            end)
        elseif type == "withdraw" then
            if marketAccount and marketAccount["Balance"] >= amount then
                marketAccount["Withdraw"](amount, function(withdrawn)
                    if withdrawn then
                        Heap["markets"][marketName]["marketAccount"] = marketAccount
    
                        callback(true)
                    else
                        callback(false)
    
                        return
                    end
                end)
            else
                callback(false)

                return
            end
        end

        TriggerClientEvent("x-markets:updateMarkets", -1)
    end)

    X.CreateCallback("x-markets:buyItem", function(source, callback, itemData)
        local character = exports["x-character"]:FetchCharacter(source)

        if not character then return callback(false) end
        
        if character["cash"]["balance"] >= itemData["price"] then
            character["cash"]["remove"](itemData["price"])
            
            callback(true)
        elseif character["bank"]["balance"] >= itemData["price"] then
            character["bank"]["remove"](itemData["price"], {
                ["type"] = "removed",
                ["description"] = itemData["marketName"] or "Affär.",
                ["amount"] = itemData["price"]
            })

            -- exports["x-logs"]:Log("MARKET RECEIPT | BANK | MARKET: " .. itemData["marketName"] .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. itemData["price"] .. " kr", "Hanlade på affär " .. itemData["marketName"] .. " för " .. itemData["price"] .. " kr.", "MARKETS_RECEIPT")
            exports.JD_logs:createLog({
                EmbedMessage = "MARKET RECEIPT | BANK | MARKET: " .. itemData["marketName"] .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. itemData["price"] .. " kr", "Hanlade på affär " .. itemData["marketName"] .. " för " .. itemData["price"] .. " kr.",
                channel = "market",
            })

            callback(true)
        else
            callback(false)
        end
    end)

    X.CreateCallback("x-markets:fetchMarkets", function(source, callback)
        local character = exports["x-character"]:FetchCharacter(source)
        
        if not character then return callback(false) end

        Citizen.CreateThread(function()
            while Heap["fetching"] do
                Citizen.Wait(0)
            end

            callback(Heap)
        end)
    end)

    X.CreateCallback("x-markets:robMarket", function(source, callback, marketName)
        local character = exports["x-character"]:FetchCharacter(source)
        local moneyStolen = math.random(Config.MarketRobReward[1], Config.MarketRobReward[2])
        
        if not character then return callback(false) end

        if Heap["markets"][marketName] then
            local marketAccount = exports["x-jobpanel"]:GetAccount(marketName)
            
            moneyStolen = marketAccount["Balance"] * Config.RobPercentage

            marketAccount["Withdraw"](moneyStolen, function(stolen)
                if stolen then
                    Heap["markets"][marketName]["marketAccount"] = marketAccount
                end
            end)
        end

        if moneyStolen then
            character["cash"]["add"](moneyStolen)

            -- exports["x-logs"]:Log("ROBBERY BAG PICKUP | MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. moneyStolen .. " kr", "Tog upp påse med " .. moneyStolen .. " kr i.", "MARKETS_PICKUP_BAG")
            exports.JD_logs:createLog({
                EmbedMessage = "ROBBERY BAG PICKUP | MARKET: " .. marketName .. " | " .. character["identification"]["firstname"] .. " " .. character["identification"]["lastname"] .. " | " .. moneyStolen .. " kr", "Tog upp påse med " .. moneyStolen .. " kr i.",
                channel = "market",
            })

            callback(moneyStolen)
        end
    end)

    X.CreateCallback("x-markets:purchaseMarket", function(source, callback, data)
        local character = exports["x-character"]:FetchCharacter(source)

        if not character then return callback(false) end

        HasMoney(character, data["price"], "Köpte affär-" .. data["marketName"], data["marketName"], function(enough)
            if enough then
                local characterId = character["characterId"]
                local generatedUUID = Config.UUID()
                local account = exports["x-jobpanel"]:GetAccount(marketName)
                local marketData = {
                    ["marketOwner"] = characterId,
                    ["marketState"] = "locked",
                    ["marketSafe"] = 0
                }
                
                local sqlQuery = [[
                    INSERT
                        INTO
                    x_markets
                        (uuid, marketName, marketState, marketData, marketOwner)
                    VALUES
                        (@uuid, @marketName, @marketState, @marketData, @marketOwner)
                    ON DUPLICATE KEY UPDATE
                        marketOwner = @marketOwner
                ]]

                MySQL.Async.execute(sqlQuery, {
                    ["@uuid"] = generatedUUID,
                    ["@marketName"] = data["marketName"],
                    ["@marketState"] = "locked",
                    ["@marketData"] = json.encode(marketData),
                    ["@marketOwner"] = characterId
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        Heap["markets"][data["marketName"]] = {}
                        Heap["markets"][data["marketName"]]["marketOwner"] = characterId
                        Heap["markets"][data["marketName"]]["marketName"] = data["marketName"]
                        Heap["markets"][data["marketName"]]["marketUUID"] = generatedUUID
                        Heap["markets"][data["marketName"]]["marketState"] = "locked"
                        Heap["markets"][data["marketName"]]["marketData"] = marketData
                        Heap["markets"][data["marketName"]]["marketAccount"] = account
                        TriggerClientEvent("x-markets:updateMarkets", -1, Heap["markets"])
                        callback(true)
                    else
                        callback(false)
                    end
                end)
            else
                callback(false)
            end
        end)
    end)

    X.CreateCallback("x-markets:canRobSafe", function(source, callback, storeName)
        if not Heap.RobbedStores then Heap.RobbedStores = {} end 

        for _, storeData in pairs(Heap.RobbedStores) do
            if storeData.Name == storeName then 
                return callback(true)
            end
        end

        callback(false)
    end)
end)