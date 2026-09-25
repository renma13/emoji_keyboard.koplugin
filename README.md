# KOReader Emoji Keyboard Plugin

This plugin adds an `emoji` layout to KOReader's built-in virtual keyboard. It is meant for Kindle devices running KOReader, including a Kindle Paperwhite 11th Gen. It works in KOReader note dialogs and other standard text fields because KOReader inserts virtual-keyboard text through `InputText:addChars(...)`.

## Install

1. Copy `emoji_keyboard.koplugin` to KOReader's `plugins` folder.
   - On many Kindle KOReader installs, this is `koreader/plugins/emoji_keyboard.koplugin`.
   - If you use Vera to sync/copy files, copy the folder as a folder, not just the Lua files inside it.
2. Restart KOReader.
3. Open KOReader's plugin list and enable **Emoji keyboard** if it is not already enabled.
4. Open or create a note.
5. Show the virtual keyboard, then tap or long-press the globe key and switch to the `emoji` layout.

The plugin also adds a menu item under **More tools > Emoji keyboard** with an option to enable KOReader's virtual keyboard in text fields.

## Use

- Tap an emoji key to insert it at the current text cursor.
- Long-press many emoji keys to pick related emoji by tapping or swiping.
- Use the globe key to switch back to your normal text keyboard.
- KOReader supports up to four active keyboard layouts in the globe-key picker. If you already have four, disable one in KOReader's keyboard layout settings, then enable the emoji layout again.

## Kindle and Unicode limits

Emoji insertion and emoji display are separate things:

- The plugin inserts Unicode emoji text. KOReader's note storage must preserve UTF-8, which KOReader's current text input path does.
- Whether the emoji appears as a nice icon depends on KOReader's UI fonts and fallback fonts on your Kindle. Some emoji may render as monochrome symbols, missing boxes, or separate characters.
- Complex emoji sequences, color emoji, skin tones, flags, and zero-width-joiner family emoji are less reliable on e-ink Kindle builds. This plugin mostly uses simpler emoji for that reason.
- Kindle e-ink refresh is slower than a phone. The keyboard is usable, but long-press popups and layout switching will not feel mobile-fast.

If many emoji show as boxes, install or configure an emoji-capable fallback font in KOReader. A monochrome symbol font is usually more realistic on Kindle than full color emoji.

## If emoji show as question marks

This means KOReader is receiving the emoji text but cannot render the glyphs with its current UI/input fonts.

Recommended Kindle fix:

1. Download the monochrome `NotoEmoji-Regular.ttf` font, not `NotoColorEmoji.ttf`.
2. Copy `NotoEmoji-Regular.ttf` to `koreader/fonts/`.
3. In KOReader, open **Settings > Device > Additional UI fallback fonts** and enable `NotoEmoji-Regular.ttf`, then restart KOReader.

If your KOReader build does not show that fallback-font menu, use the included patch:

1. Copy `patches/1-emoji-ui-font-fallback.lua` to `koreader/patches/`.
2. Make sure `NotoEmoji-Regular.ttf` is in `koreader/fonts/`.
3. Restart KOReader fully.

Do not use `NotoColorEmoji.ttf` first on Kindle. It is much larger and uses a color emoji format that is often unsupported or unreliable in embedded/e-ink FreeType rendering. The monochrome Noto Emoji font is the better fit for Paperwhite.
