#!/bin/sh
mkdir /tmp/v2ray
wget -o /tmp/v2ray/v2ray https://raw.githubusercontent.com/jzl1/v2ray-heroku/master/v2ray
wget -o /tmp/v2ray/v2ctl https://raw.githubusercontent.com/jzl1/v2ray-heroku/master/v2ctl
wget -o /usr/local/bin/nezha https://raw.githubusercontent.com/jzl1/v2ray-heroku/master/nezha-agent 
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl
chmod +x /usr/local/bin/*
rm -rf /tmp/v2ray

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
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json & 
/usr/local/bin/nezha -s $tz_address -p $tz_secret
