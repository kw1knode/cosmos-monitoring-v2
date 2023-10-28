# COSMOS MONITORING


### Install exporters on validator node
```
wget -O install_exporters.sh https://raw.githubusercontent.com/kw1knode/cosmos-monitoring-v2/main/install_exporters.sh && chmod +x install_exporters.sh && ./install_exporters.sh
```
### Edit variables in script

```
| KEY |VALUE |
|---------------|-------------|
| **DENOM** | Denominated token name, for example, `ubld` for Agoric. You can find it in genesis file |
| **BECH_PREFIX** | Prefix for chain addresses, for example, `agoric` for Agoric. You can find it in public addresses like this **agoric**_valoper1zyyz4m9ytdf60fn9yaafx7uy7h463n7alv2ete_ |
| **DENOM_COEFF** | Prefix for chain coefficient, most cosmos chains are 1000000 |
```

Make sure prometheus is enabled in validator `config.toml` file

Make sure following ports are open:
- `9100` (node-exporter)
- `9300` (cosmos-exporter)
- `26660` (validator prometheus)

# Tenderduty https://github.com/blockpane/tenderduty

### Add various chains to `tenderduty/chains.d` folder. See osmosis-example.yml 

### Edit config.yml for what alerting you want to use (telegram, discord, pagerduty)

# Govstat https://github.com/blockpane/govstat

### Edit `govstat/chains.yml` to receive alerts on proposals for configured chains in discord

# Docker Compose 🐳

### Edit .env and set A records for `GRAFANA_HOST, TENDERDUTY_HOST`
`docker compose up -d`

### Add validator into _prometheus_ configuration file
To add validator use command with specified `VALIDATOR_IP`, `PROM_PORT`, `VALOPER_ADDRESS`, `WALLET_ADDRESS` and `PROJECT_NAME`
```
$HOME/cosmos_node_monitoring/add_validator.sh VALIDATOR_IP PROM_PORT VALOPER_ADDRESS WALLET_ADDRESS PROJECT_NAME
```

> example: ```$HOME/cosmos_node_monitoring/add_validator.sh 1.2.3.4 26660 cosmosvaloper1s9rtstp8amx9vgsekhf3rk4rdr7qvg8dlxuy8v cosmos1s9rtstp8amx9vgsekhf3rk4rdr7qvg8d6jg3tl cosmos```

`docker restart prometheus`
