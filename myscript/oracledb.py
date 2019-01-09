# 用于初始化数据库连接并提供一系列有关数据的应用
# author:张彬
# date:2015年10月19日


from sqlalchemy import create_engine
import pandas as pd
import os
import configparser

class Db():
    """
    默认为一个查询用户连接数据库的行为
    db是create_engine()的结果
    为了方便工作几个没写好的function
    """
    try:
        cf = configparser.ConfigParser()
        cf.read('office_config.ini')
        user_ini = cf.get('db','user')
        password_ini = cf.get('db','password')
        ip_ini = cf.get('db','ip')
        sid_ini = cf.get('db','sid')
    except:
        print('连接数据库失败')
        

    def __init__(self,user=user_ini,password=password_ini,ip=ip_ini,sid=sid_ini):
        os.environ['NLS_LANG']='SIMPLIFIED CHINESE_CHINA.UTF8'#解决字符串问题
        self.user=user
        self.password=password
        self.ip=ip
        self.sid=sid
        linkstr = 'oracle://' + self.user + ':' + self.password + '@' + self.ip + '/' + self.sid + '?charset=utf8'#解决字符串问题
        self.db=create_engine(linkstr,echo=False)#echo是数据库查询记录开关

    def test(self):
        """
        测试数据库连接用
        """
        try:
            cur=self.db.execute("select count(*) from dzrkxt.zh_dictvalue")
            a=cur.fetchone()
            cur.close()
            print(a)
        except cx_Oracle.DatabaseError as e: 
            print(e)

    def jbxx(self,sfzh):
        """
        一般查询用，获取人的基本信息
        """
        cur=self.db.execute( \
                "select xm,gmsfhm,ssxq,pcsdm,dzrkxt.c2n('rk_pcs',pcsdm),xz,zt,zxsj,whbs,gxsj \
                from dzrkxt.czrk_jbxx \
                where gmsfhm ='"+sfzh+"'")
        result = cur.fetchall()
        for i in result:
            xm,sfz,ssxq,pcs,pcsmc,zz,zt,zxsj,whbs,gxsj=i
            print(xm,sfz,ssxq,pcs,pcsmc,zz,zt,zxsj)
        cur.close()
        return result

    def sql(self,sqlstr):
        """
        假设sqlstr是标准的sql语句
        单纯执行sql用,
        一般是insert,update
        """
        cur=self.db.execute(sqlstr)
        cur.close() 

    def gen_sql(self,table,*field,**condition):
        """
        为了方便查询，写一个封装sql语句的函数,注意各种参数的使用
        table是要查询的表名，可变参数field是查询的所有字段，condition关键字参数是whee字句的条件（之能用等于条件）
        返回合成的sql字段
        """
        columns = ''.join(field) 
        schema = table 
        where = ' and '.join([x+' = '+ "'"+y+ "'" for (x,y) in condition.items()])
        sql = 'select '+columns+' from '+schema+' where '+where
        return sql

    def zp(self):
        """
        维护照片用
        """
        while(True):
            print('输入身份证号')
            sfzh=input()
            if len(sfzh) !=18:
                print('退出！')
                break
            sqlstr = """
                update rk_zpxx t set t.whbs = '0' where t.xlh = 
                (select xlh from (
        select gmsfhm,a.cjsj,xlh,
        row_number() over(partition by gmsfhm order by a.cjsj desc) as rn
         from rk_zpxx a 
         where cjsj is not null and gmsfhm = '"""+sfzh+"""') 
         where rn = 1)"""
            self.sql(sqlstr)
            recorde = self.db.execute("select xm,whbs,cjsj,gxsj from rk_zpxx where gmsfhm='"+sfzh+"' order by cjsj desc")
            rlist = recorde.fetchall()
            if not rlist:
                print('没有记录')
            else:
                for i in rlist:
                    print(i)
            print(sqlstr+'更新完成！')
    

    def query(self,sqlstr):
        """
        假设sqlstr是标准的查询语句
        获取该语句的执行结果
        返回一个list其中每行对应一个tuple
        """
        cur = self.db.execute(sqlstr)
        return cur.fetchall()

    def queries(self,table,*field,**condition):
        """
        将两个函数封装在一起
        table是要查询的表名，可变参数field是查询的所有字段，condition关键字参数是whee字句的条件（之能用等于条件）
        返回一个list其中每行对应一个tuple
        """
        sqlstr=self.gen_sql(table,*field,**condition)
        return self.query(sqlstr)


    def sfzh_text2excel(self,input_path,out_path,field_str="xm as 姓名,gmsfhm as 身份证号",table="czrk_jbxx"):
        """
        假设input_path是每行一个身份证号的txt,out_path是输出excel的路径,field_str是需要获取的字段的sql片段
        根据身份证号导出其他数据项用
        将查询结果输出成excel返回df
        """
        with open(input_path,'r') as f:
            sfz_list=f.readlines()
        sfz_list2=[] 
        for i in sfz_list:
            sfz_list2.append(i.split('\n')[0].strip())
        origin_df=pd.DataFrame(sfz_list2,columns=['身份证号'])
        conn = self.db.connect()
        sqlstr1="""select """ + field_str + """
        from
       (select t.*,
       row_number() over(partition by t.gmsfhm order by t.zt) as rn
       from dzrkxt.czrk_jbxx t)
        where rn = 1 and gmsfhm = 
        '"""
        result_df=pd.io.sql.read_sql(sqlstr1+sfz_list2[0]+"'",conn)
        print('生成结构的结果\n%s'%result_df)
        count = 0
        for i in sfz_list2[1:]:
            count += 1
            print('开始查询第%s个身份证号:%s'%(count,i))
            temp_df=pd.io.sql.read_sql(sqlstr1+i+"'",conn) 
            #print('循环体内的结果\n%s'%result_df)
            result_df=result_df.append(temp_df)
            #print('append的结果\n%s'%result_df)
            print('%s查询完成'%i)
        conn.close()
        print('正在生成结果文件')
        result_df = result_df.merge(origin_df,how='outer')
        result_df = result_df.fillna('查无结果')
        result_df.to_excel(out_path)
        return result_df
    

    def sfzh_text2excel_sfzxx(self,input_path,out_path,field_str="xm as 姓名,gmsfhm as 身份证号"):
        """
        这个函数是为查询身份证有效期起始日期临时创建的，应该能和sfzh_text2excel合并
        """
        with open(input_path,'r') as f:
            sfz_list=f.readlines()
        sfz_list2=[] 
        for i in sfz_list:
            sfz_list2.append(i.split('\n')[0].strip())
        origin_df=pd.DataFrame(sfz_list2,columns=['身份证号'])
        conn = self.db.connect()
        field_str = "xm as 姓名,gmsfhm as 身份证号,yxqxsrq as 有效期起始日期,yxqxjzrq as 有效期截止日期"
        sqlstr1="""select """ + field_str + """
        from
       (select t.*,
       row_number() over(partition by t.gmsfhm order by substr(t.slsj,0,8) desc) as rn
       from dzrkxt.sfz_glxx t)
        where rn = 1 and gmsfhm = 
        '"""
        result_df=pd.io.sql.read_sql(sqlstr1+sfz_list2[0]+"'",conn)
        print('生成结构的结果\n%s'%result_df)
        count = 0
        for i in sfz_list2[1:]:
            count += 1
            print('开始查询第%s个身份证号:%s'%(count,i))
            temp_df=pd.io.sql.read_sql(sqlstr1+i+"'",conn) 
            #print('循环体内的结果\n%s'%result_df)
            result_df=result_df.append(temp_df)
            #print('append的结果\n%s'%result_df)
            print('%s查询完成'%i)
        conn.close()
        print('正在生成结果文件')
        result_df = result_df.merge(origin_df,how='outer')
        result_df = result_df.fillna('查无结果')
        result_df.to_excel(out_path)
        return result_df


    def sfzh2xp(self,gmsfhm):
        """
        假设传入的是标准身份证号码
        如果查不到次身份证号码或者无照片返回身份证号和相应的字符串
        如果查到将结果保存在当前目录下的img目录中
        """
        cur = self.db.execute("select t.xm,m.xp from dzrkxt.czrk_jbxx t left join dzrkxt.rk_zpxx m on t.xpxlh = m.xlh where \
        t.gmsfhm = '" +gmsfhm+ "' and rownum =1 order by t.zt")
        result = cur.fetchone()
        cur.close()
        if not result:
            return gmsfhm + ':查无此人'
        xm,xp=result
        if not xp:
            return gmsfhm + ':此人无照片'
        path = 'img'
        if not os.path.exists(path):
            os.mkdir(path)
        exportpath = os.path.join(path,gmsfhm+xm+'.jpg')
        with open(exportpath,'wb') as f:
            f.write(xp)

if __name__=='__main__':
    tmp = Db()
    tmp.test()
    #print(tmp.gen_sql('dzrkxt.zh_dictvlaue','dictname',dictname='aaa',dictcode='321'))
    #tmp.sfzh_text2excel_sfzxx('txt/建行20181031.txt','xls/建行.xlsx')
    #tmp.sfzh_text2excel('test.txt','test_pd.xlsx',field_str="xm as 姓名,gmsfhm as 身份证号,xb as 性别")
    #tmp.jbxx('371425198809260035')
    #r =  tmp.query('select xm from dzrkxt.czrk_jbxx where rownum = 1')
    #print(r)
    #tmp.test()
