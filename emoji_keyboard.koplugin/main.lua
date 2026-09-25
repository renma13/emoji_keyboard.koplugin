local Device = require("device")
local Dispatcher = require("dispatcher")
local InfoMessage = require("ui/widget/infomessage")
local UIManager = require("ui/uimanager")
local VirtualKeyboard = require("ui/widget/virtualkeyboard")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local _ = require("gettext")

local EmojiKeyboard = WidgetContainer:extend{
    name = "emoji_keyboard",
    is_doc_only = false,
}

local LAYOUT_CODE = "emoji"
local LAYOUT_MODULE = "emoji_keyboard"
local LAYOUT_REQUIRE_PATH = "ui/data/keyboardlayouts/" .. LAYOUT_MODULE

local function key(label, value, width)
    return {
        label = label,
        value or label,
        value or label,
        value or label,
        value or label,
        width = width,
    }
end

local function popup(primary, north, northwest, west, southwest, south, southeast, east)
    return {
        primary,
        north = north,
        northwest = northwest,
        west = west,
        southwest = southwest,
        south = south,
        southeast = southeast,
        east = east,
    }
end

local function buildEmojiLayout()
    return {
        min_layer = 1,
        max_layer = 1,
        utf8mode_keys = { ["🌐"] = true },
        keys = {
            {
                { popup("😀", "😁", "😂", "🤣", "😃", "😄", "😅", "😆") },
                { popup("🙂", "😉", "😊", "😍", "😘", "😚", "😋", "😛") },
                { popup("😎", "🤓", "🧐", "🤠", "🥳", "🤩", "😇", "🤗") },
                { popup("🥰", "🤭", "🤫", "🤔", "😐", "😑", "🙄", "😬") },
                { popup("😌", "😴", "🤤", "😪", "😵", "🥴", "🤒", "🤕") },
                { popup("😢", "😭", "😤", "😠", "😡", "🤯", "😱", "😨") },
                { popup("❤️", "🧡", "💛", "💚", "💙", "💜", "🤎", "🖤") },
                { popup("👍", "👎", "👏", "🙌", "🙏", "🤝", "💪", "👌") },
            },
            {
                { popup("✨", "⭐", "🌟", "💫", "🔥", "💥", "⚡", "☀️") },
                { popup("🎉", "🎊", "🎁", "🏆", "🥇", "✅", "☑️", "✔️") },
                { popup("📌", "📍", "🔖", "📝", "✏️", "📚", "💡", "🔎") },
                { popup("☕", "🍵", "🍫", "🍰", "🍕", "🍜", "🍎", "🍓") },
                { popup("🌱", "🌿", "🍀", "🌸", "🌻", "🌙", "🌈", "☁️") },
                { popup("🐾", "🎵", "🎧", "🎮", "📖", "🧠", "💭", "💬") },
                { popup("🚀", "🛠️", "⚙️", "🔧", "🔒", "🔓", "⏰", "⌛") },
                { popup("❗", "❓", "‼️", "⁉️", "➕", "➖", "➡️", "⬅️") },
            },
            {
                key("1", "1"),
                key("2", "2"),
                key("3", "3"),
                key("4", "4"),
                key("5", "5"),
                key("6", "6"),
                key("7", "7"),
                key("8", "8"),
                key("9", "9"),
                key("0", "0"),
            },
            {
                key(",", ","),
                key(".", "."),
                key("?", "?"),
                key("!", "!"),
                key("'", "'"),
                key("\"", "\""),
                key("-", "-"),
                { label = "", width = 1.5 },
            },
            {
                { label = "🌐" },
                key("space", " ", 3.0),
                { label = "←" },
                { label = "→" },
                { label = "⮠", "\n", "\n", "\n", "\n", width = 1.5 },
            },
        },
    }
end

local function registerLayout()
    package.preload[LAYOUT_REQUIRE_PATH] = buildEmojiLayout
    VirtualKeyboard.lang_to_keyboard_layout[LAYOUT_CODE] = LAYOUT_MODULE
end

local function ensureLayoutEnabled()
    local keyboard_layouts = G_reader_settings:readSetting("keyboard_layouts", {})
    for _, layout in ipairs(keyboard_layouts) do
        if layout == LAYOUT_CODE then
            return false
        end
    end
    if #keyboard_layouts < 4 then
        table.insert(keyboard_layouts, LAYOUT_CODE)
        G_reader_settings:saveSetting("keyboard_layouts", keyboard_layouts)
        return true
    end
    return false
end

function EmojiKeyboard:init()
    registerLayout()
    ensureLayoutEnabled()
    self:onDispatcherRegisterActions()
    if self.ui and self.ui.menu then
        self.ui.menu:registerToMainMenu(self)
    end
end

function EmojiKeyboard:onDispatcherRegisterActions()
    Dispatcher:registerAction("emoji_keyboard_enable", {
        category = "none",
        event = "EmojiKeyboardEnable",
        title = _("Enable emoji keyboard layout"),
        general = true,
    })
end

function EmojiKeyboard:addToMainMenu(menu_items)
    menu_items.emoji_keyboard = {
        text = _("Emoji keyboard"),
        sorting_hint = "more_tools",
        sub_item_table = {
            {
                text = _("Enable emoji layout"),
                keep_menu_open = true,
                checked_func = function()
                    local keyboard_layouts = G_reader_settings:readSetting("keyboard_layouts", {})
                    for _, layout in ipairs(keyboard_layouts) do
                        if layout == LAYOUT_CODE then
                            return true
                        end
                    end
                    return false
                end,
                callback = function(touchmenu_instance)
                    local added = ensureLayoutEnabled()
                    UIManager:show(InfoMessage:new{
                        text = added and _("Emoji layout enabled. Use the globe key on the keyboard to switch to it.")
                            or _("Emoji layout is already enabled, or KOReader already has four active keyboard layouts."),
                        timeout = 3,
                    })
                    if touchmenu_instance then
                        touchmenu_instance:updateItems()
                    end
                end,
            },
            {
                text = _("Show virtual keyboard in text fields"),
                keep_menu_open = true,
                checked_func = function()
                    return G_reader_settings:isTrue("virtual_keyboard_enabled")
                end,
                callback = function(touchmenu_instance)
                    G_reader_settings:flipNilOrFalse("virtual_keyboard_enabled")
                    if touchmenu_instance then
                        touchmenu_instance:updateItems()
                    end
                end,
            },
            {
                text = _("About emoji keyboard"),
                callback = function()
                    UIManager:show(InfoMessage:new{
                        text = _("Open or create a note, show the virtual keyboard, then tap or hold the globe key to switch layouts. Tap an emoji to insert it at the cursor. Long-press many emoji keys for related choices."),
                    })
                end,
            },
        },
    }
end

function EmojiKeyboard:onEmojiKeyboardEnable()
    registerLayout()
    ensureLayoutEnabled()
    if Device:isTouchDevice() then
        UIManager:show(InfoMessage:new{
            text = _("Emoji layout enabled. Use the globe key on the keyboard to switch to it."),
            timeout = 3,
        })
    end
    return true
end

return EmojiKeyboard
