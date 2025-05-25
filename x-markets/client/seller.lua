OpenBuyMenu = function(pageIndex)
    local options = {}
    local fakeOptions = {}

    table.insert(options, {
        ["label"] = "~y~Affärer till salu"
    })

    for marketName, marketData in pairs(Config.Markets) do
        marketData["marketName"] = marketName
        table.insert(fakeOptions, marketData)
    end

    local subMenuOptions = {
        {
            ["label"] = "Köp affär",
            ["callback"] = function()
                BuyMarket({
                    ["label"] = "Affär - " .. marketName .. " - " .. marketData["marketPrice"] .. " SEK.",
                    ["rawLabel"] = "Affär - " .. marketName,
                    ["price"] = marketData["marketPrice"],
                    ["marketName"] = marketName
                })
            end
        },
        {
            ["label"] = "Kolla på affär",
            ["callback"] = function()
                ShopCam(marketName)
            end
        },
    }

    if not pageIndex then pageIndex = 1 end

    local animationsPerPage = 7

    for currentMenuIndex = animationsPerPage * pageIndex - (animationsPerPage - 1), animationsPerPage * pageIndex do
        local currentMenu = fakeOptions[currentMenuIndex]

        if currentMenu then
            local subMenuOptions = {
                {
                    ["label"] = "Köp affär",
                    ["callback"] = function()
                        BuyMarket({
                            ["label"] = "Affär - " .. currentMenu["marketName"] .. " - " .. currentMenu["marketPrice"] .. " SEK.",
                            ["rawLabel"] = "Affär - " .. currentMenu["marketName"],
                            ["price"] = currentMenu["marketPrice"],
                            ["marketName"] = currentMenu["marketName"]
                        })
                    end
                },

                {
                    ["label"] = "Kolla på affär",
                    ["callback"] = function()
                        ShopCam(currentMenu["marketName"])
                    end
                },
            }

            table.insert(options, {
                ["label"] = currentMenu["marketName"] .. " - " .. currentMenu["marketPrice"] .. " SEK.",
                ["subMenu"] = {
                    options = subMenuOptions
                }
            })
        end
    end

    if pageIndex > 1 then
        table.insert(options, {
            label = "~r~⬅",
            callback = function()
                OpenBuyMenu(pageIndex - 1)
            end
        })
    end

    if fakeOptions[(animationsPerPage * pageIndex) + 1] then
        table.insert(options, {
            label = "~g~➡",
            callback = function()
                OpenBuyMenu(pageIndex + 1)
            end
        })
    end

     table.insert(options, {
         ["label"] = "   " .. marketName .. " - " .. marketData["marketPrice"] .. " SEK. ",
         ["subMenu"] = {
             options = subMenuOptions[marketName]
         }
     })

    exports["x-context"]:OpenContextMenu({
        ["menu"] = "Store Seller-" .. Heap["peds"]["seller"]["handle"],
        ["entity"] = Heap["peds"]["seller"]["handle"],
        ["options"] = options,
        ["oldPos"] = true
     })
end

PurchaseOptions = function(data)
    local menuElements = {}
    X.UI.Menu.Open("default", GetCurrentResourceName(), "buy_market_menu", {
        ["title"] = "Affärer till salu.",
        ["align"] = "right",
        ["elements"] = {
            {
                ["label"] = "Kolla på affär",
                ["action"] = "camera"
            },
            {
                ["label"] = "Köp Affär för "..data["price"].." SEK",
                ["action"] = "buy"
            },
            {
                ["label"] = "Gå tillbaka",
            }
        }
    }, function(menuData, menuHandle)
        menuHandle.close()

        local menuAction = menuData["current"]["action"]

        if menuAction == "camera" then
            ShopCam(data["marketName"])
        elseif menuAction == "buy" then
            BuyMarket(data)
        else
            OpenBuyMenu()
        end

    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

BuyMarket = function(data)
    X.Callback("x-markets:purchaseMarket", function(purchased)
        if purchased then
            X.Notify("Försäljare", "Du köpte "..data["rawLabel"].." för "..data["price"].." SEK")
        else
            X.Notify("Försäljare", "Ditt köp misslyckades, vänligen försök igen.")
        end
    end, data)
end

ShopCam = function(marketName)
    local playerPed = PlayerPedId()

    marketData = Config.Markets[marketName]

    Heap["currentCam"] = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", marketData["marketCamera"]["camPos"], marketData["marketCamera"]["camRotation"], 80.0)
    Heap["cachedCoords"] = GetEntityCoords(playerPed)

    Citizen.CreateThread(function()
        DoScreenFadeOut(1500)
        Citizen.Wait(2000)
        SetFocusPosAndVel(marketData["marketCamera"]["camPos"])
        NetworkConcealPlayer(PlayerId(), true)
        SetCamActive(Heap["currentCam"], true)
        RenderScriptCams(true, false, 0, true, true)
        DoScreenFadeIn(1250)

        while DoesCamExist(Heap["currentCam"]) do

            Citizen.Wait(5)

            DrawButtons({
                {
                    ["button"] = "~INPUT_FRONTEND_RRIGHT~",
                    ["label"] = "Gå tillbaka."
                }
            })

            if IsControlJustReleased(0, 177) then
                DoScreenFadeOut(1500)
                Citizen.Wait(2500)
                SetFocusEntity(playerPed)
                DestroyCam(Heap["currentCam"], true)
                RenderScriptCams(false, false, 0, true, true)
                NetworkConcealPlayer(PlayerId(), false)
                DoScreenFadeIn(1250)
                OpenBuyMenu()
                break
            end
        end
    end)
end

Teleport = function(coords, context)
    DoScreenFadeOut(1200)
    Citizen.Wait(1200)
    SetEntityCoords(Heap["ped"], coords)
    FreezeEntityPosition(Heap["ped"], true)

    while not HasCollisionLoadedAroundEntity(Heap["ped"]) do
        Citizen.Wait(0)
    end

    FreezeEntityPosition(Heap["ped"], false)
    DoScreenFadeIn(1200)

    exports["x-context"]:RemoveSelfContextOption(context)

    Heap["tpContext"] = false
end