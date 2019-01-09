import vim
import sys
sys.path.append('.')
import oracledb
from pandas.io import sql
import time
db = oracledb.Db()
conn = db.db.connect()
start = time.clock()
result = db.query(vim.eval('@"'))
result_vim = ['|'.join(['{0:20}'.format(j) for j in i]) for i in result]
conn = db.db.connect()
columns = sql.read_sql(vim.eval('@"'),conn)
conn.close()
result_columns = ['|'.join(['{0:20}'.format(i) for i in columns.columns])]
vim.current.buffer.append(result_columns)
vim.current.buffer.append(result_vim)

