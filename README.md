<div align="center">

  <!-- БАННЕР / ЛОГО -->
  <img src="https://i.ibb.co/vx5yR1Kd/uvsoprkl.png" alt="Mortis Hack Banner" width="720">

  <br><br>
  <img src="https://img.shields.io/badge/Roblox-Script-blueviolet?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Mortis%20NVM-v3.3-red?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Game-Tower%20Battles-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/UI-Rayfield-00bcd4?style=for-the-badge" />

  <br><br>

  <b>Mortis NVM HACK v3.3 — Tower Battles Rayfield GUI</b>
  <p>Версия с автопрокачкой, фри‑апгрейдами, бустами рейнджа/дамага, фармом кеша и визуальным «перегрузом» молний.</p>

  <!-- ПРЕВЬЮ ИНТЕРФЕЙСА / ГЕЙМПЛЕЯ -->
  <!-- ЗАМЕНИ ССЫЛКИ НА СВОИ СКРИНЫ -->
  <img src="https://i.ibb.co/1J7G0cjJ/v942u6a3.jpg" alt="Mortis NVM HACK Main Menu" width="480">

</div>

---

### Галерея

-   
  <img src="https://i.ibb.co/nsSdQKs9/s7jkl5tr.jpg" alt="Mortis NVM HACK Cheats Tab" width="480">

- 
  <img src="https://i.ibb.co/CpsWZKDD/mee4kqj1.jpg" alt="Mortis NVM HACK Visuals Tab" width="480">

- 
  <img src="https://i.ibb.co/q3hx6vLt/990noujc.jpg" alt="Mortis NVM HACK Cash Farm" width="480">

-   
  <img src="https://i.ibb.co/PzM6K3zM/fpgu4cas.jpg" alt="Mortis NVM HACK Max Range & Super Fire" width="480">

> Заменишь ссылки на свои реальные скриншоты с Imgur/ibb.co.

---

### Основные функции

- **Auto Upgrade (Free)**  
  Автоматически апгрейдит все твои башни с минимальной задержкой.  
  Вызовы апгрейда идут с ценой `0`, что позволяет быстро проталкивать левелы без ручного клика.  

- **Free Upgrades (Cost = 0)**  
  Хук на `UpgradeTower` и связанные ремоуты с проверкой `cost/price/spend/enough`.  
  Попытки списать деньги за апгрейд принудительно проходят как бесплатные (стоимость = 0).  

- **Max Range**  
  Каждый кадр (Heartbeat) пробегается по башням игрока и насильно ставит `range`‑поля в указанное значение (по умолчанию `3500`).  
  Работает со всеми `NumberValue/IntValue`, где в имени есть `range`.  

- **Super Fire (Max Fire Rate / 99999 Bullets)**  
  Бустит количество снарядов (`burst/projectiles/shots/bullets/multi/count/amount/pellets`) до огромного значения.  
  Одновременно режет кулдауны (`cooldown/firerate/rate/delay/interval/reload`) до очень мелкого интервала для спама по линии.  

- **DJ / Commander Buff**  
  Насильно множит все бафф‑поля (`multiplier/buff/boost/dj/commander/...boost`) до выбранного множителя (по умолчанию `x99999`).  
  Работает с любыми башнями‑бафферами, у которых бусты завязаны на числовые значения.  

- **x9999 Cash Per Kill**  
  Каждые `Delay` секунд пробегает по `ReplicatedStorage` и спамит в подходящие `RemoteEvent` (`kill/enemykilled/reward/cash/credit/earn/gain/money`) выбранную сумму.  
  Позволяет очень быстро накапливать деньги без ожидания волн.  

- **Visual Boost (Lightning Overload)**  
  Усиливает любые тексты с ⚡/lightning/bolt/shock в GUI: меняет шрифт, цвет, размер, ставит `+9999999%`.  
  Одновременно бустит `ParticleEmitter` с похожими именами: дикий `Rate`, высокая скорость и увеличенное время жизни частиц.  

- **Управление GUI**  
  - **F1** — скрыть / показать весь Rayfield‑интерфейс.  
  - **RightShift** — стандартное меню Rayfield.  

---

## Архитектура

- **Монолитный `runtime.lua`**  
  Весь функционал (Cheats + Visuals + Rayfield‑GUI + хуки) живёт в одном файле `runtime.lua`.  
  Это облегчает загрузку через `loadstring(game:HttpGet(...))()` и уменьшает риск, что у юзера что‑то не догрузится.  

- **Лёгкий загрузчик `main.lua`**  
  Отдельный файл‑вход, который просто тянет `runtime.lua` по HTTP и исполняет.  
  Подходит под Xeno / Synapse / Delta / Fluxus и т.п. — всю логику держим в `runtime.lua`, а наружу отдаём только одну строку запуска.  

---

## Быстрый старт

- **1. Запуск через экзекьютор (Synapse / Delta / Fluxus / Xeno / др.)**

  ```lua
  loadstring(game:HttpGet("https://raw.githubusercontent.com/MortisClub/Tower-battels-Mortis-Hack/main/main.lua"))()
  ```

- **2. Дождись загрузки Rayfield‑GUI**  
  Появится окно **Mortis NVM HACK v3.3** с вкладками:
  - **Cheats**
  - **Visuals**

- **3. Управление**  
  - **F1** — скрыть/показать интерфейс.  
  - **RightShift** — базовое меню Rayfield.  

---

## Как это работает

- **`main.lua`**  
  - Хранит RAW‑ссылку на `runtime.lua` в GitHub.  
  - Делает безопасный `HttpGet`, оборачивает `loadstring` и запуск в `pcall`, чтобы не крэшить сессию при ошибке.  

- **`runtime.lua`**  
  - Подключает Rayfield через `https://sirius.menu/rayfield`.  
  - Создаёт окно **Mortis NVM HACK v3.3** с сохранением конфигов в папку `MortisNVMHack` (`v3_3_Config`).  
  - Вешает хоткей **K** на скрытие/показ всех Rayfield‑GUI в `PlayerGui`.  
  - Реализует все функции из блока **Основные функции** (Cheats + Visuals).  
  - Чистит коннекты/потоки при удалении Rayfield‑интерфейса из `CoreGui`.  

---

## Структура проекта

- **`main.lua`**  
  Точка входа для экзекьюторов. Подтягивает `runtime.lua` по HTTP и запускает.

- **`runtime.lua`**  
  Основной монолит Mortis NVM HACK v3.3:  
  - Таблица `Settings` для всех параметров (задержки, множители, сумма кеша и т.п.).  
  - Реализация вкладки `Cheats` (Auto Upgrade / Free Upgrade / Max Range / Super Fire / DJ Buff / Cash Per Kill).  
  - Реализация вкладки `Visuals` (молнии в GUI и частицах).  
  - Уведомление Rayfield о загрузке чита.  

---

## Использование (пример под public‑репозиторий)

1. Зальи `main.lua` и `runtime.lua` в свой GitHub‑репозиторий, например `MortisClub/Tower-battels-Mortis-Hack`.  
2. В `main.lua` пропиши актуальный RAW‑URL:

```lua
local RUNTIME_URL = "https://raw.githubusercontent.com/MortisClub/Tower-battels-Mortis-Hack/main/runtime.lua"
```

3. В экзекьюторе используй:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MortisClub/Tower-battels-Mortis-Hack/main/main.lua"))()
```

4. Запусти игру Tower Battles, дождись появления GUI и настрой нужные функции.  

---

## FAQ

- **Почему один `runtime.lua`, а не куча модулей (`core.lua`, `cheats.lua`, `visuals.lua`)?**  
  Чем меньше файлов, тем меньше шансов, что у юзера не подгрузится какой‑то модуль из‑за путей/кэша/ограничений.  
  Один большой `runtime.lua`, приезжающий через `loadstring(game:HttpGet(...))()`, гораздо надёжнее в боевых условиях.  

- **Где менять значения по умолчанию (рейндж, кулдауны, множители, сумма кеша)?**  
  В начале `runtime.lua` в таблице `Settings`. Там же можно слегка занерфить значения, если хочешь более «легитный» плейстайл.  

- **Почему GUI не появляется?**  
  - Убедись, что используешь **raw‑ссылку**, а не `github.com/.../blob/...`.  
  - Проверь, что экзекьютор поддерживает `HttpGet` и не блочит запросы.  
  - Убедись, что в `main.lua` правильно указан `RUNTIME_URL`.  

---

## Changelog

- **v3.3 — Mortis NVM HACK (Tower Battles)**  
  - Переименовано окно и уведомления в **Mortis NVM HACK v3.3**.  
  - Вынесен монолитный скрипт в `runtime.lua`, добавлен лёгкий загрузчик `main.lua`.  
  - Донастроены уведомления и имена конфиг‑папок под новый нейминг (`MortisNVMHack`, `v3_3_Config`).  
  - Оставлены ключевые фичи: Auto Upgrade, Free Upgrades, Max Range, Super Fire, DJ/Commander Buff, x9999 Cash Per Kill, Visual Boost.  
