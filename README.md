# 🛡️ AntiStealer 1.1 — MM2 Security Kernel

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Environment: Luau](https://img.shields.io/badge/Language-Luau-00A2FF.svg)]()
[![Platform: PC & Mobile](https://img.shields.io/badge/Platform-Potassium%20%7C%20Delta%20%7C%20Arceus%20%7C%20Volt-brightgreen.svg)]()
[![Protection: 100%](https://img.shields.io/badge/MM2%20Shield-Active-success.svg)]()

**AntiStealer 1.1** — мощный инструмент защиты для **Murder Mystery 2 (Roblox)**. Нейтрализует скрытые стиллеры инвентаря, авто-трейд ботов, C2-панели скамеров и Discord-логгеры с нулевым влиянием на FPS и полной поддержкой сторонних скрипт-хабов (Pulse Hub, Redz Hub и др.).

---

## ⚡ Ключевые возможности v1.1

* **Защита от Confirm-ботов (Trade Timing Lock):** В MM2 встроен обязательный 3-секундный таймер перед подтверждением трейда. AntiStealer блокирует вызовы `ConfirmTrade`, происходящие быстрее 2.5с после `AcceptTrade`. Авто-боты мгновенно отсекаются, а честные трейды проходят без задержек.
* **Фильтр физического клика (Anti-ZeroClick & Burst Guard):** Блокирует скрытые манипуляции с `OfferItem`, `AcceptTrade`, `ConfirmTrade`, вызванные скриптами без нажатия мыши или тапа. Спам предметами (burst > 3) блокируется автоматически.
* **Глубокий анализ полезной нагрузки (DPI Payload Filter):** Сканирует URL и тело запросов (включая URL-декодирование `%20`, `%22`) на утечку `game.JobId` (с дефисами и без), ника и предметов MM2 (`corrupt`, `harvester`, `bat`, `chroma`, `godly` и др.).
* **Белый список доверенных хостов (`SAFE_DOMAINS`):** Запросы к официальным серверам Roblox (`roblox.com`, `roproxy.com`), GitHub, CDN и кей-системам не блокируются.
* **Авто-ликвидация Discord-вебхуков:** При перехвате вредоносного запроса отправляет фоновый запрос `DELETE` на Discord API, навсегда удаляя вебхук злоумышленника.
* **WebSocket Guard:** Контролирует каналы `WebSocket.connect`, предотвращая обход обычных HTTP-хуков.
* **Zero-Lag & Multi-Executor:** Совместим с Potassium, Delta, Arceus X, Wave, Volt. Дополнительная задержка — **0.28 мкс**, утечка памяти — **0 KB**.

---

## 🚀 Запуск скрипта

Вставьте в ваш экзекутор или добавьте в папку автозагрузки (**Auto-Execute**):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/kompozitors/antistealerRBX/main/AntiStealer.lua"))()
```

---

## 👥 Контакты и сообщество

* **Telegram-канал:** [@lattescripts](https://t.me/lattescripts)
* **Баг-баунти и поддержка:** [@vldwood](https://t.me/vldwood)
* **Репозиторий:** [github.com/kompozitors/antistealerRBX](https://github.com/kompozitors/antistealerRBX)
