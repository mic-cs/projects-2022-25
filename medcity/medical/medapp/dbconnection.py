import pymysql
db = pymysql.connect(user='root', password="" ,host="localhost",database="medical")

def select1(data):
    cu=db.cursor()
    cu.execute(data)
    d=cu.fetchone()
    return d
def insert(data):
    cu=db.cursor()
    cu.execute(data)
    db.commit()
def selectall(data):
    cu=db.cursor()
    cu.execute(data)
    d=cu.fetchall()
    return d
def delete(data):
    cu=db.cursor()
    cu.execute(data)
    db.commit()
def update(data):
    cu=db.cursor()
    cu.execute(data)
    db.commit()