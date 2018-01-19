FROM base/archlinux:latest

MAINTAINER nickt <n.e.travers@gmail.com>

# ----------------------
# Install deps
# ----------------------

RUN echo '[archlinuxfr]' >> /etc/pacman.conf && \
  echo 'SigLevel = Never' >> /etc/pacman.conf && \
  echo 'Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf

RUN pacman -Syu --noc base-devel yaourt

RUN rm -rf /var/cache/pacman/pkg/*

# ----------------------
# Setup user account
# ----------------------

RUN useradd -ms /bin/bash nickt
RUN echo "nickt ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER nickt
WORKDIR /home/nickt

# ----------------------
# Setup VNC
# ----------------------

RUN mkdir /home/nickt/.vnc && \
  echo "xrdb ~/.Xresources" > /home/nickt/.vnc/xstartup && \
  echo "i3" >> /home/nickt/.vnc/xstartup && \
  sudo bash -c "echo \"killall Xvnc 2> /dev/null\" > /usr/bin/startx" && \
  sudo bash -c "echo \"rm -rf /tmp/.* 2> /dev/null\" >> /usr/bin/startx" && \
  sudo bash -c "echo \"vncserver :0 -depth 16 -name arch -SecurityTypes None\" >> /usr/bin/startx" && \
  sudo bash -c "echo \"sed -n 8,11p ~/.vnc/*.log\" >> /usr/bin/startx" && \
  sudo chmod +x /home/nickt/.vnc/xstartup /usr/bin/startx


## ----------------------
## Install user deps
## ----------------------

ENV TERM xterm
RUN PATH=/usr/bin/core_perl:$PATH yaourt -Sy --noconfirm \
  base-devel \
  bdf-tewi-git \
  chromium \
  htop \
  i3-gaps \
  i3status \
  lemonbar-git \
  man \
  net-tools \
  openssh \
  polybar \
  rxvt-unicode \
  tigervnc \
  ttf-dejavu \
  ttf-font-awesome \
  ttf-iosevka \
  ttf-material-icons \
  urxvtcd \
  vim \
  xorg-xrdb

RUN echo "alias pacman='pacman --noconfirm'" >> /home/nickt/.bashrc
RUN echo "alias yaourt='yaourt --noconfirm'" >> /home/nickt/.bashrc

## ----------------------
## Add files
## ----------------------

COPY .config /home/nickt/.config
COPY .Xresources /home/nickt/.Xresources
COPY .colors /home/nickt/.colors
COPY .fonts /home/nickt/.fonts

#RUN sudo chown -R nickt:nickt /home/nickt
#RUN sudo chown nickt:nickt /usr/bin/i3status

## ----------------------
## Container metadata
## ----------------------

EXPOSE 5900
CMD ["/bin/bash"]
