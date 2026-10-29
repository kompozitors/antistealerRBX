-- MM2 Anti-Stealer / Inventory Shield
-- Developed by @lattescripts (https://t.me/lattescripts)
-- Open-Source Security Module for Murder Mystery 2

if not game:IsLoaded() then
    game.Loaded:Wait()
end

do
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local SoundService = game:GetService("SoundService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Debris = game:GetService("Debris")

    local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local playerName = LocalPlayer.Name
    local userId = tostring(LocalPlayer.UserId)
    local currentJobId = tostring(game.JobId)

    local Stats = {
        BlockedTrades = 0,
        BlockedWebhooks = 0
    }

    local lastPhysicalInputTime = 0

    pcall(function()
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 
            or input.UserInputType == Enum.UserInputType.Touch then
                lastPhysicalInputTime = os.clock()
            end
        end)
    end)

    local function isRecentPhysicalInput()
        return (os.clock() - lastPhysicalInputTime) <= 3.0
    end

    local function showInGameAlert(title, message, isDanger)
        task.spawn(function()
            pcall(function()
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxasset://sounds/bell.wav"
                sound.Volume = 1.0
                sound.Parent = SoundService
                sound:Play()
                Debris:AddItem(sound, 3)
            end)

            pcall(function()
                StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = string.format("[Анти-Стиллер @lattescripts]: %s — %s", tostring(title), tostring(message)),
                    Color = isDanger and Color3.fromRGB(255, 75, 75) or Color3.fromRGB(60, 230, 110),
                    Font = Enum.Font.GothamBold,
                    TextSize = 14
                })
            end)

            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = title or "Анти-Стиллер by @lattescripts",
                    Text = message or "",
                    Duration = 5
                })
            end)

            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 4)
                if not playerGui then return end

                local alertGuiName = "MM2ShieldAlertHUD"
                local existing = playerGui:FindFirstChild(alertGuiName)
                if existing then existing:Destroy() end

                local screenGui = Instance.new("ScreenGui")
                screenGui.Name = alertGuiName
                screenGui.ResetOnSpawn = false
                screenGui.IgnoreGuiInset = true
                screenGui.DisplayOrder = 999999
                screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                screenGui.Parent = playerGui

                local card = Instance.new("Frame")
                card.Name = "AlertCard"
                card.Size = UDim2.new(0, 420, 0, 80)
                card.Position = UDim2.new(0.5, -210, 0, -110)
                card.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
                card.BorderSizePixel = 0
                card.ZIndex = 1000
                card.Parent = screenGui

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 10)
                corner.Parent = card

                local stroke = Instance.new("UIStroke")
                stroke.Color = isDanger and Color3.fromRGB(250, 60, 60) or Color3.fromRGB(40, 200, 95)
                stroke.Thickness = 2
                stroke.Parent = card

                local bar = Instance.new("Frame")
                bar.Size = UDim2.new(0, 6, 1, 0)
                bar.BackgroundColor3 = stroke.Color
                bar.BorderSizePixel = 0
                bar.ZIndex = 1001
                bar.Parent = card
                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(0, 10)
                barCorner.Parent = bar

                local icon = Instance.new("TextLabel")
                icon.Size = UDim2.new(0, 50, 1, 0)
                icon.Position = UDim2.new(0, 6, 0, 0)
                icon.BackgroundTransparency = 1
                icon.Text = isDanger and "🚨" or "🛡️"
                icon.TextSize = 28
                icon.ZIndex = 1001
                icon.Parent = card

                local titleLabel = Instance.new("TextLabel")
                titleLabel.Size = UDim2.new(1, -65, 0, 22)
                titleLabel.Position = UDim2.new(0, 58, 0, 10)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Font = Enum.Font.GothamBold
                titleLabel.TextSize = 14
                titleLabel.TextColor3 = stroke.Color
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.Text = title or "Анти-Стиллер by @lattescripts"
                titleLabel.ZIndex = 1001
                titleLabel.Parent = card

                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(1, -65, 0, 40)
                descLabel.Position = UDim2.new(0, 58, 0, 32)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextSize = 12
                descLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
                descLabel.TextWrapped = true
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextYAlignment = Enum.TextYAlignment.Top
                descLabel.Text = message or "Скрытая угроза успешно заблокирована!"
                descLabel.ZIndex = 1001
                descLabel.Parent = card

                local tweenIn = TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, -210, 0, 48)
                })
                tweenIn:Play()

                task.delay(5.5, function()
                    if card and card.Parent then
                        local tweenOut = TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                            Position = UDim2.new(0.5, -210, 0, -110)
                        })
                        tweenOut:Play()
                        tweenOut.Completed:Connect(function()
                            screenGui:Destroy()
                        end)
                    end
                end)
            end)
        end)
    end

    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local b64lookup = {}
    for i = 1, #b64chars do
        b64lookup[b64chars:sub(i, i)] = i - 1
    end

    local nativeB64Decode = (crypt and (crypt.base64decode or crypt.base64_decode)) or base64_decode

    local function safeBase64Decode(data)
        if type(data) ~= "string" or #data < 4 then return "" end

        if nativeB64Decode then
            local ok, res = pcall(nativeB64Decode, data)
            if ok and type(res) == "string" then return res end
        end

        local len = #data
        local out = {}
        local outIdx = 1
        local i = 1

        while i <= len do
            local c1 = b64lookup[data:sub(i, i)]
            local c2 = b64lookup[data:sub(i+1, i+1)]
            local c3 = b64lookup[data:sub(i+2, i+2)]
            local c4 = b64lookup[data:sub(i+3, i+3)]
            i = i + 4

            if c1 and c2 then
                out[outIdx] = string.char((c1 * 4) + math.floor(c2 / 16))
                outIdx = outIdx + 1
                if c3 then
                    out[outIdx] = string.char(((c2 % 16) * 16) + math.floor(c3 / 4))
                    outIdx = outIdx + 1
                    if c4 then
                        out[outIdx] = string.char(((c3 % 4) * 64) + c4)
                        outIdx = outIdx + 1
                    end
                end
            end
        end

        return table.concat(out)
    end

    local CRITICAL_INVENTORY_REMOTES = {
        "offeritem",
        "additem",
        "accepttrade",
        "confirmtrade",
        "dropitem",
        "gettradestatus"
    }

    local function isCriticalTradeRemote(instance)
        if not instance or typeof(instance) ~= "Instance" then
            return false
        end

        local className = instance.ClassName
        if className ~= "RemoteEvent" and className ~= "RemoteFunction" and className ~= "UnreliableRemoteEvent" then
            return false
        end

        local nameLower = string.lower(instance.Name)
        for i = 1, #CRITICAL_INVENTORY_REMOTES do
            if string.find(nameLower, CRITICAL_INVENTORY_REMOTES[i], 1, true) then
                return true
            end
        end

        return false
    end

    local lastOfferTime = 0
    local offerCountInWindow = 0
    local lastAcceptTradeTime = 0

    local function isAutomatedBurst(remoteInstance)
        local n = string.lower(remoteInstance.Name)
        if n == "offeritem" or n == "additem" then
            local now = os.clock()
            if (now - lastOfferTime) < 1.0 then
                offerCountInWindow = offerCountInWindow + 1
                if offerCountInWindow > 3 then
                    return true
                end
            else
                lastOfferTime = now
                offerCountInWindow = 1
            end
        end
        return false
    end

    local oldNamecall = nil
    local hookmetamethod = hookmetamethod
    local getnamecallmethod = getnamecallmethod or function() return "" end
    local newcclosure = newcclosure or function(f) return f end

    local function handleTradeInterception(remoteInstance, method)
        local isHuman = isRecentPhysicalInput()
        local remoteNameLower = string.lower(remoteInstance.Name)
        local now = os.clock()

        -- Защита от Confirm-ботов: в MM2 между Accept и Confirm обязательный 3-секундный кулдаун.
        -- Человек физически не может нажать Confirm раньше чем через 2.5с. Любая попытка мгновенного Confirm — стиллер-бот.
        if string.find(remoteNameLower, "confirmtrade", 1, true) then
            if (now - lastAcceptTradeTime) < 2.5 then
                Stats.BlockedTrades = Stats.BlockedTrades + 1
                warn(string.format("[Щит @lattescripts]: Заблокирован мгновенный ConfirmTrade (%.2fс после Accept)! Авто-трейд бот остановлен.", now - lastAcceptTradeTime))
                showInGameAlert("⚠️ ОБНАРУЖЕН ТРЕЙД-БОТ!", "Скрипт пытался мгновенно подтвердить трейд в обход таймера MM2! Атака отражена (@lattescripts).", true)
                return true
            end
        end

        if string.find(remoteNameLower, "accepttrade", 1, true) then
            lastAcceptTradeTime = now
        end

        if isHuman then
            if isAutomatedBurst(remoteInstance) then
                Stats.BlockedTrades = Stats.BlockedTrades + 1
                warn("[Щит @lattescripts]: Заблокирован автоматический слив оружия (Burst)!")
                showInGameAlert("⚠️ ОБНАРУЖЕН ТРЕЙД-БОТ!", "Скрипт пытался быстро слить ваше оружие! Авто-вывод остановлен (@lattescripts).", true)
                return true
            end
            return false
        end

        Stats.BlockedTrades = Stats.BlockedTrades + 1
        local remoteName = tostring(remoteInstance.Name)
        warn(string.format("[Щит @lattescripts]: Заблокирован скрытый трейд-ремоут: %s (%s)", remoteName, method))
        showInGameAlert("⚠️ ПОПЫТКА КРАЖИ ОРУЖИЯ!", "Запущенный скрипт тайно пытался передать ножи через трейд (" .. remoteName .. ")! Попытка заблокирована.", true)
        return true
    end

    local isNamecallHooked = false
    local isFireServerHooked = false

    if hookmetamethod then
        local success = pcall(function()
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if (method == "FireServer" or method == "InvokeServer" or method == "fireServer" or method == "invokeServer") then
                    if isCriticalTradeRemote(self) then
                        local shouldBlock = handleTradeInterception(self, method)
                        if shouldBlock then return nil end
                    end
                end
                return oldNamecall(self, ...)
            end))
        end)
        isNamecallHooked = success and (oldNamecall ~= nil)
    end

    if hookfunction then
        local success = pcall(function()
            local dummyEvent = Instance.new("RemoteEvent")
            local origFireServer = dummyEvent.FireServer
            hookfunction(origFireServer, newcclosure(function(self, ...)
                if typeof(self) == "Instance" and isCriticalTradeRemote(self) then
                    local shouldBlock = handleTradeInterception(self, "Direct-FireServer")
                    if shouldBlock then return nil end
                end
                return origFireServer(self, ...)
            end))
            dummyEvent:Destroy()
        end)
        isFireServerHooked = success
    end

    local SAFE_DOMAINS = {
        "roblox.com",
        "roproxy.com",
        "rbxcdn.com",
        "github.com",
        "githubusercontent.com",
        "pastebin.com",
        "gitlab.com"
    }

    local function isSafeDomain(url)
        if type(url) ~= "string" then return false end
        local host = string.match(string.lower(url), "^%a+://([^/]+)") or string.match(string.lower(url), "^([^/]+)")
        if not host then return false end
        host = string.match(host, "^([^:]+)") or host
        for i = 1, #SAFE_DOMAINS do
            local safeDom = SAFE_DOMAINS[i]
            if host == safeDom or string.sub(host, -#safeDom - 1) == "." .. safeDom then
                return true
            end
        end
        return false
    end

    local MALICIOUS_TARGETS = {
        "api/webhooks",
        "discordapp.com/api",
        "discord.com/api/webhooks",
        "webhook",
        "project-reverse.org",
        "iplogger",
        "grabber",
        "2no.co",
        "blasze",
        "rip/trade",
        "inventory-logger",
        "api.telegram.org/bot",
        "webhook.site",
        "pipedream.net"
    }

    local function safeUrlDecode(str)
        if type(str) ~= "string" or not string.find(str, "%", 1, true) then return str end
        local ok, res = pcall(function()
            return string.gsub(str, "%%(%x%x)", function(hex)
                return string.char(tonumber(hex, 16))
            end)
        end)
        return (ok and res) or str
    end

    local INVENTORY_KEYWORDS = {
        "inventory",
        "godly",
        "ancient",
        "chroma",
        "vintage",
        "harvester",
        "corrupt",
        "candleflame",
        "swirly",
        "bat",
        "knife",
        "gun",
        "weapons",
        "iceflake",
        "trade",
        "potassium",
        "stealer"
    }

    local function isMaliciousExfiltration(url, rawBody)
        local lowerUrl = type(url) == "string" and string.lower(url) or ""
        local lowerBody = type(rawBody) == "string" and string.lower(rawBody) or ""
        local decodedBody = safeUrlDecode(lowerBody)
        local fullPayload = lowerUrl .. " " .. decodedBody

        -- 1. Детект известных C2/вебхук адресов
        for i = 1, #MALICIOUS_TARGETS do
            if string.find(lowerUrl, MALICIOUS_TARGETS[i], 1, true) then
                return true, "Discord / C2 Вебхук"
            end
        end

        -- 2. Если домен доверенный (Roblox API, RoProxy, GitHub, CDN) — не блокируем
        if isSafeDomain(lowerUrl) then
            return false, nil
        end

        -- 3. Детект утечки JobID (с дефисами и без дефисов) в URL или Body на сторонние хосты
        if #currentJobId > 5 then
            local lowerJobId = string.lower(currentJobId)
            local lowerJobIdNoHyphens = string.gsub(lowerJobId, "%-", "")
            if string.find(fullPayload, lowerJobId, 1, true) or (#lowerJobIdNoHyphens >= 30 and string.find(fullPayload, lowerJobIdNoHyphens, 1, true)) then
                return true, "Утечка JobID сервера (C2-слежение)"
            end
        end

        -- 4. Детект инвентаря вместе с ником или UserId
        if #decodedBody > 0 then
            local lowerName = string.lower(playerName)
            local hasIdentity = string.find(fullPayload, lowerName, 1, true) or string.find(fullPayload, userId, 1, true)

            if hasIdentity then
                for _, kw in ipairs(INVENTORY_KEYWORDS) do
                    if string.find(fullPayload, kw, 1, true) then
                        return true, "Сигнатура слива инвентаря"
                    end
                end
            end
        end

        -- 5. Поиск скрытых Base64 полезных нагрузок (в URL и теле)
        local rawCombined = (type(rawBody) == "string" and rawBody or "") .. " " .. lowerUrl
        for token in string.gmatch(rawCombined, "([A-Za-z0-9+/=]+)") do
            if #token >= 16 then
                local decoded = safeBase64Decode(token):lower()
                if #decoded > 5 then
                    if #currentJobId > 5 then
                        local lowerJobId = string.lower(currentJobId)
                        local lowerJobIdNoHyphens = string.gsub(lowerJobId, "%-", "")
                        if string.find(decoded, lowerJobId, 1, true) or (#lowerJobIdNoHyphens >= 30 and string.find(decoded, lowerJobIdNoHyphens, 1, true)) then
                            return true, "Base64-утечка JobID"
                        end
                    end
                    for _, kw in ipairs(INVENTORY_KEYWORDS) do
                        if string.find(decoded, kw, 1, true) then
                            return true, "Base64-утечка инвентаря"
                        end
                    end
                end
            end
        end

        return false, nil
    end

    local origRequest = nil
    local nukedWebhooks = {}

    local function cleanDiscordWebhookUrl(rawUrl)
        if type(rawUrl) ~= "string" then return nil end
        local unescaped = string.gsub(rawUrl, "\\/", "/")
        local domain, id, token = string.match(unescaped, "(discord[%w%.]*/api/webhooks)/(%d+)/([^%s%?\"'%&<>]+)")
        if domain and id and token and #token >= 10 then
            return "https://" .. domain .. "/" .. id .. "/" .. token
        end
        return nil
    end

    local function isDiscordWebhook(targetUrl)
        return cleanDiscordWebhookUrl(targetUrl) ~= nil
    end

    local function deleteDiscordWebhook(targetUrl, onResult)
        local cleanUrl = cleanDiscordWebhookUrl(targetUrl)
        if not cleanUrl or not origRequest then
            if onResult then onResult(false) end
            return
        end

        if nukedWebhooks[cleanUrl] then
            if onResult then onResult(true) end
            return
        end

        task.spawn(function()
            local ok, res = pcall(function()
                return origRequest({
                    Url = cleanUrl,
                    Method = "DELETE",
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
                    }
                })
            end)

            local statusCode = (ok and type(res) == "table" and res.StatusCode) or 0
            local isDeleted = (statusCode == 204 or statusCode == 200 or statusCode == 404)
            if isDeleted then
                nukedWebhooks[cleanUrl] = true
                warn(string.format("[Щит @lattescripts]: 💀 Вебхук скамера успешно уничтожен (Discord HTTP %d): %s", statusCode, cleanUrl))
            else
                warn(string.format("[Щит @lattescripts]: Ответ Discord на удаление вебхука (HTTP %s): %s", tostring(statusCode), cleanUrl))
            end

            if onResult then
                onResult(isDeleted)
            end
        end)
    end

    local function scanAndDeleteWebhooks(rawBody)
        if type(rawBody) ~= "string" or not origRequest then return end
        local unescaped = string.gsub(rawBody, "\\/", "/")
        for hook in string.gmatch(unescaped, "https?://[^%s\"'<>]+discord[%.%w]*/api/webhooks/%d+/[^%s%?\"'%&<>]+") do
            local clean = cleanDiscordWebhookUrl(hook)
            if clean then
                deleteDiscordWebhook(clean, function(success)
                    if success then
                        showInGameAlert(
                            "Кастрировал вебхук скамера",
                            "Вебхук стиллера успешно подтверждён и навсегда удалён из Discord! (@lattescripts)",
                            true
                        )
                    end
                end)
            end
        end
    end

    local function safeRequest(requestData, ...)
        if type(requestData) == "table" then
            local url = requestData.Url or requestData.url or requestData.URL
            local body = requestData.Body or requestData.body or ""

            local isMalicious, reason = isMaliciousExfiltration(url, body)
            if isMalicious then
                Stats.BlockedWebhooks = Stats.BlockedWebhooks + 1
                warn(string.format("[Щит @lattescripts]: Заблокирована попытка слива данных (%s): %s", tostring(reason), tostring(url)))

                local targetWebhook = cleanDiscordWebhookUrl(url)
                if not targetWebhook and type(body) == "string" then
                    local unescapedBody = string.gsub(body, "\\/", "/")
                    for hook in string.gmatch(unescapedBody, "https?://[^%s\"'<>]+discord[%.%w]*/api/webhooks/%d+/[^%s%?\"'%&<>]+") do
                        local clean = cleanDiscordWebhookUrl(hook)
                        if clean then
                            targetWebhook = clean
                            break
                        end
                    end
                end

                if targetWebhook then
                    deleteDiscordWebhook(targetWebhook, function(success)
                        if success then
                            showInGameAlert(
                                "Кастрировал вебхук скамера",
                                "Вебхук стиллера успешно подтверждён и навсегда удалён из Discord! (@lattescripts)",
                                true
                            )
                        else
                            showInGameAlert(
                                "⚠️ ВНИМАНИЕ: СТИЛЛЕР ОБНАРУЖЕН!",
                                "Запущенный вами скрипт пытался слить инвентарь на Webhook! Атака отражена (@lattescripts).",
                                true
                            )
                        end
                    end)
                else
                    showInGameAlert(
                        "⚠️ ВНИМАНИЕ: СТИЛЛЕР ОБНАРУЖЕН!",
                        "Запущенный вами скрипт пытался слить данные (" .. tostring(reason) .. ")! Атака отражена (@lattescripts).",
                        true
                    )
                end

                scanAndDeleteWebhooks(body)

                return {
                    StatusCode = 200,
                    StatusMessage = "OK",
                    Success = true,
                    Body = '{"status":"ok","message":"Protected"}',
                    Headers = {
                        ["content-type"] = "application/json",
                        ["server"] = "MM2-Shield"
                    }
                }
            end
        end

        if origRequest then
            return origRequest(requestData, ...)
        end
    end

    local isRequestHooked = false
    local rawReq = request or http_request

    if rawReq and hookfunction then
        local success, hookedOrig = pcall(function()
            return hookfunction(rawReq, newcclosure(safeRequest))
        end)
        if success and hookedOrig then
            origRequest = hookedOrig
            isRequestHooked = true
        else
            origRequest = rawReq
        end
    else
        origRequest = rawReq
    end

    local wrappedClosure = newcclosure(safeRequest)
    getgenv().request = wrappedClosure
    getgenv().http_request = wrappedClosure

    if type(syn) == "table" and type(syn.request) == "function" then
        pcall(function() hookfunction(syn.request, wrappedClosure) end)
    end
    if type(http) == "table" and type(http.request) == "function" then
        pcall(function() hookfunction(http.request, wrappedClosure) end)
    end

    local rawWsConnect = (WebSocket and WebSocket.connect) or (syn and type(syn) == "table" and type(syn.websocket) == "table" and syn.websocket.connect)
    if rawWsConnect and hookfunction then
        pcall(function()
            hookfunction(rawWsConnect, newcclosure(function(url, ...)
                local lowerUrl = type(url) == "string" and string.lower(url) or ""
                for i = 1, #MALICIOUS_TARGETS do
                    if string.find(lowerUrl, MALICIOUS_TARGETS[i], 1, true) then
                        Stats.BlockedWebhooks = Stats.BlockedWebhooks + 1
                        warn("[Щит @lattescripts]: Заблокировано опасное WebSocket-соединение: " .. tostring(url))
                        showInGameAlert("⚠️ ВНИМАНИЕ: СТИЛЛЕР ОБНАРУЖЕН!", "Скрипт пытался открыть WebSocket-канал на сервер скамера! Соединение заблокировано.", true)
                        return nil
                    end
                end
                return rawWsConnect(url, ...)
            end))
        end)
    end

    getgenv().ShieldStats = function()
        print(string.format("[Щит @lattescripts]: Заблокировано трейдов: %d | Заблокировано вебхуков: %d", Stats.BlockedTrades, Stats.BlockedWebhooks))
    end

    local fullyProtected = (isNamecallHooked or isFireServerHooked) and (isRequestHooked or rawReq ~= nil)
    if fullyProtected then
        showInGameAlert(
            "Анти-Стиллер by @lattescripts",
            "Защита инвентаря активна! Трейды работают штатно.",
            false
        )
        print("[Щит @lattescripts]: Успешно загружен. Все уровни защиты активны!")
    else
        warn("[Щит @lattescripts]: Предупреждение: некоторые C-хуки не поддерживаются вашим экзекутором! Защита может работать ограниченно.")
        showInGameAlert(
            "Анти-Стиллер by @lattescripts",
            "Внимание: экзекутор частично ограничил C-хуки!",
            true
        )
    end
end
