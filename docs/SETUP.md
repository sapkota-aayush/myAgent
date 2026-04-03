# Setup guide (OpenClaw first)

Official OpenClaw docs: [Getting started](https://docs.openclaw.ai/start/getting-started), [Automation & tasks](https://docs.openclaw.ai/automation), [WhatsApp channel](https://docs.openclaw.ai/channels/whatsapp.md).

## 1. Prerequisites

- **Node.js** — OpenClaw recommends Node 24 (22.14+ supported). On Windows, [WSL2 is often more stable](https://docs.openclaw.ai/platforms/windows) for the full gateway.
- A machine (or VPS) where the **gateway can stay online** at your morning/evening times—otherwise cron will not fire.

## 2. Install OpenClaw

**Windows (PowerShell):**

```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

**macOS / Linux:**

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

Run onboarding:

```bash
openclaw onboard --install-daemon
```

Verify:

```bash
openclaw gateway status
openclaw dashboard
```

## 3. WhatsApp (phone, no separate “app” for chat)

OpenClaw’s built-in WhatsApp channel uses **WhatsApp Web (Baileys)**; you link with a **QR code**.

```bash
openclaw plugins install @openclaw/whatsapp   # if prompted during onboarding
openclaw channels login --channel whatsapp
openclaw gateway
```

Configure **who may DM the bot** (your number in E.164, e.g. `+15551234567`):

```json5
{
  channels: {
    whatsapp: {
      dmPolicy: "allowlist",
      allowFrom: ["+YOUR_E164_NUMBER"],
    },
  },
}
```

See [WhatsApp docs](https://docs.openclaw.ai/channels/whatsapp.md) for pairing, `selfChatMode`, and troubleshooting (`openclaw doctor`).

**Note:** WhatsApp gateway runtime should use **Node**, not Bun (per upstream docs).

## 4. Morning & evening cron (outline)

Scheduled tasks use the gateway cron. Example pattern (adjust `--tz`, `--to`, and channel flags to match your install—run `openclaw cron add --help` for current flags):

**Morning (07:00 local):**

```bash
openclaw cron add \
  --name "Morning goals" \
  --cron "0 7 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Read prompts/morning.txt from workspace and send the user a short WhatsApp message asking for today's goals. When they reply later, parse tasks and confirm." \
  --announce \
  --channel whatsapp \
  --to "+YOUR_E164_NUMBER"
```

**Evening (21:00 local):**

```bash
openclaw cron add \
  --name "Evening journal" \
  --cron "0 21 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Read prompts/evening.txt. Ask what they did today. If tools allow, load today's plan file and Google Calendar events, then reply with a brief neutral comparison." \
  --announce \
  --channel whatsapp \
  --to "+YOUR_E164_NUMBER"
```

Tighten the `--message` text to match the exact tools you enable (Calendar plugin, `exec`, etc.).

Manage jobs:

```bash
openclaw cron list
openclaw cron run <jobId>
openclaw cron remove <jobId>
```

## 5. Google Calendar (after WhatsApp works)

1. Create a Google Cloud project; enable **Google Calendar API**.
2. OAuth consent + credentials; store **refresh token** only on the gateway host (never in git).
3. Use a **dedicated calendar** (e.g. “Daily plan”) for bot-created events.
4. Wire via whatever OpenClaw supports when you run `openclaw` and inspect available tools/plugins—or a small sidecar script the agent invokes.

## 6. Mem0 (memory across days)

- Sign up for Mem0; create an API key.
- After each morning/evening turn, upsert a short memory (preferences, recap)—**not** the only copy of “today’s committed plan” (keep a dated file or DB keyed by `YYYY-MM-DD` in your timezone).

## 7. Credential checklist (nothing committed here)

| Credential | Where it lives |
|------------|----------------|
| LLM provider API key | OpenClaw onboarding / env |
| WhatsApp session | `~/.openclaw/credentials/whatsapp/` (do not copy into repo) |
| Google OAuth client + refresh token | Gateway host only |
| Mem0 API key | Env on gateway host |

## 8. Copy standing orders into your workspace

Copy `openclaw/AGENTS.md` from this repo into the OpenClaw workspace the gateway uses, then edit phone number, timezone, and tone.
