### Description
Collect getent facts via getent

### Reqirements
getent binary

### Current collected databases (examples)
- passwd:
```yaml
getent:
  passwd:
    backup:
      comment: backup
      gid: 34
      home: "/var/backups"
      password: x
      shell: "/usr/sbin/nologin"
      uid: 34
      username: backup
```

- shadow:
```yaml
getent:
  shadow:
    backup:
      change: 19837
      expire: 0
      inactive: 7
      maximum: 99999
      minimum: 0
      password: "*"
      username: backup
```

- group:
```yaml
getent:
  group:
    backup:
      gid: 34
      members: []
      name: backup
      password: x
```

- gshadow:
```yaml
getent:
  gshadow:
    backup:
      administrators: []
      name: backup
      password: "*"
      users: []
```

- hosts:
```yaml
getent:
  hosts:
    127.0.0.1:
      - localhost
      - ip6-localhost
      - ip6-loopback
```

- aliases:
```yaml
getent:
  aliases:
    abuse:
      name: abuse
      recipients:
        - root
```