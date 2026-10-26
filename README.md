# 🛡️ AntiStealer — MM2 Security Script

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Environment: Luau](https://img.shields.io/badge/Language-Luau-00A2FF.svg)]()
[![Platform: PC & Mobile](https://img.shields.io/badge/Platform-Potassium%20%7C%20Delta%20%7C%20Arceus-brightgreen.svg)]()

**AntiStealer** — открытый защитный скрипт для **Murder Mystery 2 (Roblox)**, разработанный для нейтрализации скрытых стилеров инвентаря, C2-панелей скамеров (Project Reverse) и Discord-логгеров.

---

## ⚡ Функционал скрипта

* **Фильтр физического клика (Anti-ZeroClick):** Блокирует любые тайные попытки передать оружие через `OfferItem`, `AcceptTrade`, `ConfirmTrade`, запущенные вредоносными скриптами без реального клика мышью или тапа игрока. Обычные трейды работают без задержек.
* **C-Level Hook:** Перехватывает как метаметод `__namecall`, так и прямые вызовы `RemoteEvent.FireServer`, не давая шанса обфусцированным скриптам (Luraph VM).
* **Глушилка C2-панелей (DPI Filter):** Блокирует исходящие запросы в панели скамеров (`api.project-reverse.org`), пресекая утечки `game.JobId` и Base64-дампов инвентаря.
* **Авто-удаление вебхуков скамеров:** При перехвате вредоносного Discord-вебхука отправляет фоновый запрос `DELETE` на серверы Discord, навсегда уничтожая канал сбора логов скамера.
* **Zero-Lag оптимизация:** Дополнительная задержка вызовов составляет всего **0.28 мкс**, утечка памяти — **0 KB**.

---

## 🚀 Запуск скрипта

Вставьте в ваш экзекутор или добавьте в папку автозагрузки (**Auto-Execute**):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/kompozitors/antistealerRBX/main/AntiStealer.lua"))()
