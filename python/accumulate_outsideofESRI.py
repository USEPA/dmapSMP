# -*- coding: utf-8 -*-
"""
This code was written by Ellen D'Amico (Pegasus Technical Services, Inc c/o USEPA) under EPA Contract 68HERC20D0029, Task Order 68HERC23F0012 (TOCOR: Naomi Detenbeck, EPA Office of Research and Development)
"""

import pandas as pd
import os
import csv

#metric to be accumulated
metric = "PrecipA"

#path to relationship table from lsn that has been converted to csv file
relshpCSV = r'python/relationships2.csv'

#path to edges with metric to be accumulated (Note: these come from lsn.  Export the attribute table from lsn to csv file)
edgePath = r'python/'

#output path for accumulation tables
accumTables = r'python'

#years that need to be accumulated
    
csvfile = edgePath + 'annual_precip'+'.csv'
outTable = accumTables + '/'


#check to see if relationshipdict.csv already exists (this can take a long time the first time its run 
#but once its run it can be called and reused for all metrics in the lsn and doesn't need to be recreated.)
#Do not move this csv or it will rerun and waste time.
if  "relationshipdict.csv" not in os.listdir(accumTables):
    #import csv as pd
    df = pd.read_csv(relshpCSV)
    #get a unique list of tofeat ids
    toFeatList =list(set(df['tofeat'].tolist()))
    
    #get a list of fromfeat ids that are upstream of the tofeat ids and add it to dictionary
    toFeatDict = {}
    for id in toFeatList:
        df1 = df[df["tofeat"] == id]
        fromList = list(set(df1['fromfeat'].tolist()))
        toFeatDict[id] = fromList
        print(id)
        
    
    upDict = {}
    for k in toFeatDict.keys():
        
        upList = toFeatDict[k]
        orgLen = len(set(upList))
        for uk in toFeatDict[k]:
            if uk in toFeatDict.keys():
                upList = upList + toFeatDict[uk]
            newLen = len(set(upList))        
            
            while newLen > orgLen:
                orgLen = newLen
                
                for id in upList:
                    if id in toFeatDict.keys():
                        addList = toFeatDict[id]
                        diffList = set(addList).difference(upList)
                        upList = upList + list(diffList)
                newLen = len(set(upList))
               
        upDict[k] = str(upList)
        print(k)
    
    #convert dictionary to pd and then to csv file
    dfDict = pd.DataFrame.from_dict(upDict, orient = "index").reset_index()
    
    dfDict.rename(columns={"index": "rid", 0: "values"}).to_csv(accumTables + "/relationshipdict.csv", index = False, columns = ("rid", "values"))

else:
    #get a list of all rids 
    df = pd.read_csv(relshpCSV)
    #get a unique list of tofeat
    toFeatList =list(set(df['tofeat'].tolist()))
    
    #import csv as dictionary  
    dictTable = accumTables + "//relationshipdict.csv"
    lineList = []
    with open(dictTable) as f:
       for line in csv.DictReader(f):
          lineList.append(line)
    upDict = {}
    for line in lineList:
        thedict = dict(line)
        # if len(thedict.keys()) > 2:
        #     val1 = int(thedict['values'].replace("[", ""))
        #     valList = [int(v.replace("]", "")) for v in thedict[None] ]
        #     upDict[int(thedict['rid'])] = [val1] + valList
        # else:
        val1 = thedict['values'].replace("[", "").replace("]","")
        valList = [int(v)  for v in val1.split(",")]
        upDict[int(thedict['rid'])] =valList

#import metric csv as pd

df = pd.read_csv(csvfile)
ridList = df["rid"]


dfList = []
#for each of the rids
for rid in ridList:
    if rid in upDict.keys():
        upIDs = upDict[rid] + [rid]

    else:
        upIDs = [rid]

    #create a dataframe of upstream ids including the current id
    dfQ = df[df['rid'].isin(upIDs)]

    #get a list of all of the columns you need to accumulate
    #if the columns that you need to accumulate start with something different than the metric variable change it here (see example below)
    colList = [col for col in list(dfQ.columns) if col.startswith(metric) and not col.endswith("a")]
    #colList = [col for col in list(dfQ.columns) if col.startswith("RNOFF") and not col.endswith("a")]

    #sum the values for each of the columns in the data frame
    sumdf = dfQ[colList].sum()
    sumdf["rid"] = rid

    #transpose the dataframe
    sumdf1 = pd.DataFrame({'fields':sumdf.index, 'values':sumdf.values}).T
    header_row = sumdf1.iloc[0]
    sumdf1 = pd.DataFrame(sumdf1.values[1:], columns=header_row)

    #append the summed dataframe to a list
    dfList.append(sumdf1)

#concatenate all of the summed dataframes
dfconcat = pd.concat(dfList)
#if you have altered the metric name in line 113 you will need to change it here too.

colList = [col for col in list(dfconcat.columns) if col.startswith(metric)]
#renames columns so that they include an "a" at the end to
colrenameDict = {}
for col in colList:
    colrenameDict[col] = col + "a"
#export the accumulated table
dfconcat.reset_index().rename(columns = colrenameDict).to_csv(outTable + "accum_" + metric + ".csv")

