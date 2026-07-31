<a id="top"></a>

<div align="center">

# LuaExtended.lua

***УТИЛИТНЫЙ LUA-МОДУЛЬ,*** *написанный специально для игры [Ex Machina](https://store.steampowered.com/app/285500/Hard_Truck_Apocalypse__Ex_Machina/)*


***UTILITY LUA-MODULE,*** *written specifically for the game [Hard Truck Apocalypse](https://store.steampowered.com/app/285500/Hard_Truck_Apocalypse__Ex_Machina/)*

**Lua 5.0**

<img src="exm_luaextended_logo.png" alt="exm_luaextended_logo_png" width="250" />

***

<table>
  <thead>
    <tr>
      <th style="text-align: center;">Содержание</th>
      <th style="text-align: center;">Table of contents (machine translation)</th>
    </tr>
  </thead>
  <tbody align="center">
    <tr>
      <td><a href="#wtf_ru">Краткое описание</a></td>
      <td><a href="#wtf_en">Brief description</a></td>
    </tr>
    <tr>
      <td><a href="#allAboutIt_ru">Все инструкции для моддеров</a></td>
      <td><a href="#allAboutIt_en">All instructions for modders</a></td>
    </tr>
    <tr>
      <td><a href="#allFunctions_ru">Все методы и функции</a></td>
      <td><a href="#allFunctions_en">All methods and functions</a></td>
    </tr>
    <tr>
      <td><a href="#examplesHowToUse_ru">Примеры использования</a></td>
      <td><a href="#examplesHowToUse_en">Usage examples</a></td>
    </tr>
    <tr>
      <td><a href="#detailsAndThanks_ru">Подробности и выражение благодарности</a></td>
      <td><a href="#detailsAndThanks_en">Details and gratitude</a></td>
    </tr>
  </tbody>
</table>

</div>

> [!WARNING]
> Этот ReadMe акутален только для `v2.0` версии LuaExtended и выше!
>
> This ReadMe is relevant only for `v2.0` versions of LuaExtended and above!

***

<a id="wtf_ru"></a>

## ЧТО ЭТО

Этот lua-модуль является сборником полезных ~~и не очень~~ небольших функций под любую вашу задачу.

> Задача lua-модуля - как-то упростить работу участникам сообщества в создании модификаций, если им сложно реализовать что-то самостоятельно.

### ВОЗМОЖНОСТИ
- Расширения `string`;
- Расширения `table`;
- Coroutine-таймер;
- *Python-like* функция `try`;
- Простые взаимодействия `file`.

<a id="allAboutIt_ru"></a><a href="#top">Наверх ↑</a>

### Дисклеймер

АВТОР ЭТОГО ТВОРЕНИЯ ДУМАЕТ, ЧТО ЗНАЕТ, КАК ПРАВИЛЬНО НАЗЫВАТЬ И ИСПОЛЬЗОВАТЬ ВЕЩИ В ПРОГРАММИРОВАНИИ, ПОЭТОМУ ПРОСЬБА ДЛЯ ПРОГРАММИСТОВ ЗДОРОВОГО ЧЕЛОВЕКА - ПОНЯТЬ И ПРОСТИТЬ, ЕСЛИ ЗДЕСЬ ЧТО-ТО(ВСЕ) НЕ ТАК.


АВТОР ПОНИМАЕТ И ПРИНИМАЕТ, ЧТО ВЕСЬ КОД НИЖЕ И ЭТОТ ТЕКСТ НАПИСАН ПЛОХО, НЕПОНЯТНО И ГРОМОЗДКО, ЧТО ДАЖЕ В ЭТОМ ЗАНЯТИИ НЕТ НИ МАЛЕЙШЕГО СМЫСЛА - КАК И СМЫСЛА В ЭТОМ КАПСОМ НАПИСАННОМ ДИСКЛЕЙМЕРЕ.


LUA-МОДУЛЬ РАСПРОСТРАНЯЕТСЯ СВОБОДНО "КАК ЕСТЬ" И ИСПОЛЬЗУЕТСЯ ИГРОЙ EX MACHINA / HARD TRUCK APOCALYPSE И МОЖЕТ БЫТЬ ИЗМЕНЕН ЛЮБЫМ ДРУГИМ ПОЛЬЗОВАТЕЛЕМ (МОДДЕРОМ) ВНУТРИ СВОИХ МОДИФИКАЦИЙ И ПРОЧИХ РЕСУРСАХ.

АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА КАКИЕ-ЛИБО ПОСЛЕДСТВИЯ, ПОВЛЕКШИХ ЗА СОБОЙ УЩЕРБ ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ЭТОГО, А ТАКЖЕ ЛЮБОЙ ДРУГОЙ, В Т.Ч. ИЗМЕНЕННОЙ ВЕРСИИ LUA-МОДУЛЯ ИЛИ ЧАСТЕЙ КОДА, ПОЗАИМСТВОВАННЫХ (ПЕРЕПИСАННЫХ) ИЗ ЭТОГО ФАЙЛА.


## КАК ЭТО ИСПОЛЬЗОВАТЬ

Почему это "модуль" а не любой другой файл с lua скриптами? Хотя он таким и является...
- Потому что этот файл - таблица функций LuaE (далее класс), который имеет свои собственные методы и функции, что очень похоже на серьезную тему. Наверное. Типа. Я хз...

### УСТАНОВКА

Для полноценного lua-модуля этой поделке еще далеко, поэтому ее не нужно устанавливать как библиотеку Lua в системе.

В игру этот lua-модуль загружается двумя способами: через `require()` или `dofile()`. Это внутренние Lua команды игры. 
Наш знакомый `EXECUTE_SCRIPT` не подойдет, так как он не возвращает объект модуля.


Чем отличается `require()` от `dofile()`? 


- `require()` загружает файл в игру при первом выполнении и держит в памяти игры до перезапуска. Эта команда используется для подгрузки модулей здорового человека, которые устанавливаются в систему (но необязательно);
- `dofile()` загружает в память игры файл столько раз, сколько был вызван. Очищается весь внутренний кеш lua-модуля и принимаются настройки по умолчанию. Рекомендуется для отладки и прочего дебага.

Рекомендую прописывать команду в конец файла `server.lua` игры, поскольку могут использоваться в модуле команды, которые грузятся в игру чуть раньше сервера ("могут"? автор альцгеймер!).


В качестве аргумента функции указывается локальный путь до файла модуля.


Возвращаемая таблица помещается в глобальную переменную, которая будет использована как объект, на который будут применяться методы (функции) этого модуля через двоеточие. 

Чтобы было понятнее, вспомним как мы обращаемся к машине игрока: 
```lua
local Plv = GetPlayerVehicle()
if Plv then
    Plv:SetSkin(1)  --> метод на объект
end
```
Или к обжект контейнеру:
```lua
local Gde = CVector(1,2,3)
local Gde.y = g_ObjCont:GetHeight(Gde.x, Gde.z)  --> метод на объект
```

После загрузки модуля в игру уже можно начинать пользоваться его методами и глобальныим командами.

### Пример кода загрузки

```lua
--server.lua
LuaE = require("data\\gamedata\\lua_lib\\luaextended.lua")
if not LuaE then
    LOG("[E] Could not find global luaextended.lua...")
end
```

## ТЕХНИКА БЕЗОПАСНОСТИ

- ***ЗАПРЕЩАЕТСЯ*** использовать этот lua-модуль в своих модах без указания авторства. А то натравлю порчу и наколдую недельный понос 😡 
*Шутка 💋*

<a id="allFunctions_ru"></a><a href="#top">Наверх ↑</a>

## ФУНКЦИИ И МЕТОДЫ

Здесь собраны все публичнные функции этого модуля. У каждой функции имеется детальное описание, что она делает и что в ней указывать. 

> [!IMPORTANT]
> Версии модуля `v2.x` пробрасывают свои функции в глобальные lua-таблицы `table` и `string` и используются на ряду с другими из игры!
> 
> **Обратите внимание**, что дочерний класс должен вызывать главный метод своего родительского класса вплоть до LuaE.

> [!TIP]
> Вы можете скроллить код ниже вправо и влево! Наведите курсор на полотно и колесиком мыши с помощью `shift` двигайте его!

```c
/* Строки */

[F] tuple string.match( string, string pattern, int position )
/* Ищет вхождение шаблона в строку, возвращает захваченные значения.

   Поддерживает регулярные выражения */

[F] string string.strip( string )
/* Убирает пробелы в начале и конце строки */

[F] table string.split( string, string divider )
/* Разделяет строку по желаемому разделителю, " " - если divider = nil.

   Возвращает список с строками */

[F] int string.int( string )
/* Возвращает все цифры из строки как одно число int */

[F] string string.shield( string, bool Reverse )
/* Ставит или убирает экранирование спецсимволов в строке.

   Примеры:
      string.shield("Текст?.+-%")
      --> "Текст%?%.%+%-%%"

      string.shield("Текст%?%.%+%-%%", true)
      --> "Текст?.+-%" */

[F] table string.totable( string Table )
/* Преобразует строку-таблицу в таблицу */

[F] int string.commas( string )
/* Возвращает количество запятых из строки */


/* Таблицы */

[F] string table.debug( table )
/* Возвращает строку "распакованной" таблицы.

   Разворачивает все вложения, очень удобно для просмотра и отладки таблицы в LOG() */

[F] table table.copy( table )
/* Возвращает копию таблицы.

   В lua присвоение таблицы новой переменной НЕ РАВНО созданию копии этой таблицы:
      local t = {}
      local t2 = t	--> t и t2 одна и та же таблица, просто это разные ссылки на нее;

      local t = {}
      local t2 = table.copy(t)	--> t и t2 разные таблицы */

[F] bool table.equal( table t1, table t2 )
/* Проверяет, являются ли таблицы одинаковыми (поверхностно) */

[F] bool table.empty( table )
/* Проверяет, является ли таблица пустой */

[F] table table.clear( table )
/* Очищает существующую таблицу, чтобы не создавать новую.

   Проходит по числовым индексам таблицы
   в таблице не должно быть "дырок":
       local t = {[1] = 1, [3] = 3} --> внутри таблицы t нет второго индекса (он уже nil)
   = на этой дырке цикл остановится! */

[F] table table.clear2( table )
/* Очищает существующую таблицу, чтобы не создавать новую.

   Проходит по всем индексам и ключам таблицы,
   очищая таблицу целиком вне зависимости от наличия "дырок",
   жертвуя скоростью по сравнению с [table.clear()] */

[F] string table.tostring( table )
/* Преобразует таблицу в строку */

[F] bool table.containsvalue( table, any value )
/* Проверяет, содержит ли таблица значение (поверхностно) */

[F] bool table.containskey( table, string key )
/* Проверяет, содержит ли таблица ключ (поверхностно) */

[F] int table.amount( table, any item )
/* Считает количество значений в таблице (поверхностно) */


Class LuaE
{
    /* Таймеры */

    [M] void script_pause( string CoroutineName, function Callback, int Delay )
    /* Создает корутину CoroutineName к которой можно обратиться в любом месте через [script_resume()].

      Если при обращении к корутине реальное время Delay (секунды) вышло,
      будет вызвана функция Callback: без скобочек "()", просто имя функции, либо целиком тело функции */

    [M] AIParam script_resume( string CoroutineName )
    /* Обращается к корутине CoroutineName, созданной в [script_pause()] */


    /* Обертка безопасности, как [try] у Python */
    Class try
    {
        [M] AIParam try( function or string script ) : public LuaE
        /* Безопасно выполняет функцию или строку с кодом, не вызывая ошибок игры.

           Возвращает статус и ошибку */
        {
            [M] AIParam value( any value )
            /* Интерпретирует любое значение как:
               [.AsInt]     - возвращает целое число.
               [.AsString]  - возвращает строку.
               [.AsFloat]   - возвращает число с запятой.
               [.AsBoolean] - возвращает логическое значение.
               [.AsRUchars] - возвращает строку с переведенной латиницей на кириллицу.
               [.AsENchars] - возвращает строку с переведенной кириллицей на латиницу. */
        }
    }

    /* Файлы */

    [M] string file_read( string path )
    /* Возвращает содержимое файла как строку */

    [M] table file_lines( string path )
    /* Возвращает содержимое файла как список строк */

    [M] bool file_exists( string path )
    /* Проверяет, существует ли файл по этому пути */

    [M] bool file_open( file descriptor )
    /* Проверяет, открыт ли файл в памяти по этому дескриптору */
}
```

<a id="examplesHowToUse_ru"></a><a href="#top">Наверх ↑</a>

### Пример использования

```lua
local str = string.strip("  lg1")
--> str = "lg1"

local t = {
    a = 3, 
    [67] = "text",
    ["mega_prikol"] = function() return "huy" end
}
table.clear2(t)
--> t = {}

local success, retVal = LuaE.try(function() return 1 + 3 end)
--> retVal = 4
local success, retVal = LuaE.try("local a = 13; println(a)")
--> 13
--> retVal = nil
local success, retVal = LuaE.try(function() local a = {}; return a + 4 end)
--> success = false
--> retVal = "[string "console_string"]:1: attempt to perform arithmetic on local `a' (a table value)"

local isValue = LuaE.try:value("-1").AsBoolean
--> isValue = false
local isValue = LuaE.try:value(627).AsBoolean
--> isValue = true
local isValue = LuaE.try:value(0).AsBoolean
--> isValue = nil
local isValue = LuaE.try:value("nil").AsBoolean
--> isValue = nil

local isValue = LuaE.try:value("pisya popa kakashechki").AsRUchars
--> isValue = "пися попа какашечки"

LuaE:script_pause("co_one", function() println("Timer 1 done!") end, 5)
LuaE:script_pause("co_two", function() println("Timer 2 done!") end, 10)
--Через 5 секунд реального времени:
LuaE:script_resume("co_one")
--> Timer 1 done!
--Еще через 5 секунд реального времени:
LuaE:script_resume("co_two")
--> Timer 2 done!
```

<a id="detailsAndThanks_ru"></a><a href="#top">Наверх ↑</a>

## ПОДРОБНЕЕ

Эту и другую информацию вы сможете найти в файле проекта или найти примеры работы модуля в моде ExplorerMod от того же автора.


## КОММЕНТАРИИ АВТОРА

    E Jet: Нужно больше всяких псевдополезностей.

Благодарность ***\_\_nEmPoBu4\_\_*** за идею конвертирования строка/таблица!
- Целую Петровича в щечк <3 :3 :* ~*~* ///// >.<

<a href="#top">Наверх ↑</a>

----

----

<a id="wtf_en"></a>

## WHAT IS IT

This lua module is a collection of useful ~~and not so~~ small functions for any of your tasks.

> The task of the lua-module is to somehow simplify the work of community members in creating modifications if it is difficult for them to implement something on their own.

### FEATURES
- `string` extensions;
- `table` extensions;
- Coroutine-timer;
- *Python-like* `try` function;
- Simple `file` interactions.

<a id="allAboutIt_en"></a><a href="#top">Go up ↑</a>

### Disclaimer

THE AUTHOR OF THIS CREATION THINKS HE KNOWS HOW TO PROPERLY NAME AND USE THINGS IN PROGRAMMING, SO A REQUEST FOR HEALTHY PROGRAMMERS IS TO UNDERSTAND AND FORGIVE IF THERE IS SOMETHING (EVERYTHING) HERE NOT LIKE THAT.


THE AUTHOR UNDERSTANDS AND ACCEPTS THAT ALL THE CODE BELOW AND THIS TEXT IS POORLY WRITTEN, INCOMPREHENSIBLE AND CUMBERSOME, THAT EVEN THIS LESSON DOES NOT MAKE THE SLIGHTEST SENSE - AS WELL AS THE MEANING IN THIS CAPSULE DISCLAIMER.


THE LUA MODULE IS FREELY DISTRIBUTED "AS IS" AND IS USED BY THE GAME EX MACHINA / HARD TRUCK APOCALYPSE AND CAN BE MODIFIED BY ANY OTHER USER (MODDER) INSIDE THEIR OWN MODIFICATIONS AND OTHER RESOURCES.

THE AUTHOR IS NOT RESPONSIBLE FOR ANY CONSEQUENCES RESULTING IN DAMAGE DURING THE USE OF THIS, AS WELL AS ANY OTHER, INCLUDING MODIFIED VERSIONS OF THE LUA MODULE OR PARTS OF THE CODE BORROWED (REWRITTEN) FROM THIS FILE.


## HOW TO USE IT

Why is this a "module" and not any other lua script file? Although it is...
- Because this file is an LuaE function table (hereinafter referred to as the class), which has its own methods and functions, which is very similar to a serious topic. Probably. Like. I don't know...

### INSTALLATION

This craft is still far from being a full-fledged lua module, so it does not need to be installed as a Lua library in the system.

This lua module is loaded into the game in two ways: via `require()` or `dofile()`. These are the internal Lua commands of the game. 
Our familiar `EXECUTE_SCRIPT` won't do, as it doesn't return a module object.


What is the difference between `require()` and `dofile()`? 


- `require()` loads the file into the game at the first execution and holds it in the game's memory until restarting. This command is used to load modules of a healthy person, which are installed into the system (but not necessarily);
- `dofile()` loads a file into the game's memory as many times as it was called. The entire internal cache of the lua module is cleared and the default settings are accepted. It is recommended for debugging and other debugging.

I recommend writing the command at the end of the `server.lua` file of the game, since commands that are loaded into the game a little earlier than the server can be used in the module ("can"? the author is Alzheimer's!).


The local path to the module file is specified as the function argument.


The returned table is placed in a global variable, which will be used as an object to which the methods (functions) of this module will be applied separated by a colon. 

To make it clearer, let's recall how we refer to the player's vehicle:
```lua
local Plv = GetPlayerVehicle()
if Plv then
    Plv:SetSkin(1)  --> method per object
end
```
Or object container:
```lua
local Gde = CVector(1,2,3)
local Gde.y = g_ObjCont:GetHeight(Gde.x, Gde.z)  --> method per object
```

After loading the module into the game, you can already start using its methods and global commands.

### Sample load code

```lua
--server.lua
LuaE = require("data\\gamedata\\lua_lib\\luaextended.lua")
if not LuaE then
    LOG("[E] Could not find global luaextended.lua...")
end
```

## SAFETY PRECAUTIONS

- ***FORBIDDEN*** to use this lua module in your mods without attribution. Otherwise, I'll set off a spell and conjure up a week's diarrhea. 
*A joke 💋*

<a id="allFunctions_en"></a><a href="#top">Go up ↑</a>

## FUNCTIONS AND METHODS

All the public functions of this module are collected here. Each function has a detailed description of what it does and what to specify in it.

> [!IMPORTANT]
> The `v2.x` versions of the module transfer their functions to the global lua tables `table` and `string` and are used along with others from the game!
> 
> That a child class must call the main method of its parent class up to LuaE.

> [!TIP]
> You can scroll the code below to the right and left! Hover the cursor over the canvas and use the mouse wheel to move it using `shift`!

```c
/* Strings */

[F] tuple string.match( string, string pattern, int position )
/* Searches for the occurrence of a pattern in a string, returns the captured values.

   Supports regular expressions */

[F] string string.strip( string )
/* Removes spaces at the start and end of a line */

[F] table string.split( string, string divider )
/* Divides the string by the desired separator, " " - if divider = nil.

   Returns a list with lines */

[F] int string.int( string )
/* Returns all digits from a string as a single int number */

[F] string string.shield( string, bool Reverse )
/* Sets or removes the escaping of special characters in the string.

   Examples:
      string.shield("Text?.+-%")
      --> "Text%?%.%+%-%%"

      string.shield("Text%?%.%+%-%%", true)
      --> "Text?.+-%" */

[F] table string.totable( string Table )
/* Converts a string-table to a table */

[F] int string.commas( string )
/* Returns the number of commas from a string */


/* Tables */

[F] string table.debug( table )
/* Returns the string of the "unpacked" table.

   Expands all attachments, very convenient for viewing and debugging tables in LOG() */

[F] table table.copy( table )
/* Returns a copy of the table.

   In lua, assigning a table to a new variable is NOT equal to creating a copy of that table:
      local t = {}
      local t2 = t --> t and t2 are the same table, they are just different links to it;

      local t = {}
      local t2 = table.copy(t) --> t and t2 are different tables */

[F] bool table.equal( table t1, table t2 )
/* Checks if the tables are the same (superficially) */

[F] bool table.empty( table )
/* Checks if the table is empty */

[F] table table.clear( table )
/* Clears an existing table so as not to create a new one.

   Passes through the numeric indexes of the table
   there should be no "holes" in the table:
      local t = {[1] = 1, [3] = 3} --> there is no second index inside table t (it is already nil)
   = the cycle stops at this hole! */

[F] table table.clear2( table )
/* Clears an existing table so as not to create a new one.

   Passes through all indexes and keys of the table,
   clearing the entire table regardless of the presence of "holes",
   sacrificing speed compared to [table.clear()] */

[F] string table.tostring( table )
/* Converts a table to a string */

[F] bool table.containsvalue( table, any value )
/* Checks whether the table contains a value (superficially) */

[F] bool table.containskey( table, string key )
/* Checks whether the table contains a key (superficially) */

[F] int table.amount( table, any item )
/* Counts the number of values in the table (superficially) */


Class LuaE
{
    /* Timers */

    [M] void script_pause( string CoroutineName, function Callback, int Delay )
    /* Creates a CoroutineName that can be accessed anywhere via [script_resume()].

      If the real Delay time (seconds) has expired when accessing the coroutine,
      the Callback function will be called: without the parentheses "()", just the function name, or the entire function body. */

    [M] AIParam script_resume( string CoroutineName )
    /* Accesses the CoroutineName created in [script_pause()] */


    /* Safe wrapper, like Python's [try] */
    Class try
    {
        [M] AIParam try( function or string script ) : public LuaE
        /* Safely executes a function or a line of code without causing game errors.

           Returns the status and error */
        {
            [M] AIParam value( any value )
            /* Interprets any value as:
               [.AsInt]     - returns an integer.
               [.AsString]  - returns a string.
               [.AsFloat]   - returns a number with a comma.
               [.AsBoolean] - returns a boolean value.
               [.AsRUchars] - returns a string with the Latin alphabet translated into Cyrillic.
               [.AsENchars] - returns a string from translated Cyrillic to Latin. */
        }
    }

    /* Files */

    [M] string file_read( string path )
    /* Returns the file contents as a string */

    [M] table file_lines( string path )
    /* Returns the file contents as a list of strings */

    [M] bool file_exists( string path )
    /* Checks if a file exists in this path */

    [M] bool file_open( file descriptor )
    /* Checks whether a file is open in memory using this descriptor */
}
```

<a id="examplesHowToUse_en"></a><a href="#top">Go up ↑</a>

### Examples of usage

```lua
local str = string.strip("  lg1")
--> str = "lg1"

local t = {
    a = 3, 
    [67] = "text",
    ["mega_prikol"] = function() return "huy" end
}
table.clear2(t)
--> t = {}

local success, retVal = LuaE.try(function() return 1 + 3 end)
--> retVal = 4
local success, retVal = LuaE.try("local a = 13; println(a)")
--> 13
--> retVal = nil
local success, retVal = LuaE.try(function() local a = {}; return a + 4 end)
--> success = false
--> retVal = "[string "console_string"]:1: attempt to perform arithmetic on local `a' (a table value)"

local isValue = LuaE.try:value("-1").AsBoolean
--> isValue = false
local isValue = LuaE.try:value(627).AsBoolean
--> isValue = true
local isValue = LuaE.try:value(0).AsBoolean
--> isValue = nil
local isValue = LuaE.try:value("nil").AsBoolean
--> isValue = nil

local isValue = LuaE.try:value("pisya popa kakashechki").AsRUchars
--> isValue = "пися попа какашечки"

LuaE:script_pause("co_one", function() println("Timer 1 done!") end, 5)
LuaE:script_pause("co_two", function() println("Timer 2 done!") end, 10)
--After 5 seconds of real time:
LuaE:script_resume("co_one")
--> Timer 1 done!
--After another 5 seconds of real time:
LuaE:script_resume("co_two")
--> Timer 2 done!
```

<a id="detailsAndThanks_en"></a><a href="#top">Go up ↑</a>

## LEARN MORE

You can find this and other information in the project file or find examples of how the module works in the ExplorerMod mod from the same author.


## AUTHOR'S COMMENTS

    E Jet: We need more pseudo-usefulness.

Thanks ***\_\_nEmPoBu4\_\_*** for the idea of converting string/table!
- Kiss Petrovich on the cheek <3 :3 :* ~*~* ///// >.<

<a href="#top">Go up ↑</a>
