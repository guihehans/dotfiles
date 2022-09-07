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

hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
httpport=10809
socketport=10808
PROXY_HTTP="http://${hostip}:${httpport}"
PROXY_SOCK5="SOCKS5://${hostip}:${socketport}"
company_proxy="http://web-proxy.sg.softwaregrp.net:8080"

set_http_proxy() {

  if [ "$NAME" != "guihehans-desktop" ]; then
    http_proxy="$company_proxy"
    https_proxy="$company_proxy"
  else
    http_proxy="$PROXY_HTTP"
    https_proxy="$PROXY_HTTP"
  fi

  export http_proxy=$http_proxy
  export HTTP_PROXY=$http_proxy
  export https_proxy=$https_proxy
  export HTTPS_PROXY=$https_proxy
  
}

kill_http_proxy() {
  rm $HOME/.proxyrc
  unset_http_proxy
}

unset_http_proxy() {
  unset http_proxy
  unset HTTP_PROXY
  unset https_proxy
  unset HTTPS_PROXY
}

# set the proxy
set_http_proxy