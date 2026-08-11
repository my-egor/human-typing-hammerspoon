# 🤖 Human Typing for Hammerspoon

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-Compatible-blue.svg)](https://www.hammerspoon.org/)
[![Hammerspoon](https://img.shields.io/badge/Hammerspoon-Script-purple.svg)](https://www.hammerspoon.org/)

> Simulate realistic human typing on macOS with random delays, typos, corrections, and cognitive pauses. Perfect for demos, avoiding bot detection, or just having fun.

![Demo](demo.gif)

## ✨ Features

- 🎲 **Random typing delays** — Variable speed between characters (35–135ms)
- ⏸️ **Cognitive pauses** — Random thinking pauses (~1 in 50 characters)
- 📝 **Typo simulation** — 3% chance of realistic typos with automatic corrections
- ⚡ **Smart punctuation** — Extra delays for spaces, commas, periods
- 🔤 **Uppercase handling** — Additional delay for capital letters
- 🛑 **Emergency stop** — Press `Esc` anytime to abort typing
- 🌍 **Full UTF-8 support** — Works with Russian, emoji, and all Unicode
- 📋 **Clipboard integration** — Instant paste-and-type mode

## 🚀 Installation

### Option 1: As a Spoon (Recommended)

```bash
cd ~/.hammerspoon/Spoons
git clone https://github.com/YOUR_USERNAME/HumanTyping.spoon.git
```

Then add to your `init.lua`:
```lua
hs.loadSpoon("HumanTyping")
spoon.HumanTyping:start()
```

### Option 2: Manual Setup

1. Download [init.lua](init.lua)
2. Copy to `~/.hammerspoon/init.lua` (or append to existing config)
3. Reload Hammerspoon config: click menu icon → Reload Config

## 📖 Usage

### Method 1: GUI Input Window
Press **`⌥ Option + P`**
- A text input window appears
- Paste your text with `⌘ + V`
- Press `⌘ + Enter` or click **Start**
- Watch as text types itself with human-like rhythm

### Method 2: Clipboard Quick-Type
Press **`⌥ Option + Shift + P`**
- Instantly types whatever is in your clipboard
- No GUI needed — faster workflow

### Emergency Stop
Press **`Esc`** at any time during typing to abort.

## ⚙️ Configuration

Customize behavior by modifying variables at the top of `init.lua`:

```lua
local config = {
    typoChance = 3,           -- Percentage (0-100)
    typoPauseMs = 100,        -- Delay after typo
    baseDelayMs = {35, 135},  -- Min/max delay per character
    cognitivePauseChance = 50 -- 1 in N chance of thinking pause
}
```

## 🎯 Use Cases

- **Demo recordings** — Show code being "typed" in presentations
- **Bot detection bypass** — Pass anti-bot checks that look for instant paste
- **Testing** — Simulate user input for automated testing
- **Content creation** — Record typing videos for social media

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## 📝 License

[MIT](LICENSE) — feel free to use in your projects.

## 🙏 Acknowledgments

- [Hammerspoon](https://www.hammerspoon.org/) — Amazing macOS automation tool
- Inspired by the need for more human-like automation

---

**⭐ Star this repo if you find it useful!**
