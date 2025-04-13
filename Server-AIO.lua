-- Server-side Lua script
if not _G.RegisteredAIOHandlers then
    _G.RegisteredAIOHandlers = {}
end

if not _G.RegisteredAIOHandlers["MultiEnchantTooltip"] then
    AIO.AddHandlers("MultiEnchantTooltip", {
        RequestEnchants = function(player, itemGUID)
            print("Debug: Received request for item GUID:", itemGUID)
            local enchantIDs = GetEnchantmentsForItem(itemGUID) -- 假设这个函数返回附魔ID的表
            if enchantIDs then
                print("Debug: Sending enchants for item GUID:", itemGUID)
                AIO.Msg():Add("MultiEnchantTooltip", "SendEnchants", itemGUID, enchantIDs):Send(player)
            else
                print("Debug: No enchants found for item GUID:", itemGUID)
            end
        end
    })
    _G.RegisteredAIOHandlers["MultiEnchantTooltip"] = true
end
print(">>>  Loading  sed.. end")
