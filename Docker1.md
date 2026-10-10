# Docker Series — Episode 1
## Docker Installation, Essential Commands, and Your First Container

**Level:** Beginner  
**Format:** Hands-on terminal practice  
**Goal:** Install Docker, verify the installation, run an Nginx web server, inspect containers, view logs, and clean up resources.

> **Before you start:** These installation steps are for Ubuntu Linux. If Docker is already installed, skip to [Installation Checks](#3-installation-checks).

---

## 1. What We’ll Do in This Episode

By the end of this lesson, you will know how to:

- Install Docker Engine and the Docker Compose plugin on Ubuntu.
- Check Docker, Compose, and Buildx versions.
- Run your first container with `hello-world`.
- Start and stop a container.
- Run an Nginx web server and open it in a browser.
- Inspect containers, view logs, and open a shell inside a container.
- Remove containers and clean up unused Docker resources safely.

## 2. Install Docker on Ubuntu

We’ll use Docker’s **official APT repository**.

### Step 1 — Update package lists

```bash
sudo apt-get update
```

### Step 2 — Install required packages

```bash
sudo apt-get install -y ca-certificates curl
```

### Step 3 — Create the APT keyring directory

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

### Step 4 — Download Docker’s official signing key

```bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc
```

### Step 5 — Add Docker’s official repository

```bash
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

### Step 6 — Update package lists again

```bash
sudo apt-get update
```

### Step 7 — Install Docker Engine and plugins

```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin
```

### Step 8 — Check the Docker service

On a standard Ubuntu installation that uses systemd:

```bash
sudo systemctl status docker
```

Press `q` to exit the status screen.

If the service is not running, try:

```bash
sudo systemctl start docker
```

> **WSL note:** If you’re using Ubuntu inside WSL, `systemctl` may not be available or Docker may be managed differently. Follow the setup for your particular WSL/Docker environment instead of assuming the standard systemd steps will work.

### Step 9 — Run the test container

```bash
sudo docker run hello-world
```

If Docker is working, it downloads the small `hello-world` image if needed, runs a container, and prints a confirmation message.

**Official guide:** [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

---

## 3. Installation Checks

Run these commands to verify the installation.

```bash
# Docker CLI version
docker --version

# Docker client and server/engine details
docker version

# Docker Engine information
docker info

# Docker Compose plugin version
docker compose version

# Docker Buildx version
docker buildx version
```

If a command returns a permission error, try it with `sudo` while you troubleshoot:

```bash
sudo docker info
```

You can optionally configure non-root Docker access using Docker’s official post-installation instructions. Be aware that membership in the `docker` group grants root-level privileges.

**Official guide:** [Docker post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/)

---

## 4. Your First Container — Hello World

```bash
# Run the test container
docker run hello-world

# Show running containers
docker ps

# Show all containers, including stopped ones
docker ps -a

# List local images
docker image ls
```

### What’s the difference between an image and a container?

- **Image:** The packaged template Docker uses to create a container.
- **Container:** A running or stopped instance created from an image.

The `hello-world` container exits after printing its message, so it may appear in `docker ps -a` rather than `docker ps`.

---

## 5. Run an Nginx Web Server

Nginx is a web server. We’ll run it in the background and expose it on port `8080` on our computer.

```bash
docker run -d -p 8080:80 --name myweb nginx
```

**Command breakdown:**

- `docker run` — create and start a container.
- `-d` — run it in the background.
- `-p 8080:80` — map host port `8080` to container port `80`.
- `--name myweb` — give the container the name `myweb`.
- `nginx` — use the Nginx image.

Check the container:

```bash
docker ps
```

Open this address in your browser:

**http://localhost:8080**

You should see the Nginx welcome page.

### Stop and start the container

```bash
# Stop the container
docker stop myweb

# Start the existing container again
docker start myweb

# Show running containers
docker ps
```

Stopping a container does not delete it. Starting it again reuses the existing container.

### Remove the container when you’re finished

```bash
docker rm -f myweb
```

This force-removes the container named `myweb`, stopping it first if necessary. The Nginx image remains on your computer.

---

## 6. Container Inspection Commands

Run these while the `myweb` container exists.

```bash
# Show running containers
docker ps

# Show running and stopped containers
docker ps -a

# Show live resource usage
docker stats myweb

# Show processes running inside the container
docker top myweb

# Show detailed configuration and state
docker inspect myweb
```

`docker stats` updates continuously. Press `Ctrl+C` to stop watching.

> If you already removed `myweb`, start it again using the Nginx command in Section 5 before running these examples.

---

## 7. View Container Logs

```bash
# Display available logs
docker logs myweb

# Follow new log output
docker logs -f myweb

# Include timestamps
docker logs -t myweb

# Show only the most recent 50 lines
docker logs --tail 50 myweb
```

Press `Ctrl+C` to stop following logs. This stops the log display, not the container.

You may not see much output until requests reach the web server. Open `http://localhost:8080` and refresh the page, then check the logs again.

---

## 8. Open a Shell Inside the Container

Use `sh` because it is available in many minimal container images, including common Nginx images.

```bash
docker exec -it myweb sh
```

Once inside the container, run:

```sh
# Display the container OS information
cat /etc/os-release

# Check the current directory
pwd

# List files
ls
```

Exit the container shell with:

```sh
exit
```

`docker exec` runs a command inside an **already running** container. It does not create a new container.

---

## 9. Image Management

```bash
# List local images
docker image ls

# Download the Alpine-based Nginx image
docker pull nginx:alpine

# Inspect image details
docker image inspect nginx:alpine
```

The tag `nginx:alpine` selects an Nginx image based on Alpine Linux. It is a separate image tag from `nginx`.

### Run the Alpine image on another port

If `myweb` is still using port `8080`, use port `8081` for this example:

```bash
docker run -d -p 8081:80 --name myweb-alpine nginx:alpine
```

Open **http://localhost:8081** to test it.

Remove this example container when finished:

```bash
docker rm -f myweb-alpine
```

### Remove an image

First, remove any containers that use the image. Then remove the image by name and tag:

```bash
docker image rm nginx:alpine
```

Docker will refuse to remove an image if a container still depends on it. Do not remove images you still need for other projects.

---

## 10. Cleanup Commands

These commands remove Docker resources. Read each command before running it.

```bash
# Remove stopped containers (asks for confirmation)
docker container prune

# Remove dangling images
docker image prune

# Remove all images not used by existing containers
docker image prune -a

# Remove unused networks
docker network prune

# Show Docker disk usage
docker system df

# Remove unused containers, networks, dangling images, and build cache
docker system prune
```

### Important cleanup warning

- `docker container prune` removes **all stopped containers**, not just the one from this lesson.
- `docker image prune -a` can remove images you may want to reuse later. They can usually be downloaded again, but that takes time and bandwidth.
- `docker system prune` removes unused resources. Review the confirmation prompt carefully.
- Avoid adding `-a` or `--volumes` to cleanup commands unless you understand the impact. Volumes may contain persistent application data.

If your goal is only to remove the demo container, use the targeted command instead:

```bash
docker rm -f myweb
```

---

## 11. Quick Command Cheat Sheet

| Task | Command |
|---|---|
| Check Docker version | `docker --version` |
| Show running containers | `docker ps` |
| Show all containers | `docker ps -a` |
| List images | `docker image ls` |
| Run Nginx | `docker run -d -p 8080:80 --name myweb nginx` |
| Stop a container | `docker stop myweb` |
| Start a container | `docker start myweb` |
| View logs | `docker logs myweb` |
| Follow logs | `docker logs -f myweb` |
| Open a shell | `docker exec -it myweb sh` |
| Remove a container | `docker rm -f myweb` |
| Check disk usage | `docker system df` |

---

## 12. Practice Tasks

Try these without copying the commands immediately:

1. Run `hello-world` and find its stopped container in `docker ps -a`.
2. Run Nginx on port `8080` and open it in your browser.
3. Stop `myweb`, confirm it no longer appears in `docker ps`, then start it again.
4. View the container logs after refreshing the Nginx page.
5. Open a shell inside the container and inspect `/etc/os-release`.
6. Remove the demo container and verify that it no longer appears in `docker ps -a`.

### Troubleshooting hints

- **“Name already in use”:** A container with that name already exists. Check `docker ps -a`, then start or remove the existing container.
- **“Port is already allocated”:** Another process or container is using that host port. Choose another host port, such as `8081`.
- **Permission denied:** Try `sudo docker ...` while checking your Docker permissions.
- **Browser cannot connect:** Confirm the container is running with `docker ps` and check its logs with `docker logs myweb`.

---

## Next Episode

**Episode 2: Docker Images, Dockerfiles, and Building Your Own Image**

We’ll move from running existing images to creating a custom image for an application.

---

## References

- [Install Docker Engine on Ubuntu — Docker Docs](https://docs.docker.com/engine/install/ubuntu/)
- [Docker post-installation steps for Linux — Docker Docs](https://docs.docker.com/engine/install/linux-postinstall/)
- [Docker CLI reference](https://docs.docker.com/reference/cli/docker/)
