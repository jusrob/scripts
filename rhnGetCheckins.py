#!/usr/bin/python
import xmlrpclib
from operator import itemgetter

saturl = "http://xmlrpc.rhn.redhat.com/rpc/api"
username = "username"
password = "password"

client = xmlrpclib.Server(saturl, verbose=0)
sessionKey = client.auth.login(username, password)

systemList = sorted(client.system.listUserSystems(sessionKey), key=itemgetter('last_checkin'), reverse=True)
count = 1
for system in systemList:
    print "ID: %s  Profile: %-40s  Last Checkin: %s" % (system['id'], system['name'], system['last_checkin'])
    count += 1
    if count > 20: break

client.auth.logout(sessionKey)
