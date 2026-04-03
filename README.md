# myAgent

Personal **WhatsApp-first** assistant: morning goals → **Google Calendar**, evening **AI journal** (plan vs calendar vs what you did), optional accountability nudges. Built around **[OpenClaw](https://docs.openclaw.ai/)** as the gateway; Calendar and **Mem0** plug in as you add credentials.

**Repo:** [github.com/sapkota-aayush/myAgent](https://github.com/sapkota-aayush/myAgent)

## What this repo contains

| Path | Purpose |
|------|---------|
| [docs/OPENCLAW.md](docs/OPENCLAW.md) | **Start here:** OpenClaw + WhatsApp QR, checklist, troubleshooting |
| [scripts/install-openclaw.bat](scripts/install-openclaw.bat) | Windows: install global OpenClaw via **cmd** (avoids PowerShell `npm.ps1` errors) |
| [scripts/run-openclaw.bat](scripts/run-openclaw.bat) | Run `openclaw` via full path when it’s not on PATH |
| [docs/SETUP.md](docs/SETUP.md) | Full setup: cron, Calendar, Mem0, `.env` |
| `openclaw/AGENTS.md` | Standing orders template (copy into your OpenClaw workspace) |
| `prompts/` | Morning / evening message templates for cron or manual use |
| `journal/` | Optional local daily logs ([format](docs/JOURNAL_FORMAT.md); personal `.md` files gitignored) |

## Architecture (target)

```text
Morning cron → WhatsApp: "Today's goals?"
     → You reply
     → Parse + create events (Google Calendar) + save today's plan
Evening cron → WhatsApp: "What did you do?"
     → Load plan + Calendar + your reply → short journal + Mem0
```

## Quick start

1. Follow **[docs/OPENCLAW.md](docs/OPENCLAW.md)** until WhatsApp ↔ agent works (gateway running).
2. Optional: copy `.env.example` → `.env` when you add Calendar/Mem0/scripts (not required for OpenClaw-only chat).
3. Then use [docs/SETUP.md](docs/SETUP.md) for cron, Google Calendar, and Mem0.
4. Copy `openclaw/AGENTS.md` into your OpenClaw workspace (also listed in OPENCLAW.md).

**Stack note:** You can stay **OpenClaw-only** for v1. **FastAPI** (or another small server) is optional—only needed if you want OAuth callbacks or webhooks in this repo later.

## Security

- Never commit API keys, OAuth tokens, or `.env`. See `.gitignore`.
- Prefer a **dedicated** Google calendar for bot-created blocks.

## License

MIT
