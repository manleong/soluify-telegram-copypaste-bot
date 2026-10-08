# 🚀 Soluify Telegram Copy & Paste Bot

![Soluify Bot Logo](https://share.woahlab.com/-vXC6zguKx2)
[![Website](https://img.shields.io/website?label=soluify.com&style=plastic&url=https%3A%2F%2Fsoluify.com)](https://soluify.com/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?style=plastic&logo=linkedin)](https://www.linkedin.com/company/soluify)
![Python](https://img.shields.io/badge/python-3.7%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Dependencies](https://img.shields.io/badge/dependencies-up%20to%20date-brightgreen)

Welcome to the **Soluify Telegram Copy & Paste Bot**! 🎉 This isn't just any bot—this is your new best friend in automating Telegram message management. Imagine having a super-efficient assistant that forwards messages between Telegram chats based on your specified keywords. Whether you're the mastermind behind multiple community groups, a diligent update tracker, or someone who just loves a bit of automation magic, this bot is here to make your life easier. Let's dive in!

## 📜 Table of Contents

1. [Demo](#-demo)
2. [Features](#-features)
3. [How it Works](#-how-it-works)
4. [Getting Started](#-getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation Steps](#installation-steps)
    - [Configuration](#configuration)
5. [Roadmap](#-roadmap)
6. [Notes](#-notes)
7. [Contact](#-contact)
8. [Contributing](#-contributing)
9. [License](#-license)
10. [Fun Zone: Get to Know Your Bot!](#-fun-zone-get-to-know-your-bot)

## 🎬 Demo

![Soluify Bot In Action](https://share.woahlab.com/-Kwzz3cn4rq)

---

## 🌟 Features

- **Keyword-Based Forwarding:** Automatically send messages containing your keywords to designated chats.
- **Multiple Source & Destination Chats:** Monitor and copy messages from various chats simultaneously.
- **Custom Signatures:** Add a personal touch to your forwarded messages with customizable signatures.
- **Blacklisting:** Block messages containing specific words or characters.
- **User-Friendly Interface:** Easy setup with minimal configuration needed.
- **Real-time Monitoring:** Continuous real-time message monitoring and forwarding.
- **Profile Management:** Save and edit multiple configuration profiles for different setups.
- **Enhanced Security:** Masked input for sensitive information and encrypted credential storage.
- **Graceful Exit:** Easily stop message forwarding and return to the main menu.
- **Error Handling and Logging:** Comprehensive error logging and informative user messages.
- **Automatic Retry:** Handles temporary network issues with automatic connection retries.
- **Colorful UI:** Enjoy a visually appealing interface with gradient text and emojis.
- **Helpful Guidance:** Built-in help option for easy access to information about using the bot.
- **Media Housekeeping:** Automatic cleanup of downloaded media files older than a configurable number of days (default: 3 days).

---

## 🛠️ How it Works

The Soluify Bot harnesses the power of the [Telethon](https://github.com/LonamiWebs/Telethon) library to interact with the Telegram API. Once you set up the bot with your Telegram API credentials, you can list all your chats and pinpoint those you want to forward messages from. If you don't have your API credentials yet, you can grab them from your [Telegram account](https://my.telegram.org/apps).

1. **Authentication:** Securely provide your Telegram API ID, API hash, and phone number.
2. **Chat Selection:** List and select the chats you want to monitor for forwarding messages.
3. **Configuration:** Specify keywords, add signatures, set up blacklists, and more.
4. **Monitoring:** The bot continuously monitors selected chats and forwards messages based on your settings.

---

## 🔧 Getting Started

### Prerequisites

- **Python 3.7 or higher**
- Basic command line knowledge
- Reccomend to use on Ubuntu, but should work across the board

### Installation Steps

Fire up your terminal and follow these steps:

```bash
# Clone the repository
git clone https://github.com/manleong/soluify-telegram-copypaste-bot.git
cd soluify-telegram-copypaste-bot

# Install dependencies
pip install -r requirements.txt

# Run the script
python SoluifyCopier.py
```

### Configuration

1. **Fill in the required details when prompted:**
    - **Add your API ID & Hash:** Get these from your [Telegram account](https://my.telegram.org/apps).
    - **Log into Telegram:** Enter your phone number (e.g., 447123456789) & approve with the 5-digit code Telegram sends you.

2. **Choose an option:**
    - **(1) List My Chat IDs:** View and select chats for message forwarding.
    - **(2) Set Up Message Forwarding:**
        - Input the source chat IDs and destination chat IDs.
        - Configure keywords for message filtering (leave blank to forward all messages).
        - Enter a signature to be appended to forwarded messages.
        - Add any blacklisted words or characters.
    - **(3) Edit Profile:** Modify existing configuration profiles.
    - **(4) Help:** Access information about how to use the bot.
    - **(5) Exit:** Safely close the application with options to save or delete credentials.

### Docker Deployment

Running in Docker is a two-step workflow: log in **once** interactively, then run **unattended** in the background.

**1. Configure** — copy `.env.example` to `.env` and set `HOST_DATA_PATH`, `TG_API_ID`, `TG_API_HASH` (from [my.telegram.org](https://my.telegram.org)), `TG_PHONE` and `TG_PROFILE`.

**2. One-time setup (interactive)** — log in to Telegram and create a forwarding profile:

```bash
docker compose build
docker compose run --rm -e HEADLESS=0 soluify
```

Use menu option 2 to create and save a profile (its name goes in `TG_PROFILE`), then option 5 and choose to **save** credentials so the session file is kept. The login session is stored in `HOST_DATA_PATH` and reused from then on.

**3. Run unattended** — set `HEADLESS=1` in `.env`, then:

```bash
docker compose up -d                  # start in the background; restarts automatically
docker logs -f soluify-copier         # watch forwarding activity
docker compose down                   # stop
```

In headless mode the bot skips the menu and password prompt, starts forwarding `TG_PROFILE` immediately, and shuts down cleanly on `docker stop`. If the Telegram session expires or is revoked, the container logs `Session is not authorized` — repeat step 2 to log in again.

> **Protect the data folder.** The `session_<phone>.session` file grants full access to your Telegram account without a password or code. Keep `HOST_DATA_PATH` on a local disk that is not synced to cloud storage, and never commit it.

### Environment Variables

These are read by Docker Compose from `.env` (the script itself reads them from the process environment):

| Variable | Default | Description |
|---|---|---|
| `HOST_DATA_PATH` | `./data` | Host folder mounted as `/data` in the container. Use forward slashes on Windows |
| `DATA_DIR` | `./data` (local) or `/data` (Docker) | Directory for all runtime data: credentials, profiles, sessions, logs, and media cache |
| `MEDIA_RETENTION_DAYS` | `3` | Automatically delete downloaded media files older than this many days. Set to `0` to disable cleanup |
| `HEADLESS` | `0` | `1` = start forwarding `TG_PROFILE` with no prompts; `0` = interactive menu |
| `HEARTBEAT_MINUTES` | `10` | Headless mode: print a "still running" status line with the forwarded count this often. `0` = off |
| `TZ` | `UTC` | Timezone for log timestamps, e.g. `Asia/Kuala_Lumpur` |
| `TG_API_ID` / `TG_API_HASH` | — | Telegram API credentials (headless mode only) |
| `TG_PHONE` | — | Phone number used at login, digits only (headless mode only) |
| `TG_PROFILE` | — | Name of a saved profile in `telegramconfiguration.json` (headless mode only) |

**How media housekeeping works:**
- On startup, the bot scans the `media/` folder and removes any files older than `MEDIA_RETENTION_DAYS`.
- While forwarding is active, cleanup re-runs automatically every 24 hours.
- Set `MEDIA_RETENTION_DAYS=0` to keep all media files indefinitely.

**Upgrading from an older version:** credentials files created before this version are still read with your existing password and are upgraded automatically on first use (the original is kept as `credentials.json.legacy.bak`). Runtime files now live in the data folder, so move any `credentials.json`, `telegramconfiguration.json` and `session_*.session` files from the script folder into it.

---

## 🛠 Troubleshooting

### Common Issues

1. **Error: `SessionPasswordNeededError`**
   - **Solution:** This error occurs if your Telegram account has two-step verification enabled. The bot will prompt you to enter your password after you input the verification code.

2. **Error: `FloodWaitError`**
   - **Solution:** Telegram has rate limits to prevent spam. If you encounter this error, the bot will automatically wait for the required time before retrying.

3. **Invalid API Credentials**
   - **Solution:** Double-check your API ID and API Hash. Make sure they are correctly entered and that they match the credentials from your [Telegram account](https://my.telegram.org/apps).

4. **No Messages Being Forwarded**
   - **Solution:** Ensure that the source chat IDs and destination channel IDs are correctly configured. Also, check if the keywords and blacklist settings are correct.

5. **Script Crashes or Unexpected Behavior**
   - **Solution:** Check the `soluify.log` file for detailed error messages. This can help identify the root cause of the problem.

---

## 🚀 Roadmap

### Short-term
1. [x] **Error Handling and Graceful Failures:** Implemented error handling to manage unexpected issues gracefully.
2. [x] **User Profiles:** Added ability for users to save their configurations as profiles for easier reuse.
3. [ ] **Media Support:** Enhance media handling capabilities to support a wider range of file types.
4. [x] **Additional Security Provisions:** Improved the security of how the script saves API credentials for future use.

### Mid-term
5. [ ] **Web Interface:** Develop a web-based interface for easier bot management.
6. [ ] **Performance Optimization:** Continuously optimize the bot's performance to handle large volumes of messages efficiently.

### Long-term
7. [ ] **Documentation and Tutorials:** Expand documentation and provide tutorials to help users make the most of the bot's features.
8. [ ] **Theming and Customization:** Allow users to customize the bot's appearance and color scheme.

---

## 📋 Notes

- **Common Sense:** Always read scripts you find online before running them to ensure your safety. Stay savvy!
- **Security:** Guard your API credentials like treasure and never share them publicly.
- **Permissions:** Make sure you have the necessary permissions to access messages in the chats you intend to use. You'll need read access to the source and write access to the destination.
- **Customization:** Feel free to tweak the script's behavior and settings to fit your unique needs.

---

## 📞 Contact

Got questions or need help? Don't hesitate to add an issue on this repo and we can work through it together!

---

## 💰 Donations

If you find our work useful and would like to support us, feel free to make a donation using the addresses below:

- BTC (Bitcoin): `12ZkU4fUot5C1f7TiyU9GVVskjYnzP3AUs`
- ETH (Ethereum): `0x250c9b83534c461eb87f97e7b995325226871c51`

Thank you for your support!

---

## 🤝 Contributing

We love contributions! Here's how you can join the fun:

1. **Big Shoutout** for project original owner [**@Woahai321**](https://github.com/Woahai321)
2. **Fork the repository** to your own GitHub account.
3. **Create a new branch** for your feature or bug fix.
4. **Make your changes** and commit them with clear messages.
5. **Submit a pull request** for review. Let's make this bot even better together!

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/license/mit). Check out the LICENSE link for more details.

---

# 🎉 Fun Zone: Get to Know Your Bot!

If you've made it this far, you're in for a treat! Let's dive into the personality behind your new digital assistant.

## 📦 Fun Facts Box

Did you know?
- The average person spends 3 hours a day on messaging apps. Our bot is here to give you some of that time back! ⏰
- The first computer bug was an actual moth found in a computer relay in 1947...[Seriously](https://education.nationalgeographic.org/resource/worlds-first-computer-bug/)! Luckily, our bot doesn't attract any moths! 🦋

## 🏆 Bot Achievements

Our bot has been working hard! Here are some of its notable achievements (not stress tested, just my usage):

- **Message Marathon Runner**: Already forwarded thousands of messages without breaking a sweat!
- **Keyword Connoisseur**: Successfully filtered messages using over 60 unique keywords.
- **Chat Juggler Extraordinaire**: Managed 60 source chats and 20 destination chats simultaneously!

## 🏋️‍♂️ Bot's Workout Routine

Even bots need to stay in shape! Here's how I keep my code muscles strong:

- **Keyword Crunches**: 100 reps of scanning messages for keywords.
- **Message Lifting**: Picking up heavy messages and placing them gently in their new homes.
- **Blacklist Burpees**: Quickly jumping over and dodging blacklisted words.
- **Profile Pilates**: Flexing those configuration muscles by managing multiple profiles.
- **Error-Handling Elliptical**: A cardio session of gracefully managing unexpected situations.
- **Signature Stretches**: Keeping limber by appending custom text to messages.

Remember, a fit bot is a happy bot! 💪🤖

---

## 🛡️ Legal Disclaimer

While the **Soluify Telegram Copy & Paste Bot** is designed to help you automate your message management efficiently, it's crucial to use it responsibly and in accordance with Telegram's Terms of Service (ToS). Here are a few key points to keep in mind:

1. **Compliance with Telegram's ToS**:
    - This bot is a tool that can be used in various ways. It is the user's responsibility to ensure that their usage of the bot complies with Telegram's ToS. We advise users to regularly review Telegram's [Terms of Service](https://telegram.org/tos) to stay informed of any changes.

2. **Prohibited Activities**:
    - The bot should not be used for spamming, unsolicited messaging, or any form of abuse. Users must ensure that their actions do not violate anti-spam policies or privacy guidelines.

3. **Rate Limits**:
    - Users are responsible for managing the rate at which messages are forwarded to avoid triggering Telegram's rate limits. Excessive use that leads to rate limiting or bans is outside the scope of this bot's intended use.

4. **User Consent**:
    - Ensure that all parties involved are aware of and consent to the forwarding of messages. Forwarding messages without consent can lead to privacy violations and is not endorsed by the creators of this bot.

5. **Security**:
    - Protect your API credentials and never share them publicly. The bot is designed with security in mind, but users must take steps to safeguard their information.

6. **Responsibility for Actions**:
    - By using this bot, you agree that you are solely responsible for any actions taken using the bot. The creators of the **Soluify Telegram Copy & Paste Bot** are not liable for any misuse or consequences arising from the use of this tool.
