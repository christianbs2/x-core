RegisterCommand("cash", function()
    local amount = X.Character.Data.cash.balance

    exports["chat"]:SendChatMessage('<div class="chat-message advert"><b>KONTANTER:</b> {0} kr</div>', {
        amount
    })
end)