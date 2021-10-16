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
    print("running query "+str(i+1))
    start = time.time()
    if os.system(f'mysql -u root -D tpcds < {query_path};')!=0:
        print("error in query "+str(i+1))
    end = time.time()
    print("time taken for query "+str(i+1)+"-"+str(end-start)+"\n\n")
    query_results.append([query_path,i+1,end-start])
    

query_results_df = pd.DataFrame(query_results,columns=['path','query_number','time(s)'])
query_results_df.to_csv('query_results.csv',index=False)