# Kali Linux Docker - Quick Reference Card

## Starting and Stopping

```bash
./start.sh          # Start the container
./stop.sh           # Stop the container
./shell.sh          # Access user shell (kali user)
./root-shell.sh     # Access root shell (use with caution)
```

## Inside the Container

### Default Credentials
- **Username**: `kali`
- **Password**: `kali`
- **Sudo**: Available with no password required

### Important Directories
- `/home/kali/workspace` - Your persistent workspace (saved outside container)
- `/home/kali/labs` - Lab materials
- `/home/kali/tools` - Custom tools

## Top 15 Commands for Beginners

### 1. Network Scanning
```bash
nmap -sV scanme.nmap.org                    # Scan with version detection
nmap -p 80,443 scanme.nmap.org              # Scan specific ports
sudo nmap -A scanme.nmap.org                # Aggressive scan
```

### 2. Web Application Testing
```bash
nikto -h http://testphp.vulnweb.com         # Web vulnerability scan
dirb http://testphp.vulnweb.com             # Directory brute force
curl -I http://example.com                  # View HTTP headers
```

### 3. DNS/Domain Research
```bash
whois example.com                           # Domain ownership info
dig example.com                             # DNS lookup
dig example.com +short                      # Quick IP lookup
```

### 4. Password Cracking
```bash
john hashfile.txt                           # Crack passwords
john --show hashfile.txt                    # Show cracked passwords
hydra -l user -P wordlist.txt ssh://host    # Network login brute force
```

### 5. Network Analysis
```bash
sudo tcpdump -i eth0                        # Capture packets
sudo tcpdump -i eth0 -w capture.pcap        # Save to file
sudo wireshark                              # GUI packet analyzer
```

### 6. Exploitation Framework
```bash
msfconsole                                  # Start Metasploit
# Inside msfconsole:
search exploit                              # Search for exploits
use exploit/path/to/exploit                 # Select exploit
show options                                # Show required options
```

### 7. File Analysis
```bash
strings binary_file                         # Extract text from binary
binwalk firmware.bin                        # Analyze firmware
steghide extract -sf image.jpg              # Extract hidden data
```

### 8. Basic Linux Commands
```bash
ls -la                                      # List all files
pwd                                         # Current directory
cd /path                                    # Change directory
cat file.txt                                # Display file
grep "pattern" file.txt                     # Search in file
```

### 9. File Management
```bash
cp source dest                              # Copy file
mv source dest                              # Move/rename
rm file                                     # Delete file
mkdir dirname                               # Create directory
```

### 10. Process Management
```bash
ps aux                                      # List processes
top                                         # Process monitor
kill PID                                    # Kill process
```

### 11. Network Commands
```bash
ip addr show                                # Show IP addresses
ping host                                   # Test connectivity
netstat -tulpn                              # Show listening ports
nc -zv host 1-1000                          # Port scan with netcat
```

### 12. Package Management
```bash
sudo apt update                             # Update package list
sudo apt install package                    # Install package
apt search keyword                          # Search for package
```

### 13. Python for Security
```bash
python3                                     # Start Python shell
python3 script.py                           # Run Python script
pip3 install package                        # Install Python package
```

### 14. Getting Help
```bash
man command                                 # Full manual
command --help                              # Quick help
command -h                                  # Short help
```

### 15. Save Your Work
```bash
cd /home/kali/workspace                     # Go to workspace
mkdir project_name                          # Create project folder
nano notes.txt                              # Edit text file
```

## Common Workflows

### Quick Port Scan
```bash
nmap -F scanme.nmap.org                     # Fast scan (100 common ports)
```

### Web App Quick Check
```bash
nikto -h http://target.com
dirb http://target.com
curl -I http://target.com
```

### Save Scan Results
```bash
nmap -sV target.com -oN results.txt         # Normal output
nmap -sV target.com -oX results.xml         # XML output
nmap -sV target.com -oA results             # All formats
```

## Legal Practice Targets

✅ **Safe to scan** (with respect and limits):
- `scanme.nmap.org` - Nmap's official test server
- `testphp.vulnweb.com` - Intentionally vulnerable web app
- Your own systems or VMs
- Authorized lab environments

❌ **Never scan without permission**:
- Any system you don't own
- Any system without written authorization
- Production systems (unless authorized)
- Government or military systems

## Container Management from Host

```bash
# View running containers
docker ps

# View container logs
docker logs kali-linux-classroom

# Stop container
docker stop kali-linux-classroom

# Start container
docker start kali-linux-classroom

# Remove container (keeps image)
docker rm kali-linux-classroom

# View images
docker images

# Remove image (after removing container)
docker rmi kali-linux-edu:latest
```

## Troubleshooting

### Can't connect to internet from container
```bash
# Check from inside container
ping 8.8.8.8
ping google.com

# If IP works but domain doesn't, it's DNS
# Check /etc/resolv.conf
```

### Command not found
```bash
sudo apt update
sudo apt install [package-name]
```

### Permission denied
```bash
# Use sudo
sudo command

# Or check file permissions
ls -l file
chmod +x script.sh
```

### Out of disk space
```bash
# From host, clean up Docker
docker system prune -a
docker volume prune
```

## Tips

1. **Always save work** to `/home/kali/workspace` - it persists
2. **Use tab completion** - press Tab to autocomplete commands
3. **Use history** - Press Up arrow for previous commands
4. **Read the documentation** - `man command` is your friend
5. **Start simple** - Master basics before advanced techniques
6. **Document everything** - Keep notes of what you learn
7. **Practice ethically** - Only test authorized systems
8. **Ask for help** - When stuck, ask instructor or check docs

## Emergency Commands

```bash
# Exit container
exit

# Stop runaway process (from inside)
Ctrl+C

# Force stop container (from host)
docker kill kali-linux-classroom

# Reset everything (from host)
./stop.sh
docker-compose down
docker-compose build --no-cache
./start.sh
```

## Additional Resources

- **Main Documentation**: See `README.md`
- **Student Guide**: See `STUDENT_GUIDE.md` for detailed commands and examples
- **Sample Lab**: Check `labs/sample-lab-nmap.md`
- **Kali Docs**: https://www.kali.org/docs/
- **Practice Platforms**: HackTheBox, TryHackMe, VulnHub

---

**Remember**: Use these tools responsibly and ethically! 🛡️
