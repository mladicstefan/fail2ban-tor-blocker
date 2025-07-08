# Fail2Ban Tor Blocker

Automatically blocks Tor exit nodes using **Fail2Ban** and **UFW** firewall.

---

## Features

* Downloads current Tor exit node list every 6 hours
* Integrates with Fail2Ban for consistent blocking
* Automatic logging and monitoring
* Progressive ban times for repeat offenders
* Easy manual installation

---

## Requirements

* Ubuntu/Debian Linux
* Fail2Ban installed

  ```bash
  sudo apt install fail2ban -y
  ```
* UFW firewall enabled
* Root/sudo access

---

## Installation

### Step 1: Create Tor Filter

Create the filter file:

```bash
sudo nano /etc/fail2ban/filter.d/tor.conf
```

Paste the following content:

```ini
[Definition]
# Filter for Tor exit nodes
failregex = ^.*TOR_EXIT_NODE.*<HOST>.*$
ignoreregex =
```

---

### Step 2: Add Tor Jail to Fail2Ban

Edit your jail configuration:

```bash
sudo nano /etc/fail2ban/jail.local
```

Add this section:

```ini
# Tor Exit Node Blocking
[tor]
enabled = true
bantime = 24h
action = ufw
filter = tor
logpath = /var/log/tor-blocker.log
maxretry = 1
findtime = 1h
```

---

### Step 3: Download Tor Blocking Script

Place the script inside:

```
/usr/local/bin/update-tor-blocks.sh
```

Then run it once manually after setup.

---

### Step 4: Set Up Script and Permissions

Make the script executable:

```bash
sudo chmod +x /usr/local/bin/update-tor-blocks.sh
```

Create the log file:

```bash
sudo touch /var/log/tor-blocker.log
```

---

### Step 5: Restart Fail2Ban

Restart Fail2Ban to apply changes:

```bash
sudo systemctl restart fail2ban
```

---

### Step 6: Set Up Cron Job

Open root crontab:

```bash
sudo crontab -e
```

Add this line to run every 6 hours:

```bash
0 */6 * * * /usr/local/bin/update-tor-blocks.sh
```

---

### Step 7: Run Initial Blocking
this might take a while
Run the script manually:

```bash
sudo /usr/local/bin/update-tor-blocks.sh
```

---

## Verification

```bash
# Check tor jail status
sudo fail2ban-client status tor

# Check all active jails
sudo fail2ban-client status

# View logs
sudo tail -f /var/log/tor-blocker.log

```

---

## Usage

### Manual Commands

* Check tor jail status:

  ```bash
  sudo fail2ban-client status tor
  ```
* View logs:

  ```bash
  sudo tail -f /var/log/tor-blocker.log
  ```
* Run manually:

  ```bash
  sudo /usr/local/bin/update-tor-blocks.sh
  ```
* Unban a specific IP:

  ```bash
  sudo fail2ban-client set tor unbanip IP_ADDRESS
  ```
* Unban all:

  ```bash
  sudo fail2ban-client unban --all
  ```

---

## Troubleshooting

### Common Issues

* **"Jail 'tor' does not exist"**:
  Restart Fail2Ban:

  ```bash
  sudo systemctl restart fail2ban
  ```

* **Script fails to download**:
  Check internet and firewall.

* **No IPs being blocked**:
  Ensure filter file and jail are correctly configured or check tor uptime.

* **Permission denied**:
  Make script executable:

  ```bash
  sudo chmod +x /usr/local/bin/update-tor-blocks.sh
  ```

### Logs to Check

* `/var/log/tor-blocker.log`
* `/var/log/fail2ban.log`
* `/var/log/syslog`

---

## Uninstallation

1. Remove cron job:

   ```bash
   sudo crontab -e
   ```

   Delete the line containing:

   ```bash
   /usr/local/bin/update-tor-blocks.sh
   ```

2. Remove script:

   ```bash
   sudo rm /usr/local/bin/update-tor-blocks.sh
   ```

3. Remove filter:

   ```bash
   sudo rm /etc/fail2ban/filter.d/tor.conf
   ```

4. Edit jail.local and delete the `[tor]` section:

   ```bash
   sudo nano /etc/fail2ban/jail.local
   ```

5. Restart Fail2Ban:

   ```bash
   sudo systemctl restart fail2ban
   ```

6. Delete log:

   ```bash
   sudo rm /var/log/tor-blocker.log
   ```

---

## How It Works

1. **Download**: Fetches current Tor exit node list from `https://check.torproject.org/torbulkexitlist`
2. **Validate**: Confirms IP format
3. **Block**: Adds to Fail2Ban jail
4. **Log**: All actions logged to `/var/log/tor-blocker.log`
5. **Schedule**: Cron job updates every 6 hours

---

## Security Benefits

* Blocks anonymized attacks via Tor
* Prevents scraping/spam
* Maintains updated block list
* Integrates with existing Fail2Ban + UFW setup

---

## License

MIT License — free to use, modify, and distribute.
4. Test thoroughly
5. Submit a pull request

---

Let me know if you want this turned into a downloadable `.md` file.
