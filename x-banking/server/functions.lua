function GetAccountMembers(accountName)
    local members = {}

    for characterId, member in pairs(Heap.Characters) do
        local dataStorage = exports["x-datastorage"]:GetStorage(characterId)

        local accounts = dataStorage.Get("ACCOUNTS") or {}

        for _, account in ipairs(accounts) do
            if account.AccountName == accountName then
                table.insert(members, member)
            end
        end
    end

    return members
end