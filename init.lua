--- HumanTyping.spoon
--- Simulate realistic human typing with random delays, typos, and corrections
--- 
--- Download: https://github.com/YOUR_USERNAME/HumanTyping.spoon
--- Version: 1.0.0
--- Author: YOUR_NAME
--- License: MIT - https://opensource.org/licenses/MIT
--- Homepage: https://github.com/YOUR_USERNAME/HumanTyping.spoon
---
--- Configuration:
--- ```lua
--- spoon.HumanTyping.typoChance = 5
--- spoon.HumanTyping.hotkeyStart = {"alt", "p"}
--- spoon.HumanTyping.hotkeyClipboard = {"alt", "shift", "p"}
--- spoon.HumanTyping:start()
--- ```

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "HumanTyping"
obj.version = "1.0.0"
obj.author = "YOUR_NAME"
obj.homepage = "https://github.com/YOUR_USERNAME/HumanTyping.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Configuration (can be customized by user)
obj.typoChance = 3  -- Percentage (0-100)
obj.hotkeyStart = {"alt", "p"}
obj.hotkeyClipboard = {"alt", "shift", "p"}

-- Internal state
obj.isTyping = false
obj.typingTimer = nil
obj.escHotkey = nil

-- Функция остановки печати
function obj:stopTyping()
    self.isTyping = false
    if self.typingTimer then
        self.typingTimer:stop()
        self.typingTimer = nil
    end
    if self.escHotkey then
        self.escHotkey:delete()
        self.escHotkey = nil
    end
    hs.alert.show("Печать остановлена")
end

-- Основная функция набора текста
function obj:startHumanTyping(inputText)
    if self.isTyping or not inputText or inputText == "" then return end

    -- Нормализация переносов строк
    inputText = inputText:gsub("\r\n", "\n"):gsub("\r", "\n")

    -- Разбиение строки на массив символов UTF-8
    local chars = {}
    for _, code in utf8.codes(inputText) do
        table.insert(chars, utf8.char(code))
    end

    local totalChars = #chars
    if totalChars == 0 then return end

    self.isTyping = true

    -- Перехват клавиши Esc на время печати
    self.escHotkey = hs.hotkey.bind({}, "escape", function()
        self:stopTyping()
    end)

    local i = 1
    local self = self

    local function processNextChar()
        if not self.isTyping or i > totalChars then
            self:stopTyping()
            return
        end

        local char = chars[i]
        local code = utf8.codepoint(char)

        -- 1. Перенос строки
        if char == "\n" then
            hs.eventtap.keyStroke({}, "return")
            i = i + 1
            local lineDelay = math.random(500, 1200) / 1000
            self.typingTimer = hs.timer.doAfter(lineDelay, processNextChar)
            return
        end

        -- 2. Когнитивная пауза
        local extraDelay = 0
        if math.random(1, 50) == 1 then
            extraDelay = math.random(400, 1000) / 1000
        end

        -- Заглавные буквы
        local isUpper = (code >= 65 and code <= 90)
                     or (code >= 1040 and code <= 1071)
                     or (code == 1025)
        if isUpper then
            extraDelay = extraDelay + (math.random(60, 140) / 1000)
        end

        local isPunctOrSpace = (char == " " or char == "\t" or 
                                string.find(".,!?-:;\"'()[]{}/*+=@#$%^&_~", char, 1, true) ~= nil)

        -- 3. Симуляция опечатки
        if math.random(1, 100) <= self.typoChance and not isPunctOrSpace then
            local isLatin = (code >= 65 and code <= 90) or (code >= 97 and code <= 122)
            local wrongChar = isLatin and utf8.char(math.random(97, 122)) or utf8.char(math.random(1072, 1103))

            hs.eventtap.keyStrokes(wrongChar)

            local hasNext = (i < totalChars and chars[i+1] ~= "\n")
            if hasNext then
                local nextChar = chars[i+1]
                local inertiaDelay = math.random(30, 80) / 1000

                self.typingTimer = hs.timer.doAfter(inertiaDelay, function()
                    if not self.isTyping then return end
                    hs.eventtap.keyStrokes(nextChar)

                    local realDelay = math.random(180, 350) / 1000
                    self.typingTimer = hs.timer.doAfter(realDelay, function()
                        if not self.isTyping then return end
                        hs.eventtap.keyStroke({}, "delete")

                        self.typingTimer = hs.timer.doAfter(math.random(50, 100)/1000, function()
                            if not self.isTyping then return end
                            hs.eventtap.keyStroke({}, "delete")

                            self.typingTimer = hs.timer.doAfter(math.random(100, 200)/1000, function()
                                if not self.isTyping then return end
                                hs.eventtap.keyStrokes(char)
                                i = i + 1
                                local charDelay = (35 + math.random(20, 100)) / 1000
                                if isPunctOrSpace then charDelay = charDelay + (math.random(100, 280) / 1000) end
                                self.typingTimer = hs.timer.doAfter(charDelay, processNextChar)
                            end)
                        end)
                    end)
                end)
                return
            else
                local realDelay = math.random(150, 300) / 1000
                self.typingTimer = hs.timer.doAfter(realDelay, function()
                    if not self.isTyping then return end
                    hs.eventtap.keyStroke({}, "delete")
                    self.typingTimer = hs.timer.doAfter(math.random(100, 200)/1000, function()
                        if not self.isTyping then return end
                        hs.eventtap.keyStrokes(char)
                        i = i + 1
                        local charDelay = (35 + math.random(20, 100)) / 1000
                        if isPunctOrSpace then charDelay = charDelay + (math.random(100, 280) / 1000) end
                        self.typingTimer = hs.timer.doAfter(charDelay, processNextChar)
                    end)
                end)
                return
            end
        end

        -- 4. Обычный ввод
        local function typeActual()
            hs.eventtap.keyStrokes(char)
            i = i + 1

            local baseDelay = (35 + math.random(20, 100)) / 1000
            if isPunctOrSpace then
                baseDelay = baseDelay + (math.random(100, 280) / 1000)
            end

            self.typingTimer = hs.timer.doAfter(baseDelay, processNextChar)
        end

        if extraDelay > 0 then
            self.typingTimer = hs.timer.doAfter(extraDelay, function()
                if not self.isTyping then return end
                typeActual()
            end)
        else
            typeActual()
        end
    end

    processNextChar()
end

-- GUI окно ввода
function obj:showInputGUI()
    local frame = hs.screen.mainScreen():fullFrame()
    
    local html = [[
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body {
                    margin: 0;
                    padding: 20px;
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
                    background: #1e1e1e;
                    color: #ffffff;
                }
                textarea {
                    width: 100%;
                    height: calc(100vh - 100px);
                    padding: 15px;
                    font-size: 16px;
                    border: 2px solid #444;
                    border-radius: 8px;
                    background: #2d2d2d;
                    color: #ffffff;
                    resize: none;
                    box-sizing: border-box;
                }
                textarea:focus {
                    outline: none;
                    border-color: #007aff;
                }
                button {
                    margin-top: 10px;
                    padding: 12px 30px;
                    font-size: 16px;
                    background: #007aff;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                }
                button:hover {
                    background: #0051d5;
                }
            </style>
        </head>
        <body>
            <textarea id="textInput" placeholder="Вставьте текст здесь (Cmd+V)..."></textarea>
            <button onclick="startTyping()">Старт (Cmd+Enter)</button>
            <script>
                document.getElementById('textInput').focus();
                document.addEventListener('keydown', function(e) {
                    if (e.metaKey && e.key === 'Enter') {
                        startTyping();
                    }
                });
                function startTyping() {
                    const text = document.getElementById('textInput').value;
                    window.webkit.messageHandlers.hammerspoon.postMessage({
                        action: 'start',
                        text: text
                    });
                }
            </script>
        </body>
        </html>
    ]]
    
    local webview = hs.webview.new({x = frame.x + 100, y = frame.y + 100, w = frame.w - 200, h = frame.h - 200})
    webview:html(html)
    webview:allowGestures(false)
    webview:windowStyle({"titled", "closable", "resizable"})
    webview:windowTitle("Human Typing - Вставьте текст")
    
    webview:userContentController():addScriptMessageHandler(function(msg)
        if msg.body.action == "start" and msg.body.text and msg.body.text ~= "" then
            webview:delete()
            self:startHumanTyping(msg.body.text)
        end
    end, "hammerspoon")
    
    webview:show()
end

-- Запуск Spoon
function obj:start()
    -- Основной хоткей: Option + P
    hs.hotkey.bind(self.hotkeyStart[1], self.hotkeyStart[2], function()
        if self.isTyping then return end
        self:showInputGUI()
    end)

    -- Мгновенная печать из буфера: Option + Shift + P
    hs.hotkey.bind(self.hotkeyClipboard[1], self.hotkeyClipboard[2], function()
        if self.isTyping then return end
        local clipboardText = hs.pasteboard.getContents()
        if clipboardText and clipboardText ~= "" then
            self:startHumanTyping(clipboardText)
        end
    end)
    
    hs.notify.show("HumanTyping", "Скрипт загружен", "Нажмите ⌥P для начала")
    return self
end

-- Остановка Spoon
function obj:stop()
    self:stopTyping()
    return self
end

return obj
