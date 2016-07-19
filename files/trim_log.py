#!/usr/bin/python

__author__ = 'mdr'
# Delete old transaction logs from DB2
# original : http://pp19dd.com/2013/10/python-script-to-remove-tmp-files-older-than-7-days/

import os, sys, time, glob
from subprocess import call

def getVarFromFile(filename):
    import imp
    f = open(filename)
    global data
    data = imp.load_source('data','', f)
    f.close()

os.chdir('/root/scripts')
getVarFromFile('trim_log.conf')

# Delete everything that is older than cutoff
now = time.time()
cutoff = now - (data.days_to_keep * 86400)

# get list of files, chdir there
files = glob.glob(data.dir + '/*.LOG')
os.chdir(data.dir)
# print files

# find oldest file and get his date
if os.path.getctime(min(files, key=os.path.getctime)) > cutoff:
    print 'All files are within liferange, nothing to do here.'
    sys.exit()
else:
    for f in files:
        if os.path.isfile(f):
            # get file date
            t = os.stat(f)
            file_time = t.st_ctime

            if file_time < cutoff:
                os.remove(f)
            #    print "will delete %s" % f
            # else:
            #    print "won't delete %s" % f 
