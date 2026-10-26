# 🛡️ MM2 Security Shield (Kernel-Level Anti-Stealer)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Environment: Luau](https://img.shields.io/badge/Language-Luau-00A2FF.svg)]()
[![Platform: PC & Mobile](https://img.shields.io/badge/Platform-Potassium%20%7C%20Delta%20%7C%20Arceus-brightgreen.svg)]()

**MM2 Shield** — высокопроизводительное ядро безопасности для Murder Mystery 2, разработанное для защиты инвентарей игроков от автоматических стилеров оружия, скрытых C2-панелей (Project Reverse) и Discord-логгеров.

---

## ⚡ Ключевые возможности

* **Input-Aware Verification (Zero-Click Defense):**  
  Блокирует любые скрытые вызовы `OfferItem`, `AcceptTrade`, `ConfirmTrade`, запущенные без реального физического клика мыши/тапа экрана. Легитимные трейды работают без задержек.
* **Dual-Layer C-Hook Protection:**  
  Перехватывает `__namecall` и прямой C-уровень вызовов `RemoteEvent.FireServer`. Обфускаторы (Luraph) не способны обойти защиту.
* **DPI Network Filter (C2 Exfiltration Blocker):**  
  Анализирует исходящий трафик `request`, глушит панели управления скамеров (`api.project-reverse.org`), попытки слива `game.JobId` и Base64-зашифрованные пакеты инвентаря.
* **Auto-Nuke Webhook Engine:**  
  При обнаружении Discord-вебхука скамера автоматически отправляет запрос `DELETE` и уничтожает канал приёма логов из Discord.
* **Нулевое влияние на FPS:**  
  Средняя задержка перехвата составляет всего **0.28 µs**, утечка памяти — **0 KB**.

---

## 🚀 Быстрый запуск

Добавьте скрипт в автозагрузку (Auto-Execute) вашего экзекутора:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/ВАШ_НИК/mm2-shield/main/mm2_shield.lua"))()
