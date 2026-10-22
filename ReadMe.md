# 🚀 Soluify Telegram Copy & Paste Bot

![Soluify Bot Logo](https://share.woahlab.com/-vXC6zguKx2)
![Python](https://img.shields.io/badge/python-3.11%2B-blue)
![Docker](https://img.shields.io/badge/docker-ready-2496ED?logo=docker&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

> **About this fork:** this is a maintained fork of [Woahai321/soluify-telegram-copypaste-bot](https://github.com/Woahai321/soluify-telegram-copypaste-bot) by [Soluify](https://soluify.com/), which was archived in October 2024. It adds Docker and unattended (headless) deployment, fixes several forwarding bugs, and adds timestamped activity logs. See [What's New in This Fork](#-whats-new-in-this-fork).

Welcome to the **Soluify Telegram Copy & Paste Bot**! 🎉 This isn't just any bot—this is your new best friend in automating Telegram message management. It watches the Telegram chats you choose and copies new messages into your destination chats or channels, filtered by your keywords and blacklist, with your own signature attached. Whether you're the mastermind behind multiple community groups, a diligent update tracker, or someone who just loves a bit of automation magic, this bot is here to make your life easier. Let's dive in!

## 📜 Table of Contents

1. [Demo](#-demo)
2. [Features](#-features)
3. [What's New in This Fork](#-whats-new-in-this-fork)
4. [How it Works](#️-how-it-works)
5. [Getting Started](#-getting-started)
    - [Prerequisites](#prerequisites)
    - [Option A: Run Locally](#option-a-run-locally)
    - [Option B: Run with Docker](#option-b-run-with-docker)
    - [Deploying to Another Machine or a NAS](#deploying-to-another-machine-or-a-nas)
    - [Environment Variables](#environment-variables)
    - [Where Your Data Lives](#where-your-data-lives)
    - [Upgrading from an Older Version](#upgrading-from-an-older-version)
6. [Monitoring the Bot](#-monitoring-the-bot)
7. [Troubleshooting](#-troubleshooting)
8. [Roadmap](#-roadmap)
9. [Notes](#-notes)
10. [Contact](#-contact)
11. [Donations](#-donations)
12. [Contributing](#-contributing)
13. [Credits](#-credits)
14. [License](#-license)
15. [Fun Zone: Get to Know Your Bot!](#-fun-zone-get-to-know-your-bot)
16. [Legal Disclaimer](#️-legal-disclaimer)

## 🎬 Demo

![Soluify Bot In Action](https://share.woahlab.com/-Kwzz3cn4rq)

---

## 🌟 Features

- **Keyword-Based Forwarding:** Only copy messages that contain your keywords, or leave keywords blank to copy everything.
- **Multiple Source & Destination Chats:** Monitor several chats at once and copy into several destinations.
- **Custom Signatures:** Append your own signature to every copied message.
- **Blacklisting:** Skip messages that contain specific words or characters.
- **Media Forwarding:** Photos and files are downloaded and re-uploaded with their caption and your signature.
- **Profile Management:** Save and edit multiple configuration profiles for different setups.
- **Docker & Headless Mode:** Run unattended in a container that starts forwarding on boot, with no prompts.
- **Activity Log:** Every incoming message is logged as forwarded or skipped (with the reason), and a regular "still running" status line shows the bot is alive.
- **Enhanced Security:** Masked input for sensitive information and encrypted credential storage (random salt per file).
- **Media Housekeeping:** Downloaded media older than a configurable number of days (default: 3) is deleted automatically.
- **Error Handling and Logging:** Errors are written to `soluify.log`; temporary network problems are retried automatically.
- **Graceful Exit:** Type `exit` to stop forwarding and return to the menu; in Docker, `docker stop` shuts down cleanly.
- **Colorful UI:** Enjoy a visually appealing interface with gradient text and emojis.
- **Helpful Guidance:** Built-in help option for easy access to information about using the bot.

---

## 🆕 What's New in This Fork

**Deployment**
- Docker image and `docker-compose.yml`, with all runtime files kept in one mounted data folder.
- Headless mode (`HEADLESS=1`): reads the API credentials and profile from environment variables, starts forwarding immediately, and restarts automatically.
- Timestamped log lines (with a configurable timezone) and a "still running" status line every 10 minutes.

**Bug fixes**
- **Wrong media forwarded:** cached media is now saved as `<message_id>.<ext>`. Previously, any file whose name happened to contain the message ID could be sent instead of the real one.
- **Blacklist ignored:** the profile's blacklist is now actually applied.
- **Crash when not saving credentials:** choosing "don't save" no longer crashes on start-up.
- **Exit cleanup:** the session file is now deleted when you choose not to keep credentials, and answering "n" no longer deletes saved credentials.
- **Empty source chat:** no longer crashes when forwarding starts.
- **Text-less media:** no longer crashes the blacklist check.

**Security**
- Credentials are encrypted with a random per-file salt instead of a fixed one. Older credential files still open with your existing password and are upgraded automatically.

---

## 🛠️ How it Works

The Soluify Bot harnesses the power of the [Telethon](https://github.com/LonamiWebs/Telethon) library to interact with the Telegram API as your own user account (not as a Telegram bot account). If you don't have your API credentials yet, you can grab them from your [Telegram account](https://my.telegram.org/apps).

1. **Authentication:** Provide your Telegram API ID, API hash, and phone number, then approve the login with the code Telegram sends you. The login is saved in a session file, so you only do this once.
2. **Chat Selection:** List your chats and note the IDs of the ones to copy from and to.
3. **Configuration:** Specify keywords, a signature, and a blacklist, and save them as a profile.
4. **Monitoring:** The bot checks the source chats for new messages every 5 seconds and copies the ones that match your settings.

---

## 🔧 Getting Started

### Prerequisites

- **Telegram API credentials** (API ID and API hash) from [my.telegram.org](https://my.telegram.org/apps)
- **Either** Python 3.11 or higher (also runs on Python 3.14), **or** Docker
- Works on Windows, macOS, and Linux

### Option A: Run Locally

```bash
# Clone the repository
git clone https://github.com/manleong/soluify-telegram-copypaste-bot.git
cd soluify-telegram-copypaste-bot

# Install dependencies
pip install -r requirements.txt

# Run the script
python SoluifyCopier.py
```

1. **Fill in the required details when prompted:**
    - **Add your API ID & Hash:** Get these from your [Telegram account](https://my.telegram.org/apps).
    - **Log into Telegram:** Enter your phone number (e.g., 447123456789) & approve with the code Telegram sends you.
    - **Save credentials (optional):** If you choose to save, they are encrypted with a password you pick, and you only need that password next time.

2. **Choose an option:**
    - **(1) List My Chat IDs:** View your chats and their IDs (also saved to `chats_of_<phone>.txt`).
    - **(2) Set Up Message Forwarding:**
        - Input the source chat IDs and destination chat IDs.
        - Configure keywords for message filtering (leave blank to forward all messages).
        - Enter a signature to be appended to forwarded messages.
        - Add any blacklisted words or characters.
        - Optionally save it all as a profile. Type `exit` and press Enter to stop forwarding.
    - **(3) Edit Profile:** Modify existing configuration profiles.
    - **(4) Help:** Access information about how to use the bot.
    - **(5) Exit:** Safely close the application with options to save or delete credentials.

### Option B: Run with Docker

Running in Docker is a two-step workflow: log in **once** interactively, then run **unattended** in the background.

**1. Configure:** copy `.env.example` to `.env` and set `HOST_DATA_PATH`, `TG_API_ID`, `TG_API_HASH`, `TG_PHONE` and `TG_PROFILE`.

**2. One-time setup (interactive):** log in to Telegram and create a forwarding profile:

```bash
docker compose build
docker compose run --rm -e HEADLESS=0 soluify
```

When asked at login, choose to **save** your credentials. Then use menu option 2 to create and save a profile (its name goes in `TG_PROFILE`), type `exit`, choose option 5, and confirm keeping your credentials. Choosing not to save deletes the session file on exit. The login session is stored in `HOST_DATA_PATH` and reused from then on.

**3. Run unattended:** set `HEADLESS=1` in `.env`, then:

```bash
docker compose up -d                  # start in the background; restarts automatically
docker logs -f soluify-copier         # watch forwarding activity
docker compose down                   # stop
```

In headless mode the bot skips the menu and password prompt, starts forwarding `TG_PROFILE` immediately, and shuts down cleanly on `docker stop`. If the Telegram session expires or is revoked, the log shows `Session is not authorized`; repeat step 2 to log in again.

**Changing settings later:** edit `.env`, then run `docker compose up -d` again. The container has to be recreated to pick up new values; `docker restart` alone is not enough.

> **Protect the data folder.** The `session_<phone>.session` file grants full access to your Telegram account without a password or code. Keep `HOST_DATA_PATH` on a disk that is not synced to cloud storage, and never commit it.

### Deploying to Another Machine or a NAS

You can build the image on one computer and run it somewhere else, for example in Synology Container Manager.

**1. Build an image for the target's CPU.** Check the target first (on Synology: *Control Panel → Info Center → General → CPU*). Most NAS models use Intel or AMD; some use ARM.

```bash
# Intel/AMD target (most NAS models)
docker buildx build --platform linux/amd64 -t soluify-copier:amd64 --load .
docker save soluify-copier:amd64 -o soluify-copier-amd64.tar

# ARM target
docker buildx build --platform linux/arm64 -t soluify-copier:arm64 --load .
docker save soluify-copier:arm64 -o soluify-copier-arm64.tar
```

**2. Prepare a project folder on the target** with:
- a `docker-compose.yml` that uses the imported image instead of building. Copy the repo's file, delete the `build: .` line, and set `image:` to the tag you built (e.g. `soluify-copier:amd64`);
- your `.env`, with `HOST_DATA_PATH` changed to the target's data folder (e.g. `/volume1/docker/soluify-telegram`);
- your data files (at least `session_<phone>.session` and `telegramconfiguration.json`) copied into that data folder.

**3. Import and start.** On Synology Container Manager:
1. **Image → Action → Import → Add from file**, then choose the `.tar`.
2. **Project → Create**, then choose the project folder and use its existing `docker-compose.yml`.
3. Check **Container → soluify-copier → Log** for `Successfully connected to Telegram!`.

To change settings on Synology, replace `.env` (File Station upload with **Overwrite**, or edit it with the Text Editor package). Then go to **Project → Action → Stop** and **Build** so the container is recreated.

> **Run the bot on one machine at a time.** Using the same session file on two machines at once can make Telegram end the session on both, and you will have to log in again. Stop the old machine's container before starting the new one.

### Environment Variables

Docker Compose reads these from `.env`. The script itself reads them from the process environment, so they also work when running locally.

| Variable | Default | Description |
|---|---|---|
| `HOST_DATA_PATH` | `./data` | Host folder mounted as `/data` in the container. Use forward slashes on Windows |
| `DATA_DIR` | `./data` (local) or `/data` (Docker) | Directory for all runtime data: credentials, profiles, sessions, logs, and media cache |
| `HEADLESS` | `0` | `1` = start forwarding `TG_PROFILE` with no prompts; `0` = interactive menu |
| `TG_API_ID` / `TG_API_HASH` | — | Telegram API credentials (headless mode only) |
| `TG_PHONE` | — | Phone number used at login, digits only; must match the `session_<phone>.session` file name (headless mode only) |
| `TG_PROFILE` | — | Name of a saved profile in `telegramconfiguration.json` (headless mode only) |
| `HEARTBEAT_MINUTES` | `10` | Headless mode: print a "still running" status line with the forwarded count this often. `0` = off |
| `TZ` | `UTC` | Timezone for log timestamps, e.g. `Asia/Kuala_Lumpur` |
| `MEDIA_RETENTION_DAYS` | `3` | Delete downloaded media files older than this many days, on startup and every 24 hours. `0` = keep forever |

### Where Your Data Lives

Everything the bot saves goes into the data folder (`./data` locally, or `HOST_DATA_PATH` with Docker):

| File | Contents |
|---|---|
| `session_<phone>.session` | Your Telegram login. **Treat it like a password.** |
| `credentials.json` | API ID, hash and phone, encrypted with your password (only if you chose to save them) |
| `telegramconfiguration.json` | Your saved forwarding profiles |
| `chats_of_<phone>.txt` | Chat list from menu option 1 |
| `soluify.log` | Error log |
| `media/<chat_id>/` | Temporary copies of forwarded media |

### Upgrading from an Older Version

- **Credentials:** files created by older versions still open with your existing password. They are upgraded to the new encryption automatically on first use, and the original is kept as `credentials.json.legacy.bak`.
- **File location:** runtime files now live in the data folder. Move any `credentials.json`, `telegramconfiguration.json` and `session_*.session` files from the script folder into it, or the bot will start fresh.
- **Old logins:** Telegram ends logins that haven't been used for a long time (6 months by default). If the bot asks for a code again after an upgrade, that is why. Log in once and the new session is saved.

---

## 📈 Monitoring the Bot

In headless mode every line starts with a timestamp, so the newest line tells you when the bot was last active:

```
[2026-10-08 13:48:30] Soluify headless mode: profile 'My Profile' 🚀
[2026-10-08 13:48:30] Successfully connected to Telegram! ✅
[2026-10-08 13:48:30] Forwarding [-1001234567890] -> [-1009876543210]. Polling every 5 seconds, status every 10 min. 👀
[2026-10-08 13:52:11] Forwarded msg 4521 from -1001234567890 -> [-1009876543210]: "Market update for today…" ✅
[2026-10-08 13:55:40] Skipped msg 4522 from -1001234567890 (blacklisted word): "Sponsored: …" 🚫
[2026-10-08 13:58:30] Still running: 1 message(s) forwarded in the last 10 min 💓
```

If the latest `Still running` line is less than `HEARTBEAT_MINUTES` old, the bot is healthy.

---

## 🛠 Troubleshooting

### Common Issues

1. **Error: `SessionPasswordNeededError`**
   - **Solution:** This error occurs if your Telegram account has two-step verification enabled. The bot will prompt you to enter your password after you input the verification code.

2. **Error: `FloodWaitError`**
   - **Solution:** Telegram has rate limits to prevent spam. If you encounter this error, the bot will automatically wait for the required time before retrying.

3. **Invalid API Credentials**
   - **Solution:** Double-check your API ID and API Hash. Make sure they match the credentials from your [Telegram account](https://my.telegram.org/apps).

4. **No Messages Being Forwarded**
   - **Solution:** Check the log first. `Skipped ... (no keyword match)` or `(blacklisted word)` means your filters are excluding the message. If nothing at all is logged, check the source chat IDs and make sure your account can still read the source chat.

5. **`Session is not authorized` (headless mode)**
   - **Solution:** The saved login has expired or was ended from another device. Run the one-time interactive setup again (`docker compose run --rm -e HEADLESS=0 soluify`). Also check that `TG_PHONE` matches the `session_<phone>.session` file name.

6. **Container keeps restarting with `Headless mode needs these environment variables`**
   - **Solution:** One of `TG_API_ID`, `TG_API_HASH`, `TG_PHONE` or `TG_PROFILE` is empty, or `.env` is not in the same folder as `docker-compose.yml`.

7. **`exec format error` when the container starts**
   - **Solution:** The image was built for a different CPU type than the machine running it (for example, built on an ARM laptop and run on an Intel NAS). Rebuild with the right `--platform`; see [Deploying to Another Machine or a NAS](#deploying-to-another-machine-or-a-nas).

8. **Asked for a login code again, or logged out on all devices**
   - **Solution:** This usually means the same session file was used on two machines at once. Run the bot on one machine only, and log in again once.

9. **Script Crashes or Unexpected Behavior**
   - **Solution:** Check `soluify.log` in the data folder for detailed error messages. With Docker, also check `docker logs soluify-copier`.

---

## 🚀 Roadmap

### Short-term
1. [x] **Error Handling and Graceful Failures:** Implemented error handling to manage unexpected issues gracefully.
2. [x] **User Profiles:** Added ability for users to save their configurations as profiles for easier reuse.
3. [ ] **Media Support:** Enhance media handling to support a wider range of file types, and forward albums as a single post.
4. [x] **Additional Security Provisions:** Improved the security of how the script saves API credentials for future use.
5. [x] **Docker & Headless Deployment:** Run unattended in a container, including on a NAS.

### Mid-term
6. [ ] **Web Interface:** Develop a web-based interface for easier bot management.
7. [ ] **Performance Optimization:** Optimize the bot's performance to handle large volumes of messages efficiently.
8. [ ] **Delivery Reliability:** Avoid duplicate sends when a send fails partway through several destinations.

### Long-term
9. [ ] **Documentation and Tutorials:** Expand documentation and provide tutorials to help users make the most of the bot's features.
10. [ ] **Theming and Customization:** Allow users to customize the bot's appearance and color scheme.

---

## 📋 Notes

- **Common Sense:** Always read scripts you find online before running them to ensure your safety. Stay savvy!
- **Security:** Guard your API credentials and session file like treasure and never share them publicly.
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

1. **Fork the repository** to your own GitHub account.
2. **Create a new branch** for your feature or bug fix.
3. **Make your changes** and commit them with clear messages.
4. **Submit a pull request** for review. Let's make this bot even better together!

---

## 🙌 Credits

- **Original project:** [Woahai321/soluify-telegram-copypaste-bot](https://github.com/Woahai321/soluify-telegram-copypaste-bot), created by [**@Woahai321**](https://github.com/Woahai321) at Soluify LLC. Big shoutout for building it! [Website](https://soluify.com/) · [LinkedIn](https://www.linkedin.com/company/soluify)
- **Fork maintainer:** [**@manleong**](https://github.com/manleong)
- Built on [Telethon](https://github.com/LonamiWebs/Telethon).

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/license/mit), as declared by the original project.

- Original work © 2024 Soluify LLC.
- Modifications in this fork © 2025–2026 manleong.

The MIT License requires that the copyright and license notice above be kept in all copies or substantial portions of the software.

---

# 🎉 Fun Zone: Get to Know Your Bot!

If you've made it this far, you're in for a treat! Let's dive into the personality behind your new digital assistant.

## 📦 Fun Facts Box

Did you know?
- The average person spends 3 hours a day on messaging apps. Our bot is here to give you some of that time back! ⏰
- The first computer bug was an actual moth found in a computer relay in 1947...[Seriously](https://education.nationalgeographic.org/resource/worlds-first-computer-bug/)! Luckily, our bot doesn't attract any moths! 🦋

## 🏆 Bot Achievements

From the original author's own usage (not stress tested):

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
    - By using this bot, you agree that you are solely responsible for any actions taken using the bot. The creators and maintainers of the **Soluify Telegram Copy & Paste Bot** are not liable for any misuse or consequences arising from the use of this tool.
