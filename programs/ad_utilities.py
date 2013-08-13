#!/usr/bin/python
"""
A utility version of the ad extract that will output all the active AD users or 
all users that have all locations

ad_utilites.py activead: outputs all active AD users
ad_utilites.py alloc: outputs all AD users that have all locations column set to true
"""

import sys, getopt, datetime, MySQLdb
import ldap
import os
from local_credentials import ldap_creds
from local_credentials import mysql_creds
from ldap.controls import SimplePagedResultsControl
from warnings import filterwarnings

filterwarnings('ignore', category = MySQLdb.Warning);

url = "ldap://activedirectory.stonemor.com:389/"
base = "dc=stonemor,dc=com"
search_filter = '(&(objectClass=User)(objectCategory=Person)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))'
page_size = 100
options = ""

"""
Make database connection
"""
def getDbConnection(credentials):
    try:
        db = MySQLdb.connect(credentials['host'],
                             credentials['user'],
                             credentials['passwd'],
                             credentials['db']
                             )
    except:
        print "MySQL connect error: ", sys.exc_info()[0]
        sys.exit(2)

    return db


"""
Searches active directory based on a given filter and pages the resuls
"""
def searchAD(url, base, credentials, page_size, search_filter):
    global l
    global lc
    global enable_set
    global disable_set

    try:

        ldap.set_option(ldap.OPT_REFERRALS, 0)
        l = ldap.initialize(url)
        l.protocol_version = 3
        l.simple_bind_s(credentials['user'], credentials['passwd'])

        lc = SimplePagedResultsControl(
          ldap.LDAP_CONTROL_PAGE_OID,True,(page_size,'')
        )

        # Send search request
        ad_results = l.search_ext(
          base,
          ldap.SCOPE_SUBTREE,
          search_filter,
          serverctrls=[lc]
        )
        return ad_results
    except:
        print "Unexpected Error: ", sys.exc_info()[0]
        sys.exit(2)

def memberInHomeOffice(distinguished_name):
    inHomeOffice = False

    for name in distinguished_name:
        if "OU=Bristol Office" in name or "OU=Home Office" in name:
            inHomeOffice = True
    
    return inHomeOffice

"""
Will insert or add active directory users in AD
"""
def pageThruAD(ad_results, search_filter, db):
    pages = 0
    records = 0
    disabled_users = 0
    users = []
    all_locations_users = []
    cursor = db.cursor();
    output_users = False

    while True:
        pages += 1
        rtype, rdata, rmsgid, serverctrls = l.result3(ad_results)

        ctr = 0
        out_rec = []
        name = ''
        user = ''
        mail = ''
        sguid = ''

        for rec in rdata:
            rec_dict = rec[1]
            if isinstance(rec_dict, dict):

                if rec_dict.has_key("cn"):
                    user = rec_dict["cn"]
                    users.append(user[0])
                else:
                    user = [' ']
                if rec_dict.has_key("displayName"):
                    name =  rec_dict['displayName']
                else:
                    name = [' ']
                if rec_dict.has_key("mail"):
                    mail = rec_dict['mail']
                else:
                    mail = [' ']

                bguid = rec_dict['objectGUID']
                sguid = str(bguid)
                hguid = ''.join(['%x' % ord(x) for x in bguid[0]]) 

                if rec_dict.has_key('userAccountControl'):
                    account_control = rec_dict['userAccountControl']

                out_rec = [hguid, user[0], name[0], mail[0], account_control[0]]

                #  set all_location flag to on for all home office users
                #  OU=Bristol Office or OU=Home Office
                if rec_dict.has_key("distinguishedName"):
                    if memberInHomeOffice(rec_dict["distnguishedName"]):
                        all_locations_users.append(user[0])
                        all_locations = 1
                    else:
                        all_locations = 0

                sguid = ''
                curr_ts = datetime.datetime.now()
                str_curr_ts = curr_ts.date().isoformat()
                records = records + 1

        pctrls = [
          c
          for c in serverctrls
          if c.controlType == ldap.LDAP_CONTROL_PAGE_OID
        ]

        if pctrls:
            est, cookie = pctrls[0].controlValue
            if cookie:
                lc.controlValue = (page_size, cookie)
                ad_results = l.search_ext(base, ldap.SCOPE_SUBTREE, search_filter,
                                     serverctrls=[lc])
            else:
                break
        else:
            print "Warning:  Server ignores RFC 2696 control."
            break

    print ""
    print "Total Records returned: ", records
    print "Total Pages: ", pages
    print ""
    if  sys.argv[1] == "activead":
        print "All Active AD Users\n"
        print "\n".join(users)
    elif sys.argv[1] == "alllocs":
        print "All Users that have All Locations\n"
        print "\n".join(all_locations_users)

##### MAIN ######
results = searchAD(url, base, ldap_creds, page_size, search_filter)
db = getDbConnection(mysql_creds)
pageThruAD(results, search_filter, db)

