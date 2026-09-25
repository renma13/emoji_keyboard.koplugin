# KOReader Emoji Keyboard Plugin

This plugin adds an `emoji` layout to KOReader's built-in virtual keyboard. It is meant for Kindle devices running KOReader, including a Kindle Paperwhite 11th Gen. It works in KOReader note dialogs and other standard text fields because KOReader inserts virtual-keyboard text through `InputText:addChars(...)`.

## Install

1. Copy `emoji_keyboard.koplugin` to KOReader's `plugins` folder.
   - On many Kindle KOReader installs, this is `koreader/plugins/emoji_keyboard.koplugin`.
2. Download the monochrome `NotoEmoji-Regular.ttf` font from Google Fonts and copy it to `koreader/fonts/`.
   - Do not use `NotoColorEmoji.ttf`, as color emoji fonts are often unsupported or unreliable on Kindle e-ink devices.
3. In KOReader, open **Settings > Device > Additional UI fallback fonts** and enable `NotoEmoji-Regular.ttf`.
   - If your KOReader build does not have this option, use the included patch:
      - Copy `patches/1-emoji-ui-font-fallback.lua` to `koreader/patches/`.
      - Make sure `NotoEmoji-Regular.ttf` is in `koreader/fonts/`.
4. Restart KOReader fully.
5. Open KOReader's plugin list and enable Emoji keyboard if it is not already enabled.
6. Open or create a note, show the virtual keyboard, then tap or long-press the globe key and switch to the `emoji` layout.

The plugin also adds a menu item under **More tools > Emoji keyboard** with an option to enable KOReader's virtual keyboard in text fields.

The emoji font is required because Kindle's default fonts may not contain the necessary emoji glyphs. Without it, emojis may appear as question marks, missing boxes, or other incorrect characters.

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

## Disclaimer

I made this plugin mainly for myself because I wanted an emoji keyboard in KOReader. I'm not a coder, and this project was created with the help of AI and tested on my own Kindle.

I'm sharing it in case someone else finds it useful. Feel free to fork, modify, improve, or build on the code. There may be bugs or better ways to do things, so contributions are welcome!
