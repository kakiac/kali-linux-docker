# Kali Linux Docker Environment

A comprehensive Docker-based Kali Linux environment designed for teaching ethical hacking and cybersecurity to university students. This setup provides an isolated, reproducible, and easy-to-manage environment for learning penetration testing and security assessment techniques.

## 🎓 Educational Purpose

This Docker environment is specifically designed for:
- **University courses** in ethical hacking and cybersecurity
- **Hands-on labs** and practical exercises
- **Safe, isolated testing** environments
- **Consistent setup** across all student machines
- **Easy deployment** for instructors and students

## 📚 Documentation

- **[STUDENT_GUIDE.md](STUDENT_GUIDE.md)** - Comprehensive guide for students including:
  - How this Docker environment was created
  - Basic Kali Linux commands for ethical hacking
  - Common workflows and best practices
  - Practice exercises

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Docker**: Version 20.10 or higher
  - [Install Docker on Linux](https://docs.docker.com/engine/install/)
  - [Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)
  - [Install Docker Desktop on Mac](https://docs.docker.com/desktop/install/mac-install/)
- **Docker Compose**: Version 2.0 or higher (usually included with Docker Desktop)
- At least **4GB of RAM** available for the container
- At least **10GB of disk space** for the image and tools

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/kakiac/kali-linux-docker.git
cd kali-linux-docker
```

### 2. Start the Container

```bash
./start.sh
```

This script will:
- Create necessary workspace directories
- Build the Kali Linux Docker image (first time only)
- Start the container in the background

### 3. Access the Kali Shell

```bash
./shell.sh
```

You'll be logged in as the `kali` user with sudo privileges.

### 4. Stop the Container

```bash
./stop.sh
```

## 📁 Directory Structure

```
kali-linux-docker/
├── Dockerfile              # Kali Linux image definition
├── docker-compose.yml      # Container orchestration
├── start.sh               # Start the container
├── stop.sh                # Stop the container
├── shell.sh               # Access user shell
├── root-shell.sh          # Access root shell (use with caution)
├── workspace/             # Persistent student workspace
├── labs/                  # Lab exercises and materials
├── tools/                 # Custom tools and scripts
└── README.md              # This file
```

## 🔧 Installed Tools

The container comes pre-installed with essential ethical hacking tools:

### Network Analysis
- **nmap** - Network discovery and security auditing
- **wireshark** - Network protocol analyzer
- **tcpdump** - Packet capture and analysis
- **netcat** - Network connections utility

### Web Application Security
- **nikto** - Web server scanner
- **sqlmap** - SQL injection detection and exploitation
- **dirb** - Web content scanner

### Password Cracking
- **john** - John the Ripper password cracker
- **hydra** - Network logon cracker

### Wireless Security
- **aircrack-ng** - Wireless network security tools

### Exploitation
- **metasploit-framework** - Penetration testing framework

### Reconnaissance
- **whois** - Domain information lookup
- **dnsutils** - DNS utilities (dig, nslookup)

### Development & Scripting
- **Python 3** with security libraries (scapy, requests, etc.)
- **git** - Version control
- **vim/nano** - Text editors

### Forensics
- **binwalk** - Firmware analysis tool
- **steghide** - Steganography tool

## 💡 Usage Examples

### Example 1: Network Scanning

```bash
# Access the shell
./shell.sh

# Scan a network (use ethically!)
nmap -sV 192.168.1.0/24
```

### Example 2: Web Application Testing

```bash
# Access the shell
./shell.sh

# Run a web vulnerability scan
nikto -h http://testphp.vulnweb.com
```

### Example 3: Password Cracking Exercise

```bash
# Access the shell
./shell.sh

# Create a sample password hash for educational purposes
echo "password123" | openssl passwd -1 -stdin > /home/kali/workspace/hash.txt

# Use John the Ripper to crack it
john /home/kali/workspace/hash.txt
```

## 📚 For Instructors

### Setting Up Labs

1. Place lab materials in the `labs/` directory
2. Students can access them at `/home/kali/labs` inside the container
3. Create lab documentation with step-by-step instructions

### Custom Tools

- Add custom scripts to the `tools/` directory
- They'll be available at `/home/kali/tools` in the container

### Resource Limits

You can adjust container resources in `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 4G
```

## 📝 For Students

### Workspace Management

- All work in `/home/kali/workspace` persists between container restarts
- Use version control (git) to back up your work
- The container can be reset without losing workspace data

### Best Practices

1. **Always get permission** before testing any system
2. **Use only legal targets** (your own systems or authorized test environments)
3. **Document your findings** in the workspace directory
4. **Practice ethical disclosure** of vulnerabilities
5. **Never use these tools maliciously**

### Tips

- Use `sudo` for commands requiring elevated privileges
- Default username: `kali`, default password: `kali`
- Install additional tools with: `sudo apt-get install <tool-name>`

**Note on Default Credentials**: This environment uses well-known default credentials (`kali:kali`) and passwordless sudo for educational convenience. In production environments, you should always:
- Use strong, unique passwords
- Require password authentication for sudo commands
- Follow principle of least privilege

## 🔒 Security Considerations

### Important Warnings

⚠️ **This environment is for EDUCATIONAL purposes only**
⚠️ **Only use these tools on systems you own or have explicit permission to test**
⚠️ **Unauthorized access to computer systems is illegal**

### Container Security

**Educational Trade-offs:**
This environment prioritizes ease of use for learning, with intentional security simplifications:
- Default password (`kali:kali`) is well-known - acceptable for isolated learning
- Passwordless sudo enabled - convenient for students but not production-ready
- Network capabilities granted - necessary for security tools to function

**Important**: These are deliberate educational choices. When deploying security tools in real environments:
- Always use strong authentication
- Require passwords for privileged operations
- Follow security hardening best practices
- Implement proper access controls

- The container runs with limited capabilities by default (NET_ADMIN, NET_RAW only)
- Network access is configured for safety
- For advanced network testing, you may need to enable privileged mode (use cautiously)

### Enabling Privileged Mode (If Required)

Edit `docker-compose.yml` and uncomment:

```yaml
# privileged: true
```

**Note**: Only enable privileged mode in controlled, isolated networks.

## 🛠 Troubleshooting

### Container Won't Start

```bash
# Check Docker status
docker ps -a

# View logs
docker-compose logs

# Rebuild the image
docker-compose build --no-cache
```

### Permission Issues

```bash
# Access as root to fix permissions
./root-shell.sh

# Fix workspace permissions
chown -R kali:kali /home/kali/workspace
```

### Out of Disk Space

```bash
# Clean up Docker resources
docker system prune -a

# Remove old images
docker image prune -a
```

## 📖 Additional Resources

### Learning Resources

- [Kali Linux Official Documentation](https://www.kali.org/docs/)
- [Metasploit Unleashed](https://www.offensive-security.com/metasploit-unleashed/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Hack The Box](https://www.hackthebox.eu/) - Practice platform

### Legal Testing Environments

- [HackTheBox](https://www.hackthebox.eu/)
- [TryHackMe](https://tryhackme.com/)
- [VulnHub](https://www.vulnhub.com/)
- [OWASP WebGoat](https://owasp.org/www-project-webgoat/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for:
- Additional tools
- Lab exercises
- Documentation improvements
- Bug fixes

## 📄 License

This project is licensed under the terms specified in the LICENSE file.

## ⚖️ Legal Disclaimer

This Docker environment and its tools are provided for educational purposes only. Users must:

1. Comply with all applicable laws and regulations
2. Obtain proper authorization before testing any systems
3. Use tools responsibly and ethically
4. Understand that unauthorized access is illegal and punishable by law

The authors and contributors are not responsible for any misuse of this environment or its tools.

## 🎯 Course Integration

### Sample Syllabus Topics

This environment supports teaching:

1. **Network Security**
   - Port scanning and enumeration
   - Network traffic analysis
   - Firewall and IDS testing

2. **Web Application Security**
   - SQL injection
   - Cross-site scripting (XSS)
   - Directory traversal
   - Authentication bypass

3. **Cryptography**
   - Password cracking techniques
   - Hash analysis
   - Encryption/decryption

4. **Wireless Security**
   - WiFi security protocols
   - Wireless network analysis

5. **Exploitation & Post-Exploitation**
   - Vulnerability exploitation
   - Privilege escalation
   - Maintaining access

6. **Digital Forensics**
   - File analysis
   - Steganography
   - Data recovery

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check existing documentation
- Review Docker and Kali Linux official docs

---

**Remember**: With great power comes great responsibility. Use these tools ethically and legally! 🛡️
