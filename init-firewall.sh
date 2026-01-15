#!/bin/bash
set -e

# Flush existing rules
iptables -F OUTPUT 2>/dev/null || true

# Default policy: drop all outbound
iptables -P OUTPUT DROP

# Allow loopback
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established connections (for responses)
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow DNS resolution (required to resolve anthropic domains)
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Allow ONLY Anthropic endpoints (HTTPS)
# API endpoint (for API key users)
iptables -A OUTPUT -p tcp -d api.anthropic.com --dport 443 -j ACCEPT
# Console endpoint (for Claude Max OAuth)
iptables -A OUTPUT -p tcp -d console.anthropic.com --dport 443 -j ACCEPT
# Statsig for feature flags (required by Claude Code)
iptables -A OUTPUT -p tcp -d api.statsig.com --dport 443 -j ACCEPT

# Log dropped packets (optional, for debugging)
# iptables -A OUTPUT -j LOG --log-prefix "DROPPED: "

echo "Firewall configured: only Anthropic endpoints allowed"
echo "  - api.anthropic.com:443"
echo "  - console.anthropic.com:443"
echo "  - api.statsig.com:443"
