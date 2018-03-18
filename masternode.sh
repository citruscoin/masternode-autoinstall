#!/bin/bash
# install
clear
echo "*********** Welcome to the CitrusCash (CITR) Masternode Setup Script ***********"
echo 'This script will install all required updates & package for Ubuntu 16.04 !'
echo '****************************************************************************'
sleep 3
echo '*** Step 1/3 ***'
echo '*** Installing packages & copying Force wallet ***'
sleep 2
sudo add-apt-repository ppa:bitcoin/bitcoin -y
apt-get install \
  build-essential libtool \
  autotools-dev automake \
  pkg-config libssl-dev \
  libevent-dev bsdmainutils \
  libboost-all-dev libminiupnpc-dev \
  libzmq3-dev libqrencode-dev \
  libdb4.8-dev libdb4.8++-dev \
  git python-virtualenv -y

# install Citrus core
wget https://github.com/citruscoin/Citrus/releases/download/1.0.3.1/Ubuntu.v.1.0.3.1.tar.gz
tar xvzf Ubuntu.v.1.0.3.1.tar.gz
cp -R usr/* /usr/
rm -R Ubuntu.v.1.0.3.1.tar.gz usr
sleep 3
echo '*** Step 2/3 ***'
echo '*** Coinfig daemon ***'
sleep 2
echo -n "RPC User:"
read user
echo -n "RPC Password:"
read password
echo -n "Masternode genkey: "
read mngenkey
echo -n "VPS IP (only x.x.x.x no port): "
read ipaddress
mkdir -p ~/.citruscore/
echo -e "rpcuser=$user \nrpcpassword=$password \nrpcport=3132 \nrpcallowip=127.0.0.1 \nserver=1 \ndaemon=1 \nstaking=0 \nmasternode=1 \nmasternodeprivkey=$mngenkey \nexternalip=$ipaddress:11112 \n" > ~/.citruscore/citrus.conf
sleep 3
echo '*** Step 3/4 ***'
echo '*** Start daemon ***'
sleep 2
citrusd -reindex=1
sleep 3
echo '*** Step 4/4 ***'
echo '*** Setings Sentinel ***'
sleep 2
cd ~ && git clone https://github.com/citruscoin/Sentinel.git
cd Sentinel  && export LC_ALL=C && virtualenv ./venv && ./venv/bin/pip install -r requirements.txt
sleep 2
echo "** sync **"
echo '****************************************************************************'
sleep 60
echo "** add crontab **"
echo '****************************************************************************'
echo '* * * * * cd /root/Sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1'
sleep 2
echo 'done'
