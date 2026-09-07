-- ============================================================
-- ============================================================
-- 
-- 
--                   УТИЛИТНЫЙ LUA-МОДУЛЬ,
-- 
--               написанный специально для игры
--             Ex Machina / Hard Truck Apocalypse
--
--                     LuaExtended v2.4
-- 
-- 
-- ===================== Автор E Jet ==========================
-- ============================================================
-- 
--     Note: Please translate this text, if it nessesary.
-- 
-- 
-- ======================= ЧТО ЭТО ============================
--
--
--      Этот lua-модуль является сборником полезных и не очень
-- небольших функций под любую вашу задачу:
--      - Расширения string;
--      - Расширения table;
--      - Coroutine-таймер;
--      - Python-like функция try;
--      - Простые взаимодействия file.
--
--      Версии модуля v2.x пробрасывают свои функции в выше-
-- указанные глобальные таблицы и используются на ряду с другими
-- из игры!
--
------------------------- Дисклеймер -----------------------
--
--      АВТОР ЭТОГО ТВОРЕНИЯ ДУМАЕТ, ЧТО ЗНАЕТ, КАК ПРАВИЛЬНО
-- НАЗЫВАТЬ И ИСПОЛЬЗОВАТЬ ВЕЩИ В ПРОГРАММИРОВАНИИ, ПОЭТОМУ 
-- ПРОСЬБА ДЛЯ ПРОГРАММИСТОВ ЗДОРОВОГО ЧЕЛОВЕКА - ПОНЯТЬ И 
-- ПРОСТИТЬ, ЕСЛИ ЗДЕСЬ ЧТО-ТО(ВСЕ) НЕ ТАК. 
--      АВТОР ПОНИМАЕТ И ПРИНИМАЕТ, ЧТО ВЕСЬ КОД НИЖЕ И ЭТОТ
-- ТЕКСТ НАПИСАН ПЛОХО, НЕПОНЯТНО И ГРОМОЗДКО, ЧТО ДАЖЕ В ЭТОМ
-- ЗАНЯТИИ НЕТ НИ МАЛЕЙШЕГО СМЫСЛА - КАК И СМЫСЛА В ЭТОМ КАПСОМ 
-- НАПИСАННОМ ДИСКЛЕЙМЕРЕ.
--
--      LUA-МОДУЛЬ РАСПРОСТРАНЯЕТСЯ СВОБОДНО "КАК ЕСТЬ" И 
-- ИСПОЛЬЗУЕТСЯ ИГРОЙ EX MACHINA / HARD TRUCK APOCALYPSE И МОЖЕТ 
-- БЫТЬ ИЗМЕНЕН ЛЮБЫМ ДРУГИМ ПОЛЬЗОВАТЕЛЕМ (МОДДЕРОМ) ВНУТРИ СВОИХ 
-- МОДИФИКАЦИЙ И ПРОЧИХ РЕСУРСАХ.
--      АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА КАКИЕ-ЛИБО ПОСЛЕДСТВИЯ, 
-- ПОВЛЕКШИХ ЗА СОБОЙ УЩЕРБ ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ЭТОГО, А
-- ТАКЖЕ ЛЮБОЙ ДРУГОЙ, В Т.Ч. ИЗМЕНЕННОЙ ВЕРСИИ LUA-МОДУЛЯ ИЛИ
-- ЧАСТЕЙ КОДА, ПОЗАИМСТВОВАННЫХ (ПЕРЕПИСАННЫХ) ИЗ ЭТОГО ФАЙЛА.
-- 
---------------------------------------------------------------
--
-- ============================================================
--
-- ================= КАК ЭТО ИСПОЛЬЗОВАТЬ =====================
-- 
-- 
--      Для полноценного lua-модуля этой поделке еще далеко, 
-- поэтому ее не нужно устанавливать как lua-библиотеку в системе.
-- 
--      В игру этот lua-модуль загружается двумя способами: через 
-- [require()] или [dofile()]. Это внутренние lua-команды игры. 
-- Наш знакомый [EXECUTE_SCRIPT] не подойдет, так как он не возвращает 
-- объект модуля.
--      Чем отличается [require()] от [dofile()]? 
--      - [require()] загружает файл в игру при первом выполнении
-- и держит в памяти игры до перезапуска. Эта команда используется 
-- для подгрузки модулей здорового человека, которые устанавливаются 
-- в систему (но необязательно);
--      - [dofile()] загружает в память игры файл столько раз, 
-- сколько был вызван. Очищается весь внутренний кеш lua-модуля и
-- принимаются настройки по умолчанию. Рекомендуется для отладки и
-- прочего дебага.
--      Рекомендую прописывать команду в конец файла server.lua
-- игры, поскольку могут использоваться в модуле команды, которые 
-- грузятся в игру чуть раньше сервера ("могут"? автор альцгеймер!).
--
--      В качестве аргумента функции указывается локальный путь до 
-- файла модуля.
--      Возвращаемая таблица помещается в глобальную переменную, 
-- которая будет использована как объект, на который будут 
-- применяться методы (функции) этого модуля через двоеточие. 
--
-- Чтобы было понятнее, вспомним как мы обращаемся к машине игрока:
-- 
-- lua
-- [[
--      local Plv = GetPlayerVehicle()
--      if Plv then
--          Plv:SetSkin(1)  --> метод на объект
--      end
-- ]]
--
-- Или к обжект контейнеру:
--
-- lua
-- [[
--      local Gde = CVector(1,2,3)
--      local Gde.y = g_ObjCont:GetHeight(Gde.x, Gde.z)  --> метод на объект
-- ]]
-- 
--      После загрузки модуля в игру уже можно начинать пользоваться его
-- методами и глобальныим командами.
--
-----------------------------------------------------------------
--
----------------- \/ Пример кода загрузки \/ --------------------
--
-- lua
-- [[
--     LuaE = require("data\\gamedata\\lua_lib\\luaextended.lua")
--     if not LuaE then
--         LOG("[E] Could not find global luaextended.lua...")
--     end
-- ]]
--
---------------------------------------------------------------
--
-- ================= ТЕХНИКА БЕЗОПАСНОСТИ =====================
--
--
--      ЗАПРЕЩАЕТСЯ использовать этот lua-модуль в своих модах
-- без указания авторства.
--      А то натравлю порчу и наколдую недельный понос >:(
--      Шутка :*
--
---------------------------------------------------------------
--
-- =================== ФУНКЦИИ И МЕТОДЫ =======================
--
--
--      Здесь собраны все публичнные функции этого модуля. У 
-- каждой функции имеется детальное описание, что она делает и
-- что в ней указывать.
--
--      Обратите внимание, что дочерний класс должен вызывать 
-- главный метод своего родительского класса вплоть до LuaE.
--
---------------------------------------------------------------
--
-- c
-- [[
--   /* Строки */
--   [F] tuple   string.match( string, string pattern, int position )  /* Ищет вхождение шаблона в строку, возвращает захваченные значения. Поддерживает регулярные выражения */
--   [F] string  string.strip( string )    /* Убирает пробелы в начале и конце строки */
--   [F] table   string.split( string, string divider )   /* Разделяет строку по желаемому разделителю, " " - если divider = nil. Возвращает список с строками */
--   [F] int     string.int( string )      /* Возвращает все цифры из строки как одно число int */
--   [F] string  string.shield( string, bool Reverse )    /* Ставит или убирает экранирование спецсимволов в строке. Примеры: [string.shield("Текст?.+-%")] --> "Текст%?%.%+%-%%"; [string.shield("Текст%?%.%+%-%%", true)] --> "Текст?.+-%" */
--   [F] table   string.totable( string Table )  /* Преобразует строку-таблицу в таблицу */
--   [F] int     string.commas( string )   /* Возвращает количество запятых из строки */
--   [F] string  string.isbinary( string ) /* Возвращает строку байт (форматированную), если строка содержит бинарные значения */
--   [F] string  string.hex( string, string separator )   /* Преобразует строку как hex значения с разделением separator */
--
--
--   /* Таблицы */
--   [F] string   table.debug( table )      /* Возвращает строку "распакованной" таблицы. Разворачивает все вложения, очень удобно для отладки таблицы в LOG() */
--   [F] table    table.copy( table )       /* Возвращает копию таблицы. В lua присвоение таблицы новой переменной НЕ РАВНО созданию копии этой таблицы: [local t = {}; local t2 = t	--> t и t2 одна и та же таблица, просто это разные ссылки на нее]; [local t = {}; local t2 = table.copy(t)	--> t и t2 разные таблицы] */
--   [F] int      table.getn2( table )      /* Возвращает количество элементов таблицы. Поверхностно, для словарей по всем индексам и ключам (стандартный getn считает только списки по индексам) */
--   [F] bool     table.equal( table t1, table t2 )    /* Проверяет, являются ли таблицы одинаковыми. Поверхностно, для списков по числовым индексам */
--   [F] bool     table.equal2( table t1, table t2 )   /* Проверяет, являются ли таблицы одинаковыми. Рекурсивно, для словарей по всем индексам и ключам */
--   [F] bool     table.empty( table )      /* Проверяет, является ли таблица пустой */
--   [F] table    table.clear( table )      /* Очищает существующую таблицу, чтобы не создавать новую. Проходит по числовым индексам таблицы - в таблице не должно быть "дырок": [local t = {[1] = 1, [3] = 3} --> внутри таблицы t нет второго индекса (он уже nil)] = на этой дырке цикл остановится! */
--   [F] table    table.clear2( table )     /* Очищает существующую таблицу, чтобы не создавать новую. Проходит по всем индексам и ключам таблицы, очищая таблицу целиком вне зависимости от наличия "дырок", жертвуя скоростью по сравнению с [table.clear()] */
--   [F] string   table.tostring( table )   /* Преобразует таблицу в строку. Рекурсивно, для списков по числовым индексам */
--   [F] string   table.tostring2( table )  /* Преобразует таблицу в строку. Рекурсивно, для словарей по всем индексам и ключам */
--   [F] string   table.value( table, any value )   /* Проверяет, содержит ли таблица значение. Возвращает его ключ, если есть. Рекурсивно, для словарей по всем индексам и ключам */
--   [F] AIParam  table.key( table, string key )    /* Проверяет, содержит ли таблица ключ. Возвращает его значение, если есть. Рекурсивно, для словарей по всем индексам и ключам */
--   [F] int      table.amount( table, any item )   /* Считает количество значений в таблице. Рекурсивно, для списков по числовым индексам таблицы */
--   [F] intK&intV     table.amount2( table, any item )   /* Считает количество ключей и значений в таблице. Рекурсивно, для словарей по всем индексам и ключам */
--
--
--   Class LuaE
--   {
--       /* Таймеры */
--       [M] void script_pause( string CoroutineName, function Callback, int Delay )    /* Создает корутину CoroutineName к которой можно обратиться в любом месте через [script_resume]. Если при обращении к корутине реальное время Delay (секунды) вышло, будет вызвана функция Callback: без скобочек "()", просто имя функции, либо целиком тело функции */
--       [M] AIParam script_resume( string CoroutineName )    /* Обращается к корутине CoroutineName, созданной в [script_pause] */
--
--       /* Обертка безопасности */
--       Class try
--       {
--           [M] AIParam try( function or string script ) : public LuaE    /* Безопасно выполняет функцию или строку с кодом, не вызывая ошибок игры. Возвращает статус и ошибку */
--           {
--               [M] AIParam value( any value )    /* Интерпретирует любое значение как: [.AsInt] - возвращает целое число, [.AsString] - возвращает строку, [.AsFloat] - возвращает число с запятой, [.AsBoolean] - возвращает логическое значение, [.AsRUchars] - возвращает строку с переведенной латиницей на кириллицу, [.AsENchars] - возвращает строку с переведенной кириллицей на латиницу */
--           }
--       }
--
--       /* Файлы */
--       [M] string  file_read( string path )      /* Возвращает содержимое файла как строку */
--       [M] table   file_lines( string path )     /* Возвращает содержимое файла как список строк */
--       [M] bool    file_exists( string path )    /* Проверяет, существует ли файл по этому пути */
--       [M] bool    file_open( file descriptor )  /* Проверяет, открыт ли файл в памяти по этому дескриптору */
--   }
-- ]]
--
---------------------------------------------------------------
--
--------------- \/ Примеры использования \/ ------------
--
-- lua
-- [[
--     local str = string.strip("  lg1")
--     --> str = "lg1"
--
--     local t = {
--         a = 3, 
--         [67] = "text",
--         ["mega_prikol"] = function() return "huy" end
--     }
--     table.clear2(t)
--     --> t = {}
--
--     local success, retVal = LuaE.try(function() return 1 + 3 end)
--     --> retVal = 4
--     local success, retVal = LuaE.try("local a = 13; println(a)")
--     --> 13
--     --> retVal = nil
--     local success, retVal = LuaE.try(function() local a = {}; return a + 4 end)
--     --> success = false
--     --> retVal = "[string "console_string"]:1: attempt to perform arithmetic on local `a' (a table value)"
--
--     local isValue = LuaE.try:value("-1").AsBoolean
--     --> isValue = false
--     local isValue = LuaE.try:value(627).AsBoolean
--     --> isValue = true
--     local isValue = LuaE.try:value(0).AsBoolean
--     --> isValue = nil
--     local isValue = LuaE.try:value("nil").AsBoolean
--     --> isValue = nil
--
--     local isValue = LuaE.try:value("pisya popa kakashechki").AsRUchars
--     --> isValue = "пися попа какашечки"
--
--     LuaE:script_pause("co_one", function() println("Timer 1 done!") end, 5)
--     LuaE:script_pause("co_two", function() println("Timer 2 done!") end, 10)
--     --Через 5 секунд реального времени:
--     LuaE:script_resume("co_one")
--     --> Timer 1 done!
--     --Еще через 5 секунд реального времени:
--     LuaE:script_resume("co_two")
--     --> Timer 2 done!
-- ]]
--
---------------------------------------------------------------
--
-- ======================= ПОДРОБНЕЕ ==========================
--
--
--      Эту и другую информацию вы сможете найти на github  
-- проекта или найти примеры работы парсера в моде ExplorerMod 
-- от того же автора.
--      Ссылка на github: https://github.com/ejetaxeblevich/LuaExtended
--
---------------------------------------------------------------
--
-- =================== КОММЕНТАРИИ АВТОРА =====================
-- 
-- E Jet: Нужно больше всяких псевдополезностей.
--
-- E Jet: Благодарность за идею конвертирования строка/таблица:
--                       __nEmPoBu4__ 
--               Целую Петровича в щечк <3 :3 :* ~*~* ///// >.<
-- 
-- ============================================================
-- ============================================================



-- //////////////////////////// MODULE INIT /////////////////////////////////

local LuaE = {}
LuaE.__index = LuaE
LuaE.version = "v2.4"
LuaE.try = {}
LuaE.freezed_code = {}
local freeze = LuaE.freezed_code
local try = LuaE.try

local str_rep = string.rep
local str_len = string.len
local str_sub = string.sub
local str_gsub = string.gsub
local str_low = string.lower
local str_find = string.find
local str_format = string.format
local str_byte = string.byte

local t_insert = table.insert
local t_concat = table.concat
local t_getn = table.getn
local t_setn = table.setn
local next = next
local pairs = pairs
local ipairs = ipairs

local io_open = io.open


LOG("[I] Init Module LuaExtended.lua ...")


LuaE.shield = {
    ["\0"] = "%0",
    ["\\"] = "%\\",
    ["\""] = "%\"",

    ["\t"] = "%\t",
    ["\n"] = "%\n",
    ["\r"] = "%\r",

    ["'"] = "%'",

    ["["] = "%[",
    ["]"] = "%]",
    ["("] = "%(",
    [")"] = "%)",

    ["."] = "%.",
    ["^"] = "%^",
    ["$"] = "%$",
    ["*"] = "%*",
    ["+"] = "%+",
    ["-"] = "%-",
    ["?"] = "%?",
    ["%"] = "%%"
}
local shield = LuaE.shield

LuaE.unshield = {
    ["%0"] = "\0",
    ["%\\"] = "\\",
    ["%\""] = "\"",

    ["%\t"] = "\t",
    ["%\n"] = "\n",
    ["%\r"] = "\r",

    ["%'"] = "'",

    ["%["] = "[",
    ["%]"] = "]",
    ["%("] = "(",
    ["%)"] = ")",
    
    ["%."] = ".",
    ["%^"] = "^",
    ["%$"] = "$",
    ["%*"] = "*",
    ["%+"] = "+",
    ["%-"] = "-",
    ["%?"] = "?",
    ["%%"] = "%"
}
local unshield = LuaE.unshield

LuaE.hex = {
    [0]   = "00", [1]   = "01", [2]   = "02", [3]   = "03",
    [4]   = "04", [5]   = "05", [6]   = "06", [7]   = "07",
    [8]   = "08", [9]   = "09", [10]  = "0A", [11]  = "0B",
    [12]  = "0C", [13]  = "0D", [14]  = "0E", [15]  = "0F",
    [16]  = "10", [17]  = "11", [18]  = "12", [19]  = "13",
    [20]  = "14", [21]  = "15", [22]  = "16", [23]  = "17",
    [24]  = "18", [25]  = "19", [26]  = "1A", [27]  = "1B",
    [28]  = "1C", [29]  = "1D", [30]  = "1E", [31]  = "1F",
    [32]  = "20", [33]  = "21", [34]  = "22", [35]  = "23",
    [36]  = "24", [37]  = "25", [38]  = "26", [39]  = "27",
    [40]  = "28", [41]  = "29", [42]  = "2A", [43]  = "2B",
    [44]  = "2C", [45]  = "2D", [46]  = "2E", [47]  = "2F",
    [48]  = "30", [49]  = "31", [50]  = "32", [51]  = "33",
    [52]  = "34", [53]  = "35", [54]  = "36", [55]  = "37",
    [56]  = "38", [57]  = "39", [58]  = "3A", [59]  = "3B",
    [60]  = "3C", [61]  = "3D", [62]  = "3E", [63]  = "3F",
    [64]  = "40", [65]  = "41", [66]  = "42", [67]  = "43",
    [68]  = "44", [69]  = "45", [70]  = "46", [71]  = "47",
    [72]  = "48", [73]  = "49", [74]  = "4A", [75]  = "4B",
    [76]  = "4C", [77]  = "4D", [78]  = "4E", [79]  = "4F",
    [80]  = "50", [81]  = "51", [82]  = "52", [83]  = "53",
    [84]  = "54", [85]  = "55", [86]  = "56", [87]  = "57",
    [88]  = "58", [89]  = "59", [90]  = "5A", [91]  = "5B",
    [92]  = "5C", [93]  = "5D", [94]  = "5E", [95]  = "5F",
    [96]  = "60", [97]  = "61", [98]  = "62", [99]  = "63",
    [100] = "64", [101] = "65", [102] = "66", [103] = "67",
    [104] = "68", [105] = "69", [106] = "6A", [107] = "6B",
    [108] = "6C", [109] = "6D", [110] = "6E", [111] = "6F",
    [112] = "70", [113] = "71", [114] = "72", [115] = "73",
    [116] = "74", [117] = "75", [118] = "76", [119] = "77",
    [120] = "78", [121] = "79", [122] = "7A", [123] = "7B",
    [124] = "7C", [125] = "7D", [126] = "7E", [127] = "7F",
    [128] = "80", [129] = "81", [130] = "82", [131] = "83",
    [132] = "84", [133] = "85", [134] = "86", [135] = "87",
    [136] = "88", [137] = "89", [138] = "8A", [139] = "8B",
    [140] = "8C", [141] = "8D", [142] = "8E", [143] = "8F",
    [144] = "90", [145] = "91", [146] = "92", [147] = "93",
    [148] = "94", [149] = "95", [150] = "96", [151] = "97",
    [152] = "98", [153] = "99", [154] = "9A", [155] = "9B",
    [156] = "9C", [157] = "9D", [158] = "9E", [159] = "9F",
    [160] = "A0", [161] = "A1", [162] = "A2", [163] = "A3",
    [164] = "A4", [165] = "A5", [166] = "A6", [167] = "A7",
    [168] = "A8", [169] = "A9", [170] = "AA", [171] = "AB",
    [172] = "AC", [173] = "AD", [174] = "AE", [175] = "AF",
    [176] = "B0", [177] = "B1", [178] = "B2", [179] = "B3",
    [180] = "B4", [181] = "B5", [182] = "B6", [183] = "B7",
    [184] = "B8", [185] = "B9", [186] = "BA", [187] = "BB",
    [188] = "BC", [189] = "BD", [190] = "BE", [191] = "BF",
    [192] = "C0", [193] = "C1", [194] = "C2", [195] = "C3",
    [196] = "C4", [197] = "C5", [198] = "C6", [199] = "C7",
    [200] = "C8", [201] = "C9", [202] = "CA", [203] = "CB",
    [204] = "CC", [205] = "CD", [206] = "CE", [207] = "CF",
    [208] = "D0", [209] = "D1", [210] = "D2", [211] = "D3",
    [212] = "D4", [213] = "D5", [214] = "D6", [215] = "D7",
    [216] = "D8", [217] = "D9", [218] = "DA", [219] = "DB",
    [220] = "DC", [221] = "DD", [222] = "DE", [223] = "DF",
    [224] = "E0", [225] = "E1", [226] = "E2", [227] = "E3",
    [228] = "E4", [229] = "E5", [230] = "E6", [231] = "E7",
    [232] = "E8", [233] = "E9", [234] = "EA", [235] = "EB",
    [236] = "EC", [237] = "ED", [238] = "EE", [239] = "EF",
    [240] = "F0", [241] = "F1", [242] = "F2", [243] = "F3",
    [244] = "F4", [245] = "F5", [246] = "F6", [247] = "F7",
    [248] = "F8", [249] = "F9", [250] = "FA", [251] = "FB",
    [252] = "FC", [253] = "FD", [254] = "FE", [255] = "FF"
}
local hex = LuaE.hex


if not string.match then
    function string.match(str, pattern, pos)
        local t = {str_find(str, pattern, pos)}
        if t[1] then
            if t_getn(t) > 2 then
                return unpack(t, 3)
            else
                return str_sub(str, t[1], t[2])
            end
        end
        return nil
    end
end
if not string.strip then
    function string.strip(str)
        return (str_gsub(str, "^%s*(.-)%s*$", "%1"))
    end
end
if not string.split then
    function string.split(str, divider)
        local words = {}
        local word = ""
        local divider = divider or " "
        for i = 1, str_len(str) do
            local char = str_sub(str, i, i)
            if char == divider then
                if word ~= "" then
                    t_insert(words, word)
                    word = ""
                end
            else
                word = word .. char
            end
        end
        if word ~= "" then
            t_insert(words, word)
        end
        return words
    end
end
if not string.int then
    function string.int(str)
        local retVal = ""
        str_gsub(str, "%d+", function(e) retVal = retVal .. e end)
        return tonumber(retVal)
    end
end
if not string.shield then
    function string.shield(str, boolReverse)
        if boolReverse then
            return str_gsub(str, "%%(.)", function(c) return unshield[c] or c end)
        else
            return str_gsub(str, ".", function(c) return shield[c] or c end)
        end
    end
end
if not string.totable then
    function string.totable(str)
        if not str_find(str, "{") then 
            str = "{}" 
        end
        local t = dostring("local t = "..str.."; return t")
        return t
    end
end
if not string.commas then
    function string.commas(str)
        local _, commas = str_gsub(str, ",", ",")
        return commas or 0
    end
end
if not string.isbinary then
    function string.isbinary(str)
        if str_find(str, "[%z\1-\8\11\12\14-\31]") then
            return "<binary:" .. str_len(str) .. " bytes>" --true
        end
        return false
    end
end
if not string.hex then
    function string.hex(str, separator)
        local length = str_len(str)
        local result = {}
        local n = 1
        for i = 1, length do
            if separator and i > 1 then
                result[n] = separator
                n = n + 1
            end
            result[n] = hex[str_byte(str, i)]
            n = n + 1
        end
        return t_concat(result)
    end
end


if not table.debug then
    function table.debug(tbl, indent)
        if type(tbl)~="table" then 
            return ""..tostring(tbl) 
        end
        indent = indent or 0
        local result = ""
        for key, value in pairs(tbl) do
            if type(value) == "table" then
                result = result .. str_rep(" ", indent) .. key .. " = {\n" .. table.debug(value, indent + 4) .. str_rep(" ", indent) .. "}\n"
            else
                result = result .. str_rep(" ", indent) .. key .. " = \"" .. tostring(value) .. "\"\n"
            end
        end
        return result
    end
end
if not table.copy then
    function table.copy(orig)
        local orig_type = type(orig)
        local copy
        if orig_type == 'table' then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                copy[table.copy(orig_key)] = table.copy(orig_value)
            end
            setmetatable(copy, table.copy(getmetatable(orig)))
        else
            copy = orig
        end
        return copy
    end
end
if not table.getn2 then
    function table.getn2(tbl)
        local n = 0 
        for k in pairs(tbl) do 
            n = n + 1 
        end 
        return n
    end
end
if not table.equal then
    function table.equal(t1, t2)
        if t_getn(t1) ~= t_getn(t2) then return false end
        for i = 1, t_getn(t1) do
            if t1[i] ~= t2[i] then 
                return false 
            end
        end
        return true
    end
end
if not table.equal2 then
    function table.equal2(t1, t2)
        if t1 == t2 then return true end 
        if type(t1) ~= type(t2) then return false end 
        if type(t1) ~= "table" then return t1 == t2 end 
        for k, v1 in pairs(t1) do 
            local v2 = t2[k] 
            if type(v1) == "table" then 
                if type(v2) ~= "table" then 
                    return false 
                end 
                if not table.equal2(v1, v2) then 
                    return false 
                end 
            elseif v1 ~= v2 then 
                return false 
            end 
        end 
        for k, v2 in pairs(t2) do 
            if t1[k] == nil then 
                return false 
            end 
        end 
        return true
    end
end
if not table.empty then
    function table.empty(tbl)
        return next(tbl) == nil
    end
end
if not table.clear then
    function table.clear(tbl)
        local n = t_getn(tbl)
        for i = 1, n do
            tbl[i] = nil
        end
        t_setn(tbl, 0)
        return tbl
    end
end
if not table.clear2 then
    function table.clear2(tbl)
        for k in pairs(tbl) do
            tbl[k] = nil
        end
        t_setn(tbl, 0)
        return tbl
    end
end

local function escape_str(s)
    local bin = string.isbinary(s)
    if bin then
        return "'" .. bin .. "'"
    end

    s = str_gsub(s, '"', "'")
    return "'" .. s .. "'"
end
if not table.tostring then
    function table.tostring(tbl)
        local seen = {}

        local function serialize(tbl)
            if type(tbl)~="table" then
                --'{"idi nahui eto ne massiff)))0)"}'
                return "nil" 
            end
            if seen[tbl] then
                return "'<recursive " .. tostring(tbl) .. ">'"
            end
            seen[tbl] = true

            local result = "{"
            local skoka = t_getn(tbl)
            for i = 1, skoka do
                local v = tbl[i]
                local vtype = type(v)
                if vtype == "table" then
                    result = result .. serialize(v)
                elseif vtype == "string" then
                    result = result .. escape_str(v)
                elseif vtype == "number" then
                    result = result .. v
                elseif vtype == "boolean" then
                    result = result .. tostring(v)
                else
                    result = result .. "'<" .. vtype .. ">'"
                end
                if i < skoka then
                    result = result .. ","
                end
            end

            result = result .. "}"
            if result=="{}" then
                result = "nil"
            end
            return result
        end

        return serialize(tbl)
    end
end
if not table.tostring2 then
    function table.tostring2(tbl)
        local seen = {}

        local function serialize(tbl)
            if type(tbl)~="table" then
                --'{"idi nahui eto ne massiff)))0)"}'
                return "nil" 
            end
            if seen[tbl] then
                return "'<recursive " .. tostring(tbl) .. ">'"
            end
            seen[tbl] = true

            local result = "{"
            local first = true
            for k, v in pairs(tbl) do
                if not first then
                    result = result .. ","
                end
                first = false

                local vtype = type(v)
                local k_str = "['" .. k .. "']="
                if vtype == "table" then
                    result = result .. k_str .. serialize(v)
                elseif vtype == "string" then
                    result = result .. k_str .. escape_str(v)
                elseif vtype == "number" then
                    result = result .. k_str .. v
                elseif vtype == "boolean" then
                    result = result .. k_str .. tostring(v)
                else
                    result = result .. k_str .. "'<" .. vtype .. ">'"
                end
            end

            result = result .. "}"
            if result=="{}" then
                result = "nil"
            end
            return result
        end

        return serialize(tbl)
    end
end

if not table.value then
    function table.value(tbl, value)
        for k, v in pairs(tbl) do 
            if type(v) == "table" then
                local result = table.value(v, value)
                if result then 
                    return result
                end 
            elseif v == value then 
                return k
            end 
        end
    end
end
if not table.key then
    function table.key(tbl, key)
        for k, v in pairs(tbl) do 
            if type(v) == "table" then 
                local result = table.key(v, key)
                if result then 
                    return result
                end 
            elseif k == key then 
                return v
            end 
        end
    end
end
if not table.amount then
    function table.amount(tbl, item)
        local amount = 0
        for i, v in ipairs(tbl) do
            if type(v) == "table" then
                amount = amount + table.amount(v, item)
            elseif v == item then
                amount = amount + 1
            end
        end
        return amount
    end
end
if not table.amount2 then
    function table.amount2(tbl, item)
        local keys, values = 0, 0

        local function serialize(tbl)
            for k, v in pairs(tbl) do 
                if type(v) == "table" and v ~= item then 
                    keys, values = serialize(v)
                end
                if k == item then
                    keys = keys + 1
                end
                if v == item then
                    values = values + 1
                end
            end
            return keys, values
        end

        return serialize(tbl)
    end
end


function LuaE:file_read(path)
    local data
    local f = io_open(path or "", 'r')
    if f then
        data = f:read("*all")
        f:close()
    end
    return data
end
function LuaE:file_lines(path)
    local file = io_open(path or "", "r")
	if file then
        local content = {}
		local i = 1
		for line in file:lines() do
			content[i] = line
			i=i+1
		end
        file:close()
        return content
    end
end
function LuaE:file_exists(path)
    local b = false
	local f = io_open(path or "", 'r')
	if f then
		b = true
		f:close()
	end
    return b
end
function LuaE:file_open(f)
    if type(f) ~= "userdata" then
        return false
    end

    local ok, err = pcall(function() return f:seek() end)
    return ok
end


function LuaE:script_pause(stringCoroutineName, functionCallback, intDelay)  
	local stringCoroutineName = stringCoroutineName or "co_one"
    local start = os.time()  
    freeze[stringCoroutineName] = coroutine.create(function()  
        while os.time() - start < intDelay do  
            coroutine.yield()  
        end
		local s, e = pcall(functionCallback)
        if not s then
			LOG("[E] Module LuaExtended.lua === script_pause(): "..tostring(e))
		end
    end)
end
function LuaE:script_resume(stringCoroutineName)  
	local stringCoroutineName = stringCoroutineName or "co_one"
	local co_status = coroutine.status(freeze[stringCoroutineName])
	if co_status=="suspended" then
		return coroutine.resume(freeze[stringCoroutineName])
	end
	return co_status 
end




--XMLParser
local function TranslateRUCharsToENChars(text)
    local translitTable = {
        ['а'] = 'a',  ['б'] = 'b',   ['в'] = 'v',  ['г'] = 'g',  ['д'] = 'd',
        ['е'] = 'e',  ['ё'] = 'yo',  ['ж'] = 'zh', ['з'] = 'z',  ['и'] = 'i',
        ['й'] = 'y',  ['к'] = 'k',   ['л'] = 'l',  ['м'] = 'm',  ['н'] = 'n',
        ['о'] = 'o',  ['п'] = 'p',   ['р'] = 'r',  ['с'] = 's',  ['т'] = 't',
        ['у'] = 'u',  ['ф'] = 'f',   ['х'] = 'h',  ['ц'] = 'ts', ['ч'] = 'ch',
        ['ш'] = 'sh', ['щ'] = 'sch', ['ъ'] = '',   ['ы'] = 'y',  ['ь'] = '',
        ['э'] = 'e',  ['ю'] = 'yu',  ['я'] = 'ya',

        ['А'] = 'A',  ['Б'] = 'B',   ['В'] = 'V',  ['Г'] = 'G',  ['Д'] = 'D',
        ['Е'] = 'E',  ['Ё'] = 'Yo',  ['Ж'] = 'Zh', ['З'] = 'Z',  ['И'] = 'I',
        ['Й'] = 'Y',  ['К'] = 'K',   ['Л'] = 'L',  ['М'] = 'M',  ['Н'] = 'N',
        ['О'] = 'O',  ['П'] = 'P',   ['Р'] = 'R',  ['С'] = 'S',  ['Т'] = 'T',
        ['У'] = 'U',  ['Ф'] = 'F',   ['Х'] = 'H',  ['Ц'] = 'Ts', ['Ч'] = 'Ch',
        ['Ш'] = 'Sh', ['Щ'] = 'Sch', ['Ъ'] = '',   ['Ы'] = 'Y',  ['Ь'] = '',
        ['Э'] = 'E',  ['Ю'] = 'Yu',  ['Я'] = 'Ya'
    }
    return str_gsub(text, ".", function(char) return translitTable[char] or char end)
end
local function TranslateENCharsToRUChars(text)
    local translitTable = {
        ['a']  = 'а', ['b']   = 'б', ['v']  = 'в', ['g']  = 'г',  ['d']  = 'д',
        ['e']  = 'е', ['yo']  = 'ё', ['zh'] = 'ж', ['z']  = 'з',  ['i']  = 'и',
        ['y']  = 'й', ['k']   = 'к', ['l']  = 'л', ['m']  = 'м',  ['n']  = 'н',
        ['o']  = 'о', ['p']   = 'п', ['r']  = 'р', ['s']  = 'с',  ['t']  = 'т',
        ['u']  = 'у', ['f']   = 'ф', ['h']  = 'х', ['ts'] = 'ц',  ['ch'] = 'ч',
        ['sh'] = 'ш', ['sch'] = 'щ', ['']   = 'ъ', ['yu']  = 'ю', ['ya'] = 'я',

        ['A']  = 'А', ['B']   = 'Б', ['V']  = 'В', ['G']  = 'Г',  ['D']  = 'Д',
        ['E']  = 'Е', ['Yo']  = 'Ё', ['Zh'] = 'Ж', ['Z']  = 'З',  ['I']  = 'И',
        ['Y']  = 'Й', ['K']   = 'К', ['L']  = 'Л', ['M']  = 'М',  ['N']  = 'Н',
        ['O']  = 'О', ['P']   = 'П', ['R']  = 'Р', ['S']  = 'С',  ['T']  = 'Т',
        ['U']  = 'У', ['F']   = 'Ф', ['H']  = 'Х', ['Ts'] = 'Ц',  ['Ch'] = 'Ч',
        ['Sh'] = 'Ш', ['Sch'] = 'Щ', ['']   = 'Ъ', ['Yu']  = 'Ю', ['Ya'] = 'Я'
    }
    local result = ''
    local i = 1
    while i <= str_len(text) do
        local twoChar = str_sub(text, i, i + 1)
        if translitTable[twoChar] then
            result = result .. translitTable[twoChar]
            i = i + 2
        else
            local oneChar = str_sub(text, i, i)
            if translitTable[oneChar] then
                result = result .. translitTable[oneChar]
            else
                result = result .. oneChar
            end
            i = i + 1
        end
    end
    return result
end
local function _INTERPRETATION(Value)
    local interpreters = {
        AsBoolean = function()
            if not Value then return nil end
            if type(Value)=="userdata" then return true end
            if tostring(Value)=="" or tostring(Value)=="nil" or (tonumber(Value) or 1)==0 then return nil end
            if tostring(Value)=="true" or (tonumber(Value) or -1)>0 then return true end
            if tostring(Value)=="false" or 0>(tonumber(Value) or 1) then return false end
            return true
        end,
        AsString = function()
            if not Value then Value = "nil" end
            local v = tostring(Value)
            if v then return v end
            return Value
        end,
        AsInt = function()
            if not Value then Value = 0 end
            local v = math.floor(tonumber(Value) or 0)
            if v then return v end
            return Value
        end,
        AsFloat = function()
            if not Value then Value = 0 end
            local v = tonumber(Value) or 0
            if v then return v end
            return Value
        end,
        AsENchars = function()
            if not Value then Value = "nil" end
            local v = tostring(Value)
            if v then v = TranslateRUCharsToENChars(v) end
            if v then return v end
            return Value
        end,
        AsRUchars = function()
            if not Value then Value = "nil" end
            local v = tostring(Value)
            if v then v = TranslateENCharsToRUChars(v) end
            if v then return v end
            return Value
        end
    }
    
    local metatable = setmetatable({}, {
        __index = function(_, key)
            local interpreter = interpreters[key]
            if interpreter then
                return interpreter()
            else
                return Value
            end
        end,
        __call = function()
            return Value
        end,
        __tostring = function()
            return tostring(Value)
        end
    })

    return metatable
end

function try:value(value)
	return _INTERPRETATION(value)
end
setmetatable(try, {
        __call = function(_, ...)
			for _, v in ipairs(arg) do
				if type(v)=="string" then
					v = dostring("local f = function()\n "..v.."\n end; return f")
				end
				local s, e = pcall(v)
            	return s, e
			end
			return "huy"
        end
    })


-- /////////////////////////// RETURN MODULE ////////////////////////////////

LOG("[I] Module LuaExtended.lua "..LuaE.version.." successfully loaded.")

return LuaE