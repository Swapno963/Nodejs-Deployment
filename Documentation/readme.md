# Node.js Application Deployment Guide (DevOps)

## 1. System User and Directory Setup

### 1.1 Create a System User

For security reasons, create a non-login system user to run the Node.js application.

**Command:**

```bash
sudo useradd -r -m -d /opt/app -s /usr/sbin/nologin nodejs
```

### 1.2 Set Permissions for the Application Directory

Ensure the `nodejs` user has the correct ownership and permissions to access and run the application.

**Commands:**

```bash
sudo chown -R nodejs:nodejs /opt/app
sudo chmod -R 750 /opt/app
```

## 2. Deploy Application and Dependencies

### 2.1 Copy Project Files to `/opt/app/`

Move the necessary directories for the application, scripts, and systemd services.

**Commands:**

```bash
sudo cp -a /root/code/Application /root/code/Scripts /root/code/Systemd /opt/app
cd /opt/app
sudo chown -R nodejs:nodejs /opt/app
```

### 2.2 Ensure Scripts Have Execution Permissions

Grant execution rights to all `.sh` scripts inside `/opt/app/Scripts/`.

**Command:**

```bash
sudo chmod +x /opt/app/Scripts/*.sh
```

### 2.3 Run Dependency Setup Script

Run the script to verify and install Node.js, MySQL, and npm dependencies.

**Command:**

```bash
sudo /opt/app/Scripts/ensure_dependencies.sh
```

### 2.4 Initialize the Database

Run the script to create the `practice_app` database and insert test user data.

**Command:**

```bash
sudo /opt/app/Scripts/setup_add_data.sh
```

## 3. Configure and Enable systemd Services

### 3.1 Copy systemd Service Files

Move the MySQL and Node.js systemd unit files to `/etc/systemd/system/`.

**Commands:**

```bash
cd /opt/app/Systemd
sudo cp mysql.service node.service /etc/systemd/system/
```

### 3.2 Reload systemd to Apply Changes

**Command:**

```bash
sudo systemctl daemon-reload
```

### 3.3 Manage MySQL Service

Ensure MySQL is enabled and running.

**Commands:**

```bash
sudo systemctl enable mysql
sudo systemctl start mysql
```

### 3.4 Install Node.js Dependencies

Before starting the Node.js application, install its dependencies.

**Commands:**

```bash
cd /opt/app/Application
npm install --omit=dev
```

## 4. Start and Verify Node.js Application

### 4.1 Enable and Start Node.js Service

**Commands:**

```bash
sudo systemctl enable node
sudo systemctl start node
```

### 4.2 Verify Service Status

Check if the Node.js service is running correctly.

**Command:**

```bash
sudo systemctl status node
```

## 5. Validate Node.js Endpoints

The application exposes the following REST API endpoints:

- **Fetch all users**: `/users`

  ```bash
  curl -X GET http://localhost:3000/users
  ```
- **Health Check**: `/health`

  ```bash
  curl -X GET http://localhost:3000/health
  ```

## 6. Test Auto-Restart Functionality

### 6.1 Find Running Node.js Process

Find the process ID (PID) of the running Node.js application.

**Command:**

```bash
ps aux | grep "/Application/server.js"
```

### 6.2 Kill the Process

To check whether systemd automatically restarts the Node.js service, kill the process using its PID.

**Command:**

```bash
sudo kill -9 <PID>
```
