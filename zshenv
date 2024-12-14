export no_proxy="localhost,127.0.0.1,.hpeswlab.net,*.softwaregrp.net,kubernetes.docker.internal,*.swinfra.net,cnhgui01.microfocus.com"
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/
export CATALINA_HOME=/opt/apache-tomcat/
export MAAS_HOME=$HOME/maas
export PERSONAL=$HOME/code/personal
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1
export SCREENDIR=$HOME/.screen
export PATH=$PATH:/usr/local/go/bin
export MAVEN_OPTS="-Xmx4096m"

export hostip=$(ip route | grep default | awk '{print $3}')
export hostport=10809
wslip=$(hostname -I | awk '{print $1}')
httpport=10809
socketport=10808

PROXY_HTTP="http://${hostip}:${httpport}"
PROXY_SOCK5="SOCKS5://${hostip}:${socketport}"
company_proxy="http://web-proxy.sg.softwaregrp.net:8080"

set_proxy(){
    export http_proxy="${PROXY_HTTP}"
    export HTTP_PROXY="${PROXY_HTTP}"

    export https_proxy="${PROXY_HTTP}"
    export HTTPS_PROXY="${PROXY_HTTP}"
    export no_proxy="localhost,127.0.0.1,*.docker.internal,ingress.local"
    export NO_PROXY="localhost,127.0.0.1,*.docker.internal,ingress.local"
    export all_proxy="http://${hostip}:${hostport}";
    git config --global http.proxy "${PROXY_HTTP}"
    git config --global https.proxy "${PROXY_HTTP}"

    echo -e "Acquire::http::Proxy \"http://${hostip}:${hostport}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf > /dev/null;
    echo -e "Acquire::https::Proxy \"http://${hostip}:${hostport}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf > /dev/null;
}

unset_proxy(){
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset no_proxy
    unset NO_PROXY
    unset all_proxy;
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    sudo sed -i -e '/Acquire::http::Proxy/d' /etc/apt/apt.conf.d/proxy.conf;
    sudo sed -i -e '/Acquire::https::Proxy/d' /etc/apt/apt.conf.d/proxy.conf;
}
