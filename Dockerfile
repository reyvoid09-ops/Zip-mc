FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Update dan install kebutuhan dasar + Desktop Environment (XFCE4) + VNC/noVNC
RUN apt update -y && apt install --no-install-recommends -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    novnc \
    websockify \
    sudo \
    xterm \
    init \
    vim \
    net-tools \
    curl \
    wget \
    git \
    tzdata \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    x11-apps \
    xubuntu-icon-theme \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Google Chrome (Menggunakan repositori resmi Google)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt update -y \
    && apt install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# 3. Setup Xauthority untuk X11
RUN touch /root/.Xauthority

# Port untuk VNC (5901) dan noVNC Web (6080)
EXPOSE 5901
EXPOSE 6080

# 4. Script Startup (Memperbaiki error tanda kutip di OpenSSL dan menjalankan servis)
CMD ["bash", "-c", "vncserver -localhost no -SecurityTypes None -geometry 1280x720 --I-KNOW-THIS-IS-INSECURE && openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && tail -f /dev/null"]
