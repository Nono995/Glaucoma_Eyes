from flask import Flask
from flask_mysqldb import MySQL


app = Flask(__name__)

app.secret_key = '1a2b3c4d5e'
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'Glaucoma_Eyes'

mysql = MySQL(app)
from Glaucoma_eyes import routes