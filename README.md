# Claude Sandbox

A Docker sandbox for running [Claude Code](https://claude.ai/claude-code) with network and filesystem isolation. Safely use `--dangerously-skip-permissions` without risking your host system.

## Security

| Protection | Implementation |
|------------|----------------|
| Network | iptables blocks all egress except Anthropic endpoints |
| Filesystem | Only `./workspace` is accessible to Claude |
| Permissions | `--dangerously-skip-permissions` enabled (safe due to isolation) |

### Allowed Network Endpoints

- `api.anthropic.com:443` — Claude API
- `console.anthropic.com:443` — OAuth login
- `api.statsig.com:443` — Feature flags

Everything else is blocked.

## Usage

```bash
# Clone and run
git clone https://github.com/jhnoor/claude-sandbox.git
cd claude-sandbox
./run.sh
```

On first run, Claude will prompt you to login with `/login`.

### Working with Projects

```bash
# Copy a project into the sandbox
./run.sh /path/to/your/project

# Files are copied to ./workspace
# Claude can only access files in /project (mapped to ./workspace)
```

## Requirements

- Docker
- That's it

## How It Works

1. Builds a Docker image with Node.js 20 and Claude Code
2. Configures iptables to block all outbound traffic except Anthropic
3. Mounts only `./workspace` as `/project`
4. Runs Claude with `--dangerously-skip-permissions`

Your host filesystem and network are completely isolated from Claude.

## Files

```
├── Dockerfile          # Node 20 + Claude Code + iptables
├── init-firewall.sh    # Network restriction rules
├── run.sh              # Main entry point
├── docker-compose.yml  # Alternative usage (API key only)
└── workspace/          # Sandboxed project files
```

## License

MIT
