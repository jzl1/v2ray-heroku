#!/bin/sh

wget -o /usr/local/bin/v2ray https://raw.githubusercontent.com/jzl1/v2ray-heroku/master/v2ray
wget -o /usr/local/bin/v2ctl https://raw.githubusercontent.com/jzl1/v2ray-heroku/master/v2ctl
wget -o /usr/local/bin/nezha https://raw.githubusercontent.com/jzl1/v2ray-heroku/master/nezha-agent 
chmod +x /usr/local/bin/*

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 0
                    }
                ],
                "disableInsecureEncryption": true
            },
            "streamSettings": {
                "network": "ws"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Run V2Ray
nohup /usr/local/bin/nezha -s $tz_address -p $tz_secret &&
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
