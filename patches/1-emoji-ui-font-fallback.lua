-- Adds a monochrome emoji font to KOReader's UI/input fallback chain.
--
-- Install:
-- 1. Put NotoEmoji-Regular.ttf in koreader/fonts/
-- 2. Put this file in koreader/patches/
-- 3. Restart KOReader fully.

local Font = require("ui/font")

local emoji_font = "NotoEmoji-Regular.ttf"

for _, fallback in ipairs(Font.fallbacks) do
    if fallback == emoji_font then
        return
    end
end

table.insert(Font.fallbacks, Font.additional_fallback_insert_indice or 3, emoji_font)
Font.faces = {}
