FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV GITHUB_USER_EMAIL=test@example.com
ENV GITHUB_USER_NAME="Test User"

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    sudo \
    python3 \
    python3-pip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash testuser && \
    usermod -aG sudo testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create .bashrc.d directory
RUN mkdir -p /home/testuser/.bashrc.d

# Switch to the test user
USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . /home/testuser/dotfiles/

# Run the setup script
RUN cd /home/testuser/dotfiles && bash setup.sh

# Use bash as default (setup.sh will configure fish if available)
CMD ["/bin/bash"]