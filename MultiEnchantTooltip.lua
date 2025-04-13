local ADDON_NAME = "MultiEnchantTooltip"

local function OnTooltipSetItem(tooltip)
    local _, itemLink = tooltip:GetItem()
    if not itemLink then 
        print("Debug: No item link found.")
        return 
    end
    
    -- 请求服务器发送附魔信息
    local itemGUID = GetItemGUID(itemLink) -- 假设这个函数可以获取物品的GUID
    if itemGUID then
        print("Debug: Sending request for item GUID:", itemGUID)
        AIO.Msg():Add("MultiEnchantTooltip", "RequestEnchants", itemGUID):Send()
    else
        print("Debug: Failed to get item GUID.")
    end
end

-- 注册到所有工具提示
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", function(tooltip)
    print("Debug: ItemRefTooltip clicked.")
    OnTooltipSetItem(tooltip)
end)
ShoppingTooltip1:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ShoppingTooltip2:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", OnTooltipSetItem)

-- 注册 AIO 事件
AIO.AddHandlers("MultiEnchantTooltip", {
    SendEnchants = function(itemGUID, enchantIDs)
        local itemLink = GetItemLinkByGUID(itemGUID)
        if not itemLink then 
            print("Debug: No item link found for GUID:", itemGUID)
            return 
        end

        -- 调试输出：显示接收到的附魔ID
        print("Debug: Received enchants for item GUID:", itemGUID)
        for i, enchantID in ipairs(enchantIDs) do
            print("Debug: Enchant ID:", enchantID)
        end

        -- 构建附魔信息字符串
        local enchantText = "额外附魔效果:"
        for i, enchantID in ipairs(enchantIDs) do
            if enchantID and enchantID > 0 then
                local enchantName = GetSpellInfo(enchantID)
                if enchantName then
                    print("Debug: Received enchant:", enchantName)
                    enchantText = enchantText .. "\n|cff00ff00" .. enchantName .. "|r"
                else
                    print("Debug: No enchant name found for ID:", enchantID)
                end
            end
        end

        -- 在聊天框中显示
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ffff" .. itemLink .. "|r 的附魔效果:")
        DEFAULT_CHAT_FRAME:AddMessage(enchantText)
    end
})