from flask import make_response, render_template,session

from Glaucoma_eyes import mysql
import MySQLdb.cursors
import json

def Login(email,mdp):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM medecins WHERE Email_Med=%s AND Mdp_Med=%s', (email, mdp))
    req = cursor.fetchone()
    if req:
        session['loggedin']=True
        session['emails']=req["Email_Med"]
        session['mdps']=req["Mdp_Med"]
        session['profile']=req["Profile_Med"]
        session['ID_Med'] = req["ID_Med"]
        a=session['emails']
        print(a)
        if(session['emails']==email and session['mdps']==mdp):
            return session['profile']
        else:
            return ""
    else:
        msg = 'Nom usager ou mot de passe incorrect'
        return ""


def ModifierProfile(nom,prenom,email,tel,profile,mdp,id):
     cursor=mysql.connection.cursor(MySQLdb.cursors.DictCursor)
     print("oOOOOOK")
     cursor.execute('UPDATE medecins SET Nom_Med=%s ,Prenom_Med=%s ,Email_Med=%s ,Tel_Med=%s ,Profile_Med=%s,Mdp_Med=%s WHERE ID_Med=%s',(nom,prenom,email,tel,profile,mdp,id))
     print("oku")
     mysql.connection.commit()

     return True
def SavePatient(nom,prenom,sexe,dateNais,tel,email, Adresse, Assurance, Profession, Origin, LieuNaiss, vEpse):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    print("oOOOOOK")
    cursor.execute('INSERT INTO patients  (Nom_Pat, Prenom_Pat, Sexe_Pat, DateNais, Tel_Pat, Email_Pat, Adresse_Pat, Assurance_Pat, Profession_Pat, Origin_Pat, LieuNaiss_Pat, Epse_Pat) VALUES (%s, %s, %s, %s,%s,%s,%s, %s, %s, %s,%s,%s)',(nom,prenom,sexe,dateNais,tel,email, Adresse, Assurance, Profession, Origin, LieuNaiss, vEpse))

    print("oOOOOOK")
    mysql.connection.commit()
    return True


def ConsultationPatient():

    return True

def date_handler(obj):
    return obj.isoformat() if hasattr(obj, 'isoformat') else obj


def getRDV(searchDate):
    if not parameter_checker(searchDate) :
        return json.dumps({})
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    sql = "select ID_rdv id, NomPart_rdv title, Start_rdv start, End_rdv end, 'false' allDay from rendez_vous where to_days(start) >= to_days(%s) and to_days(end) <= to_days(%s)"
    sql = "select ID_rdv id, CONCAT(DATE_FORMAT(Start_rdv, '%H:%i'),' ',NomPart_rdv, ' (',LEFT(Detail_rdv, 50),')') title, Start_rdv start, End_rdv end, 'false' allDay from rendez_vous ORDER BY Start_rdv"
    params = ('Y', searchDate['start'], searchDate['end'])
    cursor.execute(sql)
    row = cursor.fetchall()
    return json.dumps(row, default=date_handler)

def parameter_checker(params):
    if not bool(params):
        return False
    elif hasattr(params,'strip') and not bool(params.strip()):
            return False
    elif hasattr(params,'values'):
        for value in params.values() :
            if not parameter_checker(value) :
                return False
        return True
    else:
        return True

