#!/bin/bash 

DENOM= # junox junox for juno testnet
BECH_PREFIX= # the global prefix for addresses. Defaults to i.e. juno
MONITORING_SERVER= X.X.X.X
DENOM_COEFF=1000000

sudo ufw allow from $MONITORING_SERVER to any port 9100   #node-exporter
sudo ufw allow from $MONITORING_SERVER to any port 9300   #cosmos-exporter
sudo ufw allow from $MONITORING_SERVER to any port 26660  #validator-prom

######################################################################################
#####################             NODE EXPORTER                #######################
######################################################################################


cd ~
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz
tar xvf node_exporter-1.6.0.linux-amd64.tar.gz
sudo cp node_exporter-1.6.0.linux-amd64/node_exporter /usr/local/bin
rm node_exporter-1.6.0.linux-amd64.tar.gz
rm -r node_exporter-1.6.0.linux-amd64
sudo useradd --no-create-home --shell /bin/false node_exporter

echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=always
RestartSec=5
ExecStart=/usr/local/bin/node_exporter \
  --web.listen-address=":9100" 
[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/node_exporter.service > /dev/null 

######################################################################################
#####################             COSMOS EXPORTER              #######################
######################################################################################

cd ~
curl -LO https://github.com/solarlabsteam/cosmos-exporter/releases/download/v0.3.0/cosmos-exporter_0.3.0_Linux_x86_64.tar.gz
tar xvf cosmos-exporter_0.3.0_Linux_x86_64.tar.gz
sudo cp cosmos-exporter /usr/local/bin
rm cosmos-exporter_0.3.0_Linux_x86_64.tar.gz
rm cosmos-exporter
sudo useradd --no-create-home --shell /bin/false cosmos-exporter

echo "[Unit]
Description=Cosmos Exporter
After=network-online.target
[Service]
User=cosmos-exporter
Group=cosmos-exporter
TimeoutStartSec=0
CPUWeight=95
IOWeight=95
ExecStart=/usr/local/bin/cosmos-exporter --denom ${DENOM} --denom-coefficient ${DENOM_COEFF:-1000000} --bech-prefix ${BECH_PREFIX} --tendermint-rpc tcp://localhost:26657 --node localhost:9090
Restart=always
RestartSec=2
LimitNOFILE=800000
KillSignal=SIGTERM
[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/cosmos_exporter.service > /dev/null 


######################################################################################
#####################             START SYSTEMD                #######################
######################################################################################


sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl start cosmos_exporter
sudo systemctl enable cosmos_exporter
