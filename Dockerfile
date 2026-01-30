# Kali Linux Docker Image for Educational Purposes
# Base image: Official Kali Linux Rolling Release
FROM kalilinux/kali-rolling:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# Install essential Kali Linux tools for ethical hacking education
RUN apt-get install -y \
    # Core utilities
    kali-linux-core \
    # Network analysis tools
    nmap \
    wireshark \
    tcpdump \
    netcat-traditional \
    # Web application security
    nikto \
    sqlmap \
    dirb \
    # Password cracking
    john \
    hydra \
    # Wireless tools
    aircrack-ng \
    # Exploitation frameworks
    metasploit-framework \
    # Reconnaissance tools
    whois \
    dnsutils \
    # Scripting and development
    python3 \
    python3-pip \
    git \
    vim \
    nano \
    curl \
    wget \
    # Additional utilities
    net-tools \
    iputils-ping \
    sudo \
    man-db \
    # Forensics basics
    binwalk \
    steghide \
    && rm -rf /var/lib/apt/lists/*

# Install Python security libraries
RUN pip3 install --no-cache-dir \
    scapy \
    requests \
    beautifulsoup4 \
    paramiko

# Create a non-root user for security best practices
RUN useradd -m -s /bin/bash kali && \
    echo "kali:kali" | chpasswd && \
    usermod -aG sudo kali && \
    echo "kali ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /home/kali

# Create directories for student work
RUN mkdir -p /home/kali/workspace /home/kali/tools /home/kali/labs && \
    chown -R kali:kali /home/kali

# Switch to kali user
USER kali

# Set default command
CMD ["/bin/bash"]
