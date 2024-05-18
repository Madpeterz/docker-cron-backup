# mysql-cron-backup

Run mysqldump to backup your databases periodically using the cron task manager in the container. Your backups are saved in `/backup`. You can mount any directory of your host or a docker volumes in /backup. Othwerwise, a docker volume is created in the default location.

## Usage:

```bash
```

## Variables
- `CRON_TIME`: The interval of cron job to run mysqldump. `0 3 * * sun` by default, which is every Sunday at 03:00. It uses UTC timezone.
- `MAX_BACKUPS`: The number of backups to keep. When reaching the limit, the old backup will be discarded. No limit by default.
- `INIT_BACKUP`: If set, create a backup when the container starts.
- `INIT_RESTORE_LATEST`: If set, restores latest backup.
- `TIMEOUT`: Wait a given number of seconds for the database to be ready and make the first backup, `10s` by default. After that time, the initial attempt for backup gives up and only the Cron job will try to make a backup.
- `GZIP_LEVEL`: Specify the level of gzip compression from 1 (quickest, least compressed) to 9 (slowest, most compressed), default is 6.
- `TZ`: Specify TIMEZONE in Container. E.g. "Europe/Berlin". Default is UTC.

If you want to make this image the perfect companion of your MySQL container, use [docker-compose](https://docs.docker.com/compose/). You can add more services that will be able to connect to the MySQL image using the name `my_mariadb`, note that you only expose the port `3306` internally to the servers and not to the host:

```yaml
version: "2"
services:
  docker-cron-backup:
    image: fradelg/docker-cron-backup
    volumes:
      - type: bind
       source: /backupsourceonhost
       target: /backupsourcedonotchange
      - type: bind
       source: /backuptargetonhost
       target: /backuptargetdonotchange
    environment:
      - MAX_BACKUPS=5
      - INIT_BACKUP=0
      - CRON_TIME=0 3 * * *
      - GZIP_LEVEL=9
    restart: unless-stopped

volumes:
  data:
```
