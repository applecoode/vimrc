import vim
import sys
sys.path.append('.')
import oracledb
from pandas.io import sql
db = oracledb.Db()
conn = db.db.connect()
result = db.query(vim.eval('@"'))
result_vim = [','.join([str(j) for j in i]) for i in result]
conn = db.db.connect()
columns = sql.read_sql(vim.eval('@"'),conn)
conn.close()
result_columns = [','.join([i for i in columns.columns])]
vim.current.buffer.append(result_columns)
vim.current.buffer.append(result_vim)
