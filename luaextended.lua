-- ============================================================
-- ============================================================
-- 
-- 
--                   УТИЛИТНЫЙ LUA-МОДУЛЬ,
-- 
--               написанный специально для игры
--             Ex Machina / Hard Truck Apocalypse
--
--                     LuaExtended v2.0
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
--    /* Строки */
--    [F] tuple   string.match( string, string pattern, int position )  /* Ищет вхождение шаблона в строку, возвращает захваченные значения. Поддерживает регулярные выражения */
--    [F] string  string.strip( string )   /* Убирает пробелы в начале и конце строки */
--    [F] table   string.split( string, string divider )   /* Разделяет строку по желаемому разделителю, " " - если divider = nil. Возвращает список с строками */
--    [F] int     string.int( string )     /* Возвращает все цифры из строки как одно число int */
--    [F] string  string.shield( string, bool Reverse )    /* Ставит или убирает экранирование спецсимволов в строке. Примеры: [string.shield("Текст?.+-%")] --> "Текст%?%.%+%-%%"; [string.shield("Текст%?%.%+%-%%", true)] --> "Текст?.+-%" */
--    [F] table   string.totable( string Table )  /* Преобразует строку-таблицу в таблицу */
--
--    /* Таблицы */
--    [F] string  table.debug( table )      /* Возвращает строку "распакованной" таблицы. Разворачивает все вложения, очень удобно для отладки таблицы в LOG() */
--    [F] table   table.copy( table )       /* Возвращает копию таблицы. В lua присвоение таблицы новой переменной НЕ РАВНО созданию копии этой таблицы: [local t = {}; local t2 = t	--> t и t2 одна и та же таблица, просто это разные ссылки на нее]; [local t = {}; local t2 = table_copy(t)	--> t и t2 разные таблицы] */
--    [F] bool    table.equal( table t1, table t2 )   /* Проверяет, являются ли таблицы одинаковыми (поверхностно) */
--    [F] bool    table.empty( table )      /* Проверяет, является ли таблица пустой */
--    [F] string  table.tostring( table )   /* Преобразует таблицу в строку */
--    [F] bool    table.containsvalue( table, any value )   /* Проверяет, содержит ли таблица значение (поверхностно) */
--    [F] bool    table.containskey( table, string key )    /* Проверяет, содержит ли таблица ключ (поверхностно) */
--    [F] int     table.amount( table, any item )    /* Считает количество значений в таблице (поверхностно) */
--
--
--    Class LuaE
--    {
--        /* Таймеры */
--        [M] void script_pause( string CoroutineName, function Callback, int Delay )    /* Создает корутину CoroutineName к которой можно обратиться в любом месте через [script_resume]. Если при обращении к корутине реальное время Delay (секунды) вышло, будет вызвана функция Callback: без скобочек "()", просто имя функции, либо целиком тело функции */
--        [M] AIParam script_resume( string CoroutineName )    /* Обращается к корутине CoroutineName, созданной в [script_pause] */
--
--        /* Обертка безопасности */
--        Class try
--        {
--            [M] AIParam try( function or string script ) : public LuaE    /* Безопасно выполняет функцию или строку с кодом, не вызывая ошибок игры. Возвращает статус и ошибку */
--            {
--                [M] AIParam value( any value )    /* Интерпретирует любое значение как: [.AsInt] - возвращает целое число, [.AsString] - возвращает строку, [.AsFloat] - возвращает число с запятой, [.AsBoolean] - возвращает логическое значение, [.AsRUchars] - возвращает строку с переведенной латиницей на кириллицу, [.AsENchars] - возвращает строку с переведенной кириллицей на латиницу */
--            }
--        }
--
--        /* Файлы */
--        [M] string file_read( string path )     /* Возвращает содержимое файла как строку */
--        [M] table file_lines( string path )     /* Возвращает содержимое файла как список строк */
--        [M] bool file_exists( string path )     /* Проверяет, существует ли файл по этому пути */
--        [M] bool file_open( file descriptor )   /* Проверяет, открыт ли файл в памяти по этому дескриптору */
--    }
-- ]]
--
---------------------------------------------------------------
--
--------------- \/ Примеры использования методов \/ ------------
--
-- lua
-- [[
--     local str = string.strip("  lg1")
--     --> str = "lg1"
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
--      Ссылка на github: https://github.com/ejetaxeblevich
--
---------------------------------------------------------------
--
-- =================== КОММЕНТАРИИ АВТОРА =====================
-- 
-- E Jet: Нужно больше всяких псевдополезностей.
--
-- E Jet: Благодарность за идею конвертирования строка/таблица:
--               Целую Петровича в щечк <3 :3 :* ~*~* ///// >.<
-- 
-- ============================================================
-- ============================================================



-- //////////////////////////// MODULE INIT /////////////////////////////////

local LuaE = {}
LuaE.__index = LuaE
LuaE.version = "v2.0"
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

local t_insert = table.insert
local t_getn = table.getn

local io_open = io.open


LOG("[I] Init Module LuaExtended.lua ...")


LuaE.shield = {
    ["\\"] = "%\\",
    ["\""] = "%\"",
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
            if str_find(str, "%%%%") then
                str = str_gsub(str, "%%%%", "||")
                str = str_gsub(str, "%%", "")
                str = str_gsub(str, "||", "%%")
            else
                str = str_gsub(str, "%%", "")
            end
            return str
        else
            return str_gsub(str, ".", function(char) return LuaE.shield[char] or char end)
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
if not table.equal then
    function table.equal(t1, t2)
        if t_getn(t1) ~= t_getn(t2) then return false end
        for i = 1, t_getn(t1) do
            if t1[i] ~= t2[i] then return false end
        end
        return true
    end
end
if not table.empty then
    function table.empty(tbl)
        return next(tbl) == nil
    end
end
if not table.tostring then
    function table.tostring(tbl)
        local function escape_str(s)
            s = string.gsub(s, '"', "'")
            return "'" .. s .. "'"
        end

        local function serialize(tbl)
            local result = "{"
            if type(tbl)~="table" then
                return "nil"
            end
            for i = 1, getn(tbl) do
                local v = tbl[i]
                local vtype = type(v)
                if vtype == "table" then
                    result = result .. serialize(v)
                elseif vtype == "number" then
                    result = result .. v
                elseif vtype == "string" then
                    result = result .. escape_str(v)
                else
                    --result = '{"idi nahui eto ne massiff)))0)"}'
                    result = result .. tostring(v)
                end
                if i < getn(tbl) then
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
if not table.containsvalue then
    function table.containsvalue(tbl, value)
        for _, v in ipairs(tbl) do
            if v == value then
                return true
            end
        end
        return false
    end
end
if not table.containskey then
    function table.containskey(tbl, key)
        for k, _ in pairs(tbl) do
            if k == key then
                return true
            end
        end
        return false
    end
end
if not table.amount then
    function table.amount(tbl, item)
        local skoka = 0
        for _, v in ipairs(tbl) do
            if v == item then
                skoka = skoka+1
            end
        end
        return skoka
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