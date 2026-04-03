# OpenClaw first — step-by-step

**Goal for this phase:** OpenClaw **gateway** running, **WhatsApp** linked via **QR**, and you can **chat with your agent** from your phone. No Calendar, Mem0, or cron required yet.

Official reference: [OpenClaw Getting Started](https://docs.openclaw.ai/start/getting-started), [WhatsApp channel](https://docs.openclaw.ai/channels/whatsapp.md).

---

## 0. Check Node

```powershell
node --version
```

OpenClaw targets **Node 22.14+** (docs often recommend **Node 24**). If you see errors during install or on the gateway, upgrade Node (e.g. via [nodejs.org](https://nodejs.org/) or `nvm-windows`) and retry.

---

## 1. Install OpenClaw (Windows)

**Recommended (normal):** use **npm**. OpenClaw needs **Node ≥ 22.14** (Node **24** is fine). If `node -v` shows **v21** or lower, install current Node from [https://nodejs.org](https://nodejs.org/) (LTS), then open a **new** terminal.

**Easiest on Windows:** use **Command Prompt** (`cmd.exe`, not PowerShell) so `npm` is just `npm`:

```bat
node -v
npm install -g openclaw@latest
openclaw --version
openclaw onboard --install-daemon
```

**Cursor / VS Code still opens PowerShell?** Either:

- Run **`scripts\install-openclaw.bat`** (double‑click in Explorer, or from any shell: `cmd /c scripts\install-openclaw.bat` from the repo folder), **or**
- One line from PowerShell (forces **cmd** so `npm.ps1` is never used):

```powershell
cmd /c "npm uninstall -g openclaw & npm install -g openclaw@latest & openclaw --version"
```

Then: `cmd /c "openclaw onboard --install-daemon"` (or run `openclaw onboard --install-daemon` inside **cmd** after install).

**PowerShell only:** if `npm` hits `npm.ps1` / “not digitally signed”, use `npm.cmd` and `openclaw.cmd` instead, or run the same four lines from **cmd**.

**`npm ERR! EBUSY` / rename `openclaw`:** Something has the global folder locked (another terminal, gateway, or stuck `node`). Close other terminals and any running OpenClaw, then:

```bat
npm uninstall -g openclaw
npm install -g openclaw@latest
```

If it still fails, reboot once and retry the two lines above.

If `openclaw` is not found after install, the CLI is usually here: **`%AppData%\npm\openclaw.cmd`** (full path like `C:\Users\YOU\AppData\Roaming\npm\openclaw.cmd`). That folder is often **missing from PATH**.

**Run without fixing PATH:**

```bat
"%AppData%\npm\openclaw.cmd" --version
"%AppData%\npm\openclaw.cmd" onboard --install-daemon
```

**Fix permanently (recommended):** Windows → search **environment variables** → **Edit the system environment variables** → **Environment Variables** → under *User*, select **Path** → **New** → paste:

`%AppData%\npm`

→ OK, then **open a new** terminal. After that, `openclaw` works everywhere.

The repo script **`scripts\install-openclaw.bat`** prepends `%AppData%\npm` to PATH for that window only so `openclaw --version` works right after install.

Optional (PowerShell): `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

**Optional:** installer script (only if HTTPS works on your network):

```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

### If `iwr` fails: “connection was closed” / TLS / Schannel

That usually means **HTTPS to openclaw.ai** failed on your network or TLS stack. Try **in order**:

**A — Force TLS 1.2 (Windows PowerShell 5.1), then retry**

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
iwr -useb https://openclaw.ai/install.ps1 | iex
```

**B — Download with curl, then run the file**

```powershell
curl.exe -fsSL "https://openclaw.ai/install.ps1" -o "$env:TEMP\openclaw-install.ps1"
powershell -ExecutionPolicy Bypass -File "$env:TEMP\openclaw-install.ps1"
```

If curl reports **Schannel** / **invalid token**, try (some corporate networks):

```powershell
curl.exe -k -fsSL "https://openclaw.ai/install.ps1" -o "$env:TEMP\openclaw-install.ps1"
powershell -ExecutionPolicy Bypass -File "$env:TEMP\openclaw-install.ps1"
```

(`-k` skips certificate verification — only if you understand the risk, e.g. debugging behind a broken proxy.)

**C — Skip the script: use npm** ([official alternative](https://docs.openclaw.ai/install))

Requires Node **22.14+** (24 recommended):

```powershell
npm install -g openclaw@latest
openclaw onboard --install-daemon
```

**D — Browser:** open [openclaw.ai/install.ps1](https://openclaw.ai/install.ps1), save as `install.ps1`, then:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

**E — VPN / antivirus “HTTPS scan” / proxy:** temporarily disable or allowlist `openclaw.ai`, or try another network (phone hotspot).

---

## 2. Onboarding wizard

```powershell
openclaw onboard --install-daemon
```

- Pick a **model provider** and paste an **API key** when asked (this is how the agent thinks; it is **not** the same as WhatsApp login).
- Finish the wizard; it configures the gateway and auth.

---

## 3. Confirm the gateway

```powershell
openclaw gateway status
openclaw dashboard
```

If the dashboard opens and chat works in the browser, the core loop is alive.

---

## 4. Add WhatsApp (QR — no Meta `WHATSAPP_*` keys)

Install the channel plugin if prompted:

```powershell
openclaw plugins install @openclaw/whatsapp
```

Link **WhatsApp Web** (scan QR with the phone you want to use):

```powershell
openclaw channels login --channel whatsapp
```

Start (or restart) the gateway so the channel stays connected:

```powershell
openclaw gateway
```

Leave this process **running** while you test (or use the **daemon** you installed during `onboard` if that’s how you run it day-to-day).

**Runtime:** use **Node** for the gateway (not Bun) for stable WhatsApp, per upstream docs.

---

## 5. Lock who can talk to the bot (important)

Edit your OpenClaw config (usually `~/.openclaw/openclaw.json` on Unix; on Windows often `C:\Users\<you>\.openclaw\openclaw.json`). Set **your** number in E.164 (include country code, no spaces):

```json5
{
  channels: {
    whatsapp: {
      dmPolicy: "allowlist",
      allowFrom: ["+1XXXXXXXXXX"],
    },
  },
}
```

Replace `+1XXXXXXXXXX` with your real number. Restart the gateway after saving.

If you use **pairing** mode instead of allowlist, approve requests with:

```powershell
openclaw pairing list whatsapp
openclaw pairing approve whatsapp <CODE>
```

Details: [WhatsApp configuration](https://docs.openclaw.ai/channels/whatsapp.md).

---

## 6. Add standing orders (this repo)

Copy **`openclaw/AGENTS.md`** from this repository into the **OpenClaw workspace** your gateway uses (the same workspace where the agent reads `AGENTS.md`). Edit:

- Timezone  
- Your E.164 (for clarity in instructions)  
- Tone (gentle vs firm reminders)

Restart the gateway if your setup requires it for file changes to load.

---

## 7. Smoke test from your phone

1. Open **WhatsApp** on your phone.  
2. Message the **linked account** (often a **second number** is easiest; personal-number / self-chat is supported but read the [self-chat notes](https://docs.openclaw.ai/channels/whatsapp.md)).  
3. You should get an **agent reply**.

**Done when:** you reliably get replies in WhatsApp with the gateway running.

---

## 8. If something breaks

Run, in order:

```powershell
openclaw doctor
openclaw channels status
openclaw logs --follow
```

Common fixes: re-run `openclaw channels login --channel whatsapp`, fix `allowFrom` / pairing, ensure **Node** (not Bun), gateway not sleeping on a closed laptop.

---

## 9. Next (after this works)

- **Morning / evening pings:** [SETUP.md §4](SETUP.md) — `openclaw cron add` (optional second milestone).  
- **Google Calendar / Mem0:** later phases in [SETUP.md](SETUP.md).

---

## Checklist

- [ ] Node installed; upgraded if gateway failed  
- [ ] `openclaw onboard` completed  
- [ ] `openclaw dashboard` chat works  
- [ ] `openclaw channels login --channel whatsapp` — QR scanned  
- [ ] `allowFrom` or pairing set so only you (or trusted numbers) can DM  
- [ ] `AGENTS.md` copied into OpenClaw workspace and edited  
- [ ] WhatsApp → agent reply works with gateway running  
