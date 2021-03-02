#!/usr/bin/env python3

import configparser
import sys
import requests
from decimal import Decimal

config = configparser.ConfigParser()
# File must be opened with utf-8 explicitly
with open('/home/sergioribera/.config/polybar/crypto-config', 'r', encoding='utf-8') as f:
    config.read_file(f)

# Everything except the general section
currencies = [x for x in config.sections() if x != 'general']
base_currency = config['general']['base_currency']
params = {'convert': base_currency}


for currency in currencies:
    icon = config[currency]['icon']
    json = requests.get(f'https://api.coingecko.com/api/v3/coins/{currency}',
                        params=params).json()["market_data"]
    local_price = round(
        Decimal(json['current_price'][f'{base_currency.lower()}']), 2)
    change_24 = float(json['price_change_percentage_24h'])

    display_opt = config['general']['display']
    icon_color = "%{F" + config[currency]['icon-color'] + "}"
    if display_opt == 'both' or display_opt == None:
        sys.stdout.write('{}{} {}{}/{}%   '.format(icon_color,icon,'%{F-}',local_price,change_24))
    elif display_opt == 'percentage':
        sys.stdout.write('{}{}{} {}%   '.format(icon_color,icon,'%{F-}',change_24))
    elif display_opt == 'price':
        sys.stdout.write('{}{}{}{} '.format(icon_color,icon,'%{F-}',local_price))
