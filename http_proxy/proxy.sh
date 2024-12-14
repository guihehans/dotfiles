#!/bin/sh
export hostip=$(ip route | grep default | awk '{print $3}')
export hostport=10809
wslip=$(hostname -I | awk '{print $1}')
httpport=10809
socketport=10808

PROXY_HTTP="http://${hostip}:${httpport}"
PROXY_SOCK5="SOCKS5://${hostip}:${socketport}"

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

test_setting(){
    echo "Host ip:" ${hostip}
    echo "WSL ip:" ${wslip}
    echo "Current proxy:" $https_proxy
}

if [ "$1" = "set" ]
then
    set_proxy

elif [ "$1" = "unset" ]
then
    unset_proxy

elif [ "$1" = "test" ]
then
    test_setting
else
    echo "Unsupported arguments."
fi
