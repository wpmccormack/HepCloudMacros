import sys
filename = sys.argv[1]

file1 = open(filename, 'r')
Lines = file1.readlines()

for line in Lines:
    if "Begin processing the 2nd record" in line:
        splitStLine = str.split(line)
        stTime = splitStLine[-2]
    if "Begin processing the 9000th record" in line:
        splitEndLine = str.split(line)
        endTime = splitEndLine[-2]
    #if "cmsRun" in line:
        #print(line[:len(line)-1])

def timediff(str1, str2):
    splot = str.split(str1, ":")
    splot2 = str.split(str2, ":")
    if((float(splot[0]) - float(splot2[0])) >= 0.):
        hrdiff = (float(splot[0]) - float(splot2[0]))*3600.
    else:
        hrdiff = (24 + float(splot[0]) - float(splot2[0]))*3600.
    mindiff = (float(splot[1]) - float(splot2[1]))*60.
    secdiff = (float(splot[2]) - float(splot2[2]))
    print(hrdiff+mindiff+secdiff)

#print(filename[:len(filename)-6])
#file2 = open(filename[:len(filename)-6]+'log', 'r')
#Lines2 = file2.readlines()
#for line in Lines2:
    #if ("Cpus" in line) and (":" in line):
        #print(str.split(line)[2])

#print(stTime)
#print(endTime)

timediff(endTime, stTime)
