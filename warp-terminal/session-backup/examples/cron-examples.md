# Cron Job Examples

Here are different cron job configurations for various backup frequencies:

## Standard Configurations

### Every 5 minutes (Default)
```bash
*/5 * * * * ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

### Every 10 minutes
```bash
*/10 * * * * ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

### Every 15 minutes
```bash
*/15 * * * * ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

### Every 30 minutes
```bash
*/30 * * * * ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

### Hourly (at the top of each hour)
```bash
0 * * * * ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

## Working Hours Only

### Every 5 minutes during business hours (9 AM - 6 PM, Monday-Friday)
```bash
*/5 9-18 * * 1-5 ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

### Every 15 minutes during extended hours (8 AM - 10 PM, Monday-Friday)
```bash
*/15 8-22 * * 1-5 ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

## Custom Schedules

### Every 2 minutes during active coding hours (10 AM - 8 PM, weekdays)
```bash
*/2 10-20 * * 1-5 ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

### Twice per hour during work days
```bash
0,30 9-17 * * 1-5 ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

### Daily backup at 9 AM
```bash
0 9 * * * ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

## Development Mode (High Frequency)

### Every minute (for testing or intensive development)
```bash
* * * * * ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

### Every 3 minutes during development hours
```bash
*/3 9-21 * * * ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

## Installing a Custom Schedule

To change your backup frequency:

1. Edit your crontab:
   ```bash
   crontab -e
   ```

2. Replace the existing backup line with your preferred schedule

3. Save and exit

4. Verify the change:
   ```bash
   crontab -l | grep backup_session
   ```

## Cron Time Format Reference

```
* * * * * command
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

## Special Characters

- `*` = Any value
- `,` = List separator (e.g., `1,3,5`)
- `-` = Range (e.g., `9-17`)
- `/` = Step values (e.g., `*/5` = every 5 minutes)

## Testing Your Schedule

Use these online tools to validate your cron expressions:
- https://crontab.guru/
- https://crontab.cronhub.io/
