export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com,.hpeswlab.net,mydyumserver,mydyumserver.hpswlabs.adapps.hp.com,*.hp.com,16.59.0.0,hpswlabs.adapps.hp.com:80,*.softwaregrp.net,127.0.0.1,localhost,*.hpeswlab.net,*.hp.com,kubernetes.docker.internal,192.168.65.0/28,.swinfra.net,cnhgui01.microfocus.com"
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/
export CATALINA_HOME=/opt/apache-tomcat/
export MAAS_HOME=$HOME/maas
export PERSONAL=$HOME/code/personal
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1
export SCREENDIR=$HOME/.screen

set_http_proxy() {
  if [ -e $HOME/.proxyrc ]; then
    . $HOME/.proxyrc
  fi  

  if [ -z $http_proxy ]; then 
    echo "No proxy config, environment found, connection attempt failed."
    echo "Let's setup a config or update your password."
    http_proxy="http://web-proxy.sg.softwaregrp.net:8080"
    https_proxy="http://web-proxy.sg.softwaregrp.net:8080"
    echo "export http_proxy=$http_proxy" >> $HOME/.proxyrc
    echo "export HTTP_PROXY=$http_proxy" >> $HOME/.proxyrc
    echo "export https_proxy=$https_proxy" >> $HOME/.proxyrc
    echo "export HTTPS_PROXY=$https_proxy" >> $HOME/.proxyrc
    . $HOME/.proxyrc
  fi  
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