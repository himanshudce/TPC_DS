import os
import time
import glob
import pandas as pd

queries_path = glob.glob('tpcds_kit/all_queries_seperated/*.sql')
queries_path_updated = []
for qur in queries_path:
    queries_path_updated.append((qur,int(qur.split("query")[-1].split(".sql")[0])))
queries_path_updated = sorted(queries_path_updated,key = lambda x:x[1])

query_results = []

for i,query_tuple in enumerate(queries_path_updated):
    query_path = query_tuple[0]
    query_no = query_tuple[1]
    Error="NO"
    print("running query "+str(query_no))
    start = time.time()
    
    if os.system(f'mysql -u sergio -D tpcds < {query_path};')!=0:

        print("error in query "+str(query_no))
    end = time.time()
    print("time taken for query "+str(query_no)+" is - "+str(end-start)+"\n\n")
    query_results.append([query_path,query_no,end-start,Error])
    

query_results_df = pd.DataFrame(query_results,columns=['path','query_number','time(s)',"Error"])
query_results_df.to_csv('query_results.csv',index=False)
