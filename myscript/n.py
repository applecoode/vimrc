import configparser
cf = configparser.ConfigParser()
cf.read('office_config.ini')
print(cf.get('db','user'))
