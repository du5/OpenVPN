FROM debian

WORKDIR /root

RUN apt update\
    && apt install -y openssl ca-certificates openvpn openssh-server python3 python3-pip curl\
    && curl -Lk -o proxy.tar.gz https://github.com/snail007/goproxy/releases/download/v11.6/proxy-linux-amd64.tar.gz\
    && tar -zxvf proxy.tar.gz\
    && mv proxy /usr/sbin/\
    && mkdir -p /root/.ssh /run/sshd\
    && chmod 700 /root/.ssh\
    && echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEjZT6gUxxswzntTt+7MHyJVyFe8bL2AOcEC4UkmLtaRiwtuHvqCnl+//oUpBcH7zCF7gAzHoqQ10FezeKB71wGiRlapXBJej6OgwdeeM96fO6rNPeV360PRRqRkb0Iyp3RNuh1cNSO1euccQSEm18bE6zUmM2OyLYgaARpg5y5GV87uPQFOgzcUOw0KCycyoeh7voQcNDScaZdq53TUzr46lg6W0oWMPtodzRr1pwdHAmbTCC1hu2WPq5A3TJ8AmiKNaTHkJQ+dHLUcfZXj84l61MhqzTFiR5jso6FlQqPrmJT+kv2TyH93d0CfytUfsxyS2A1qulQZJuG29q2/Wt root' > /root/.ssh/authorized_keys\
    && sed -i '/PermitRootLogin /d' /etc/ssh/sshd_config\
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

COPY openvpn.ovpn vpn.pass /root/

EXPOSE 22 33080
ENTRYPOINT /usr/sbin/sshd && openvpn --config openvpn.ovpn --daemon && proxy http --nolog -p ':33080'