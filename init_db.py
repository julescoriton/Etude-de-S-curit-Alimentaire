import MySQLdb

class Dbconnect(object):

    def __init__(self):

        self.dbconection = MySQLdb.connect(db='p3.db')
        self.dbcursor = self.dbconection.cursor()

    def commit_db(self):
        self.dbconection.commit()

    def close_db(self):
        self.dbcursor.close()
        self.dbconection.close()



db = Dbconnect()
db.dbcursor.execute('SELECT * FROM %s' % 'population')

#
# def __init__(self):
#     self.dbconection = MySQLdb.connect(  # host='local_host',
#         # port=int('port_example'),
#         user='root',
#         passwd='1234',
#         db='p3.db')
#     self.dbcursor = self.dbconection.cursor()