import MySQLdb.cursors
from flask import render_template, url_for, request, session, redirect, flash
from werkzeug.utils import secure_filename
from Glaucoma_eyes import app, mysql

from Glaucoma_eyes.models import Login, ModifierProfile, SavePatient, getRDV

import numpy as np
from datetime import datetime, date

import tensorflow as tf
from tensorflow.keras.preprocessing import image
from tensorflow.keras.models import load_model

import os
import pickle
from  datetime import datetime

os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
os.environ['CUDA_VISIBLE_DEVICES'] = '0'




##Glaucoma segmentation Librairy
import numpy as np
#import scipy.io as sio
#import scipy.misc
from keras.preprocessing import image
#from skimage.transform import rotate, resize
#from skimage.measure import label, regionprops
from time import time
#from Glaucoma_eyes.utils_Mnet import pro_process, BW_img, disc_crop
#import matplotlib.pyplot as plt
#from skimage.io import imsave
from tensorflow.keras.preprocessing import image


import cv2
import os

#import Glaucoma_eyes.Model_DiscSeg as DiscModel
#import Glaucoma_eyes.Model_MNet as MNetModel

#DiscROI_size = 400
#DiscSeg_size = 640
#CDRSeg_size = 400

##Load model classification
model = load_model("Glaucoma_eyes/Model2.hdf5")
model1 = pickle.load(open('Glaucoma_eyes/model.pkl','rb'))
##model.load_weights('Glaucoma_eyes/t2_model_v1.weights.best.hdf5')
##Load model segmentation
#DiscSeg_model = DiscModel.DeepModel(size_set=DiscSeg_size)
#DiscSeg_model.load_weights('Glaucoma_eyes/Model_DiscSeg_ORIGA_pretrain.h5')

#CDRSeg_model = MNetModel.DeepModel(size_set=CDRSeg_size)
#CDRSeg_model.load_weights('Glaucoma_eyes/Model_MNet_ORIGA_pretrain.h5')
@app.route('/')
def Dashbord():
    return render_template('Login.html')


@app.route('/patient')
def EnregisterPatient():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM patients ')
    rep = cursor.fetchall()
    return render_template('modal.html', rep=rep)


@app.route('/listePatient_Consultation')
def listePatient_Consultation():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute(
        "SELECT *, CONCAT((DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(DateNais)), '%y')+0), ' ans') AS AGE FROM patients ")
    rep = cursor.fetchall()
    print(rep)
    return render_template('Liste_patient_consultation.html', rep=rep)


@app.route('/Accueil', methods=['POST', 'GET'])
def Accueil():
    msg = 'veillez entrez votre email et mot de passe'

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT COUNT(ID_Pat)nbre FROM patients")
    NbreClients = cursor.fetchone()
    cursor.execute("SELECT COUNT(ID_Pat)nbre FROM patients WHERE Sexe_Pat='Feminin'")
    nbreClients_femme=cursor.fetchone()
    cursor.execute("SELECT COUNT(ID_Pat)nbre FROM patients WHERE Sexe_Pat='Masculin'")
    nbreClients_homme = cursor.fetchone()
    cursor.execute("SELECT COUNT(ID_rdv)nbre FROM rendez_vous WHERE DATE_FORMAT(Start_rdv,'%Y/%m/%e')=DATE_FORMAT(Now(), '%Y/%m/%e')")
    rendezvous=cursor.fetchone()

    if request.method == 'POST':
        email = request.form['NomUser']

        password = request.form['password']
        if (Login(email, password) == ''):
            msg = 'Nom usager ou mot de passe incorrect'
            return render_template('Login.html', msg=msg)
        else:

            return render_template('Accueil.html', NbreClients=NbreClients,homme=nbreClients_homme,femme=nbreClients_femme,rendezvous=rendezvous)

    return render_template('Accueil.html', NbreClients=NbreClients,homme=nbreClients_homme,femme=nbreClients_femme,rendezvous=rendezvous)


@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('ID_Med', None)
    session.pop('emails', None)

    return redirect(url_for('Accueil'))


@app.route('/profile')
def profile():
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        print(session['ID_Med'])
        cursor.execute('SELECT * FROM medecins WHERE ID_Med = %s', (session['ID_Med'],))
        compte = cursor.fetchone()
        return render_template('profile.html', compte=compte)


@app.route('/updateProfil', methods=['POST', 'GET'])
def updateProfil():
    if request.method == 'POST':
        id = request.form['idem']
        nom = request.form['Nom']
        prenom = request.form['Prenom']
        email = request.form['email']
        tel = request.form['Tel']
        mdp = request.form['Password']
        profile = request.form['profile']
        if (ModifierProfile(nom, prenom, email, tel, profile, mdp, id) == True):
            return render_template('Accueil.html')
    return render_template('Accueil.html')


@app.route('/NouveauPatient', methods=['POST', 'GET'])
def NouveauPatient():
    return render_template('NouveauPatient.html')


@app.route('/EnregistrerNouveauPatient', methods=['POST', 'GET'])
def EnregistrerNouveauPatient():
    flash("Enregistrer avec success")
    if request.method == 'POST':
        nom = request.form['Nom']
        print(nom)
        vEpse = request.form['Epse']
        print(vEpse)
        prenom = request.form['Prenom']
        print(prenom)
        dateNais = request.form['dataNais']
        print(dateNais)
        sexe = request.form['sexe']
        print(sexe)

        LieuNaiss = request.form['sexe']
        print(LieuNaiss)

        Origin = request.form['Origin']
        print(Origin)

        Profession = request.form['Profession']
        print(Profession)
        Assurance = request.form['Assurance']
        print(Assurance)
        Adresse = request.form['Adresse']
        print(Adresse)

        tel = request.form['Tel']
        email = request.form['email']
        if (SavePatient(nom, prenom, sexe, dateNais, tel, email, Adresse, Assurance, Profession, Origin, LieuNaiss,
                        vEpse) == True):
            return redirect(url_for('EnregisterPatient'))


# @app.route('/Consultation_Patient/<string:ID_Pat>',methods=['GET'])
# def Consultation_Patient(ID_Pat):
# cursor=mysql.connection.cursor(MySQLdb.cursors.DictCursor)
# cursor.execute('select * from patients WHERE ID_Pat=%s',(ID_Pat))
# data=cursor.fetchone()


# return render_template('ConsultationPatient.html',data=data)


@app.route('/Consultation_Patient/<string:ID_Pat>', methods=['GET', 'POST'])
def Consultation_Patient(ID_Pat):
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        print(session['ID_Med'])
        cursor.execute('SELECT * FROM medecins WHERE ID_Med = %s', (session['ID_Med'],))
        med = cursor.fetchone()
        cursor.execute('select * from patients WHERE ID_Pat=%s', (ID_Pat))
        data = cursor.fetchone()

    return render_template('ConsultationPatient.html', med=med, data=data)


@app.route('/DossierMedicale', methods=['POST', 'GET'])
def DossierMedicale():
    return render_template('Dossier_Medical.html')


@app.route('/fiche_Médicale/<string:ID_Pat>', methods=['GET'])
def fiche_Médicale(ID_Pat):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    print('select * from patients WHERE ID_Pat=%s', (ID_Pat))
    cursor.execute('select * from patients WHERE ID_Pat=%s', (ID_Pat))
    data = cursor.fetchone()
    print('select * from traitement_en_cours WHERE ID_Pat=%s', (ID_Pat))
    cursor.execute('select * from traitement_en_cours WHERE ID_Pat=%s', (ID_Pat))
    trait = cursor.fetchall()
    print('select * from antecedent WHERE ID_Patient=%s', (ID_Pat))
    cursor.execute('select * from antecedent where ID_Patient=%s', (ID_Pat))
    Ant = cursor.fetchall()

    return render_template('Dossier_Medical.html', data=data, trait=trait, Ant=Ant)


@app.route('/traitement_en_cours', methods=['POST'])
def traitement_en_cours():
    if request.method == 'POST':
        id_patient = request.form['IDPatient']
        date = request.form['date']
        medicament = request.form['medicament']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            'INSERT INTO traitement_en_cours  (Nom_Trait, Date_Trait, ID_Pat) VALUES (%s, %s, %s)',
            (medicament, date, id_patient))
        mysql.connection.commit()
    cursor.execute('select * from patients WHERE ID_Pat=%s', (id_patient))
    data = cursor.fetchone()
    cursor.execute('select * from traitement_en_cours WHERE ID_Pat=%s', (id_patient))
    trait = cursor.fetchall()
    cursor.execute('select * from antecedent where ID_Patient=%s', (id_patient))
    Ant = cursor.fetchall()

    return render_template('Dossier_Medical.html', data=data, Ant=Ant, trait=trait)


@app.route('/Antecedants_patient', methods=['POST', 'GET'])
def Antecedants_patient():
    if request.method == 'POST':
        id_patient = request.form['IDPatient']
        Nom_Antecedant = request.form['Nom_Antecedant']
        Nom_Ante_medicaux = request.form['Nom_Ante_medicaux']
        Nom_Ante_Familliaux = request.form['Nom_Ante_Familliaux']
        print(Nom_Antecedant)
        print(id_patient)
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            'INSERT INTO antecedent  (ID_Patient,Ante_oph, Ante_med, Ante_familliaux) VALUES (%s, %s, %s,%s)',
            (id_patient, Nom_Antecedant, Nom_Ante_medicaux, Nom_Ante_Familliaux))
        mysql.connection.commit()
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("select * from patients WHERE ID_Pat='"+id_patient+"'")
    data = cursor.fetchone()
    cursor.execute("select * from antecedent where ID_Patient='"+id_patient+"'")
    Ant = cursor.fetchall()
    cursor.execute("select * from parametremedicaux where ID_PAT='"+id_patient+"'")
    para = cursor.fetchall()
    id_patient = ''
    Nom_Antecedant = ''
    Nom_Ante_medicaux = ''
    Nom_Ante_Familliaux = ''

    return render_template('Fichemedicale21.html', data=data, Ant=Ant, para=para)


def calculate_age(born):
    today = date.today()
    return today.year - born.year - ((today.month, today.day) < (born.month, born.day))


@app.route('/predire', methods=['POST'])
def predire():
    if request.method == 'POST':
        IDpatient = request.form['IDpatient']
        IDmedecin = request.form['IDmedecin']
        Motif = request.form['Motif']
        Observation = request.form['Observation']
        TensionGauche = request.form['TensionGauche']
        TensionDroite = request.form['TensionDroite']
        acuiteGauche = request.form['acuiteGauche']
        acuiteDroite = request.form['acuiteDroite']
        imagefileG = request.files['imagefileG']
        imagefileD = request.files['imagefileD']
        imgage_path = imagefileG.filename
        imagefileG.save(imgage_path)
        img = image.load_img(imgage_path, target_size=(224, 224))
        img = np.expand_dims(img, axis=0)
        imgage_paths = imagefileD.filename
        imagefileD.save(imgage_paths)
        imge = image.load_img(imgage_paths, target_size=(224, 224))
        imge = np.expand_dims(imge, axis=0)
        print('chargement du model')
        model = tf.keras.models.load_model("Glaucoma_eyes/Model2.hdf5")
        print('modele charger')
        output = model.predict(img)
        print('ok')
        print(output)
        msg = str(output)
        msg += imgage_path
        if output[0][0] > output[0][1]:
            if (output[0][0] > 0.5):
                print(output[0][0] )
                print("Glaucome")
                msg += 'Glaucome'
            else:
                print(output[0][1])
                print('NonGlaucome')
                msg += 'NonGlaucome'
        else:
            print('NonGlaucome')
            msg += 'NonGlaucome'
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    # cursor.execute('INSERT INTO consultation (date, ID_Patient, ID_Med,Motif,Resultat,Observation) VALUES (%s, %s, %s,%s,%s,%s)',
    # (Nom_Antecedant, Observation, id_patient)')
    data = cursor.fetchone()

    return render_template('OK.html')


@app.route('/New_Dasboard', methods=['POST', 'GET'])
def New_Dasboard():
    return render_template('PageAccueil.html')


@app.route('/ModifierPatient', methods=['POST', 'GET'])
def ModifierPatient():
    if request.method == 'POST':
        id = request.form['ID_Patient']
        nom = request.form['Nom']
        prenom = request.form['Prenom']
        proffesion = request.form['Profession']
        assurance = request.form['Assurance']

        tel = request.form['Tel']
        email = request.form['email']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            'UPDATE patients SET Nom_Pat=%s ,Prenom_Pat=%s ,Profession_Pat=%s ,Assurance_Pat=%s,Tel_Pat=%s,Email_Pat=%s WHERE ID_Pat=%s',
            (nom, prenom, proffesion, assurance, tel, email, id))
        mysql.connection.commit()
        cursor.execute('SELECT * FROM patients ')
        rep = cursor.fetchall()

    return render_template('modal.html', rep=rep)


@app.route('/Liste_Rdv', methods=['POST', 'GET'])
def ListeRdv():
    return render_template('Liste_Rdv.html')


@app.route('/Planning_Rdv', methods=['POST', 'GET'])
def PlanningRdv():
    return render_template('planning_Rdv.html')


@app.route('/modal', methods=['POST', 'GET'])
def modal_fen():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM patients ')
    rep = cursor.fetchall()

    return render_template('modal.html', rep=rep)


@app.route('/EnregistrerParametre', methods=['POST', 'GET'])
def EnregistrerParametre():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if request.method == 'POST':
        id_patient = request.form['IDpatient']
        id_medecin = request.form['IDmedecin']
        date_parametre = request.form['dateParametre']
        tensionarterielle = request.form['Tension_arterielle']
        poids = request.form['PoidsPatient']
        motif_consultation = request.form['motif']
        PIOG = request.form['PIOG']
        PIOD = request.form['POID']
        AVG = request.form['AcuiteG']
        AVD = request.form['AcuiteD']
        LAPG = request.form['LAPG']
        LAPD = request.form['LAPD']
        print(tensionarterielle)
        print(
            'INSERT INTO parametremedicaux (ID_PAT,ID_MEDECIN, date_parametre, motif, tension_arterielle, poids, PIOG, PIOD, AVG, AVD, LAPG, LAPD) VALUES (%s, %s, %s,, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
            (id_patient, id_medecin, date_parametre, motif_consultation, tensionarterielle, poids, PIOG, PIOD, AVG,
             AVD, LAPG, LAPD))
        cursor.execute(
            'INSERT INTO parametremedicaux (ID_PAT, ID_MEDECIN, date_parametre,motif,tension_arterielle,poids,PIOG,PIOD,AVG,AVD,LAPG,LAPD) VALUES (%s, %s, %s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',
            (id_patient, id_medecin, date_parametre, motif_consultation, tensionarterielle, poids, PIOG, PIOD, AVG,
             AVD, LAPG, LAPD))
        cursor.execute(
            "SELECT *, CONCAT((DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(DateNais)), '%y')+0), ' ans') AS AGE FROM patients ")
        rep = cursor.fetchall()
        mysql.connection.commit()
        print("ok")

        return render_template('Liste_patient_consultation.html', rep=rep)
    return render_template('Liste_patient_consultation.html')


@app.route('/ParametreMedicaux/<string:ID_Pat>', methods=['POST', 'GET'])
def Parametre_medicaux(ID_Pat):
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("select * from patients WHERE ID_Pat='"+ID_Pat+"'")
        data = cursor.fetchone()
        vIDMed = str(session['ID_Med'])
        cursor.execute("SELECT * FROM medecins WHERE ID_Med = '"+vIDMed+"'")
        med = cursor.fetchone()
        return render_template('Parametremedicaux.html', data=data, med=med)


@app.route('/FicheMedicale_2/<string:ID_Pat>', methods=['POST', 'GET'])
def FicheMedicale_2(ID_Pat):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    print("select * from patients WHERE ID_Pat='"+ID_Pat+"'")
    cursor.execute("select * from patients WHERE ID_Pat='"+ID_Pat+"' limit 1")
    data = cursor.fetchone()
    print(data)
    cursor.execute("select * from antecedent WHERE ID_Patient='"+ID_Pat+"'")
    Ant = cursor.fetchall()
    cursor.execute("select * from parametremedicaux where ID_PAT='"+ID_Pat+"'")
    para = cursor.fetchall()
    return render_template('Fichemedicale21.html', data=data, Ant=Ant, para=para)


@app.route('/VerificationFond/<string:ID_Parametre>', methods=['POST', 'GET'])
def VerificationFond(ID_Parametre):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if 'loggedin' in session:
        cursor.execute('SELECT * FROM medecins WHERE ID_Med = %s', (session['ID_Med'],))
        med = cursor.fetchone()
        cursor.execute("select * from parametremedicaux where ID_Parametre='"+ID_Parametre+"'")
        para = cursor.fetchone()
        print(para)
        ID_Pat=para['ID_PAT']
        ID_Pat=str(ID_Pat)
        print(ID_Pat)
        cursor.execute('select * from patients WHERE ID_Pat='+ID_Pat+'', None)
        data = cursor.fetchone()
        cursor.execute('select * from antecedent where ID_Patient='+ID_Pat+'', None)
        Ant = cursor.fetchall()
    return render_template('Consultation_patient.html', data=data, para=para, Ant=Ant)

@app.route('/Resultat', methods=['POST', 'GET'])

def Resultat():

    #train_data_type = '.png'
    #mask_data_type = '.bmp'

    #Original_validation_img_path = 'data/557.png'

    #valiImage_save_path = 'data/save_path_460/'

    #PolarTrainImage_save_path = 'data/PolarTrainImage_save_path/'
    #seg_result_save_path = 'data/DAresult_460/'

    #if not os.path.exists(seg_result_save_path):
     #   os.makedirs(seg_result_save_path)

    #if not os.path.exists(valiImage_save_path):
     #   os.makedirs(valiImage_save_path)

    #if not os.path.exists(PolarTrainImage_save_path):
     #   os.makedirs(PolarTrainImage_save_path)



    uploads_dir = os.path.join(app.static_folder, 'image')
    msg=' Glaucome'
    msg2='Non Glaucome'


    if request.method == 'POST':
        repFile=""
        repFileD=""
        repFileG=""
        repFile='/image/'
        repFileD = '/image/'
        profileG = request.files['imagefileG']
        filenameG = secure_filename(profileG.filename)
        profileG.save( os.path.join(uploads_dir,filenameG))
        repFile+=filenameG

        profileD = request.files['imagefileD']
        filenameD = secure_filename(profileD.filename)
        profileD.save(os.path.join(uploads_dir, filenameD))
        repFileD+= filenameD
        idparametre=request.form['idparametre']
        print('IDParametre : ', idparametre)

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT ID_PAT, PIOG FROM parametremedicaux WHERE ID_Parametre = ' + idparametre + ' ', None)
        data = cursor.fetchone()
        PIOG = data['PIOG']
        print(PIOG)
        ID_PAT = data['ID_PAT']
        print(ID_PAT)
        print(type(str(ID_PAT)))

        cursor.execute(" SELECT Sexe_Pat, DateNais FROM patients WHERE ID_PAT = " + str(ID_PAT) + " ", None)
        Ant = cursor.fetchone()
        sexe = Ant['Sexe_Pat']
        int(sexe)
        dateNa = Ant['DateNais']
        print('date naissance', type(dateNa.year))
        datetoday = datetime.now()
        datetodayyear = datetoday.year
        print('datetoday', type(datetodayyear))
        dateN = datetodayyear - dateNa.year
        print(type(dateN))


        cursor.execute(
           'insert into image_oeil(ID_parametre,repertoireG,repertoireD) values(%s,%s,%s)',
            (idparametre, repFile, repFileD))
        print('insert into image_oeil(ID_parametre,repertoireG,repertoireD) values(%s,%s,%s)',
            (idparametre, repFile, repFileD))
        mysql.connection.commit()
        state = 'Glaucoma_eyes/static'
        state+=repFile
        imgOG= image.load_img(state, target_size=(224, 224))
        imgOG = np.asarray(imgOG)
        imgOG = np.expand_dims(imgOG, axis=0)
        output = model.predict(imgOG)
        result = model1.predict([[int(sexe), int(dateN), int(PIOG)]])
        if (result == 0):
            print("Nom glaucome")
            result = 'Nom glaucome'
        else:
            print('glaucome')
            result = 'glaucome'
        print(output)
        predictionG=''
        classeG=''
        if output[0][0] > output[0][1]:

            msgG = 'Non Glaucome' + str(output[0][0] * 100) + '%'
            predictionG= str(output[0][0] * 100)
            classeG='Non Glaucome'
        else:
            predictionG = str(output[0][1] * 100)
            classeG = 'Glaucome'
            msgG = ' Glaucome' + str(output[0][1] * 100) + '%'
        states = 'Glaucoma_eyes/static'
        states += repFileD
        imgOD= image.load_img(states, target_size=(224, 224))
        imgOD = np.asarray(imgOD)
        imgOD = np.expand_dims(imgOD, axis=0)
        output = model.predict(imgOD)
        print(output)
        predictionD = ''
        classeD = ''
        if output[0][0] > output[0][1]:
            print(output[0][0])
            print('NOn Glaucome')
            msgD= 'Non Glaucome' + str(output[0][0] * 100) + '%'
            predictionD = str(output[0][0] * 100)
            classeD= 'Non Glaucome'
        else:
            print(output[0][1])
            print('Glaucome')
            predictionD = str(output[0][1] * 100)
            classeD = 'Glaucome'
            msgD = ' Glaucome' + str(output[0][1] * 100) + '%'

             #Add segmentation code

            ##End Segmentation

        return render_template('Resultat.html',filename= repFile,filenames=repFileD,idparametre=idparametre,msgG=msgG,predictionG=predictionG,classeG=classeG,msgD=msgD,predictionD=predictionD,classeD=classeD,result=result)

@app.route('/Rendez_vous', methods=['POST', 'GET'])
def AjouterRdv():
    if request.method == 'POST':
        nom = request.form['Nom']
        tel = request.form['Tel']
        obs = request.form['Obs']
        dateRdv = request.form['dateRdv'] + ' ' + request.form['TimeRdv']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            'INSERT INTO rendez_vous(NomPart_rdv,TelPart_rdv,Start_rdv,End_rdv,Detail_rdv) VALUES (%s,%s,%s,(ADDTIME(%s, "0:15:0")),%s)',
            (nom, tel, dateRdv, dateRdv, obs))
        mysql.connection.commit()
    return render_template('Ajouter_Rdv.html')


@app.route("/getPlanning", methods=["GET"])
def getPlanning():
    if request.method == 'GET':
        start = request.args.get('start')
        end = request.args.get('end')
        return getRDV({'start': start, 'end': end})


@app.route('/Getlisting', methods=['POST', 'GET'])
def Getlisting():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute(
       "SELECT b.ID_Pat, a.Nom_Pat, a.Prenom_Pat, a.DateNais  ,a.Sexe_Pat, b.date_parametre, b.ID_Parametre from patients a, parametremedicaux b WHERE b.ID_PAT=a.ID_Pat AND DATE_FORMAT(b.date_parametre, '%Y/%m/%e')=DATE_FORMAT(Now(), '%Y/%m/%e')")

   # cursor.execute(
    #    "SELECT b.ID_Pat, a.Nom_Pat, a.Prenom_Pat, a.DateNais  ,a.Sexe_Pat, b.date_parametre, b.idPara from patients a, parametremedicaux b WHERE b.ID_PAT=a.ID_Pat AND DATE_FORMAT(b.date_parametre, '%Y/%m/%e')=DATE_FORMAT(Now(), '%Y/%m/%e') AND b.date_parametre  NOT IN (SELECT z.ID_PARA FROM consultation_patient z WHERE DATE_FORMAT(b.date_parametre, '%Y/%m/%e')=DATE_FORMAT(z.date, '%Y/%m/%e'))")
    rep = cursor.fetchall()

    return render_template('Getlisting.html', rep=rep)

@app.route('/Validation', methods=['POST', 'GET'])
def Validation():
    if request.method == 'POST':
        Diagnostics = request.form['Diagnostics']
        obsvervation = request.form['Observation']
        PrédictionG = request.form['PrédictionG']
        PrédictionD= request.form['PrédictionD']
        classeD=request.form['classeD']
        classeG=request.form['classeG']
        idparametre = request.form['idparametre']
        date = request.form['date']

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('insert into consultation_patient(ID_PARA,predictionG,predictionD,Diagnostics,observation,date,ClassG,ClassD) values(%s,%s,%s,%s,%s,%s,%s,%s)',(idparametre,PrédictionG,PrédictionD,Diagnostics,obsvervation,date,classeG,classeD))
        mysql.connection.commit()
    return render_template('Getlisting.html')


##Segmentation Glaucoma

