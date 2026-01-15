FROM node:20-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    iptables \
    git \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Copy firewall initialization script
COPY init-firewall.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-firewall.sh

# Create non-root user for running Claude
RUN useradd -m -s /bin/bash claude \
    && echo "claude ALL=(ALL) NOPASSWD: /usr/local/bin/init-firewall.sh" >> /etc/sudoers

# Set working directory
WORKDIR /project

# Default command
CMD ["/bin/bash"]
