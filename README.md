# myAgent

Personal **WhatsApp-first** assistant: morning goals → **Google Calendar**, evening **AI journal** (plan vs calendar vs what you did), optional accountability nudges. Built around **[OpenClaw](https://docs.openclaw.ai/)** as the gateway; Calendar and **Mem0** plug in as you add credentials.

**Repo:** [github.com/sapkota-aayush/myAgent](https://github.com/sapkota-aayush/myAgent)

## What this repo contains

| Path | Purpose |
|------|---------|
| `docs/SETUP.md` | Install OpenClaw, WhatsApp QR, cron ideas, credential checklist |
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

1. Read [docs/SETUP.md](docs/SETUP.md).
2. Copy `.env.example` → `.env` and fill in keys **only as you need them** (local-first; no server required to start).
3. Install OpenClaw and connect WhatsApp (QR). Keep the **gateway running** for scheduled messages.
4. Copy `openclaw/AGENTS.md` into your OpenClaw workspace and adjust times, tone, and your phone number.
5. Add Google Calendar + Mem0 when ready (same doc).

**Stack note:** You can stay **OpenClaw-only** for v1. **FastAPI** (or another small server) is optional—only needed if you want OAuth callbacks or webhooks in this repo later.

## Security

- Never commit API keys, OAuth tokens, or `.env`. See `.gitignore`.
- Prefer a **dedicated** Google calendar for bot-created blocks.

## License

MIT
