from django.shortcuts import render
from medapp import dbconnection
from django.http import HttpResponseRedirect
from django.core.files.storage import FileSystemStorage
from datetime import *
from django.http import JsonResponse
import easygui
from datetime import date
import joblib
import pickle
import os
from django.conf import settings
import calendar
from django.template.defaulttags import register as reg


# Create your views here.
def index(request):
    return render(request,'common/index.html')

def login(request):
    if request.method=="POST":
        em=request.POST.get('em')
        ps=request.POST.get('ps')
        qry="select * from log where email='"+em+"' and password='"+ps+"'"
        data=dbconnection.select1(qry)
        request.session['em']=em
        if data==None:
            return render(request,'common/login.html',{'msg':'invalid email or password'})
        elif data[3]=='admin':
            return HttpResponseRedirect('http://127.0.0.1:8000/admhome')
        elif data[3]=='user':
            return HttpResponseRedirect('http://127.0.0.1:8000/userhome')   
        elif data[3]=='med_store':
            if data[4]==1:
                return HttpResponseRedirect('http://127.0.0.1:8000/medhome')   
            else:
               return render(request,'common/login.html',{'msg':'Request pending'}) 
        elif data[3]=='doctor':
            if data[4]==1:
                return HttpResponseRedirect('http://127.0.0.1:8000/dochome')   
            else:
               return render(request,'common/login.html',{'msg':'Request pending'}) 
    return render(request,'common/login.html')

def register(request):
    if request.method=='POST':
        na=request.POST.get('na')
        em=request.POST.get('em')
        sql="select * from reg where email='"+em+"'"
        d=dbconnection.select1(sql)
        if d:
            return render(request,'common/register.html',{'msg':'Email already exist'})
        ps=request.POST.get('ps')
        up=request.FILES.get('ph')
        ge=request.POST.get('ge')
        co=request.POST.get('co')
        dob=request.POST.get('dob')
        bl=request.POST.get('bl')
        if up==None:
            qry="INSERT INTO `reg`(`name`, `contact`, `email`, `password`, `dob`, `blood`, `gender`, `photo`) VALUES ('"+na+"','"+co+"','"+em+"','"+ps+"','"+dob+"','"+bl+"','"+ge+"','')"
            dbconnection.insert(qry)
        else:
            fs=FileSystemStorage()
            fs.save('medapp/static/doc/'+up.name,up)
            qry="INSERT INTO `reg`(`name`, `contact`, `email`, `password`, `dob`, `blood`, `gender`, `photo`) VALUES ('"+na+"','"+co+"','"+em+"','"+ps+"','"+dob+"','"+bl+"','"+ge+"','"+up.name+"')"
            dbconnection.insert(qry)
        qry1="INSERT INTO `log`(`email`, `password`, `utype`, `ustatus`) VALUES ('"+em+"','"+ps+"','user',1)"
        dbconnection.insert(qry1)
        return render(request,'common/register.html',{'msg1':'Registered successfully'})
    return render(request,'common/register.html')

def doc_reg(request):
    qry="select * from district"
    dis=dbconnection.selectall(qry)
    if request.method=='POST':
        na=request.POST.get('dis')
        return HttpResponseRedirect("doc_reg1?dis="+na)
    return render(request,'common/doc_reg.html',{'dis':dis})

def doc_reg1(request):
    dis=request.GET['dis']
    qry2="SELECT * FROM `location` WHERE dis_id='"+dis+"'"
    loc=dbconnection.selectall(qry2)
    if request.method=='POST':
        na=request.POST.get('na')
        em=request.POST.get('em')
        sql="select * from doc_reg where email='"+em+"'"
        d=dbconnection.select1(sql)
        if d:
            return render(request,'common/doc_reg1.html',{'msg':'Email already exist','loc':loc})
        ps=request.POST.get('ps')
        up=request.FILES.get('ph')
        ge=request.POST.get('ge')
        co=request.POST.get('co')
        dob=request.POST.get('dob')
        lo=request.POST.get('lo')
        dp=request.POST.get('dp')
        add=request.POST.get('add')
        fs=FileSystemStorage()
        fs.save('medapp/static/doc/'+up.name,up)
        cer=request.FILES.get('cer')
        fs.save('medapp/static/cet/'+cer.name,cer)
        qry="INSERT INTO `doc_reg`( `name`, `contact`, `email`, `password`, `dob`, `gender`, `photo`, `district`, `loc`, `department`, `certificate`, `address`) VALUES ('"+na+"','"+co+"','"+em+"','"+ps+"','"+dob+"','"+ge+"','"+up.name+"','"+dis+"','"+lo+"','"+dp+"','"+cer.name+"','"+add+"')"
        dbconnection.insert(qry)
        qry1="INSERT INTO `log`(`email`, `password`, `utype`, `ustatus`) VALUES ('"+em+"','"+ps+"','doctor',0)"
        dbconnection.insert(qry1)
        return render(request,'common/doc_reg1.html',{'msg1':'Registered successfully','loc':loc})
    return render(request,'common/doc_reg1.html',{'loc':loc})

def med_reg(request):
    qry="select * from district"
    dis=dbconnection.selectall(qry)
    if request.method=='POST':
        na=request.POST.get('dis')
        return HttpResponseRedirect("med_reg1?dis="+na)
    return render(request,'common/med_reg.html',{'dis':dis})

def med_reg1(request):
    dis=request.GET['dis']
    qry2="SELECT * FROM `location` WHERE dis_id='"+dis+"'"
    loc=dbconnection.selectall(qry2)
    if request.method=='POST':
        na=request.POST.get('na')
        em=request.POST.get('em')
        sql="select * from med_reg where email='"+em+"'"
        d=dbconnection.select1(sql)
        if d:
            return render(request,'common/med_reg1.html',{'msg':'Emil already exist','loc':loc})
        ps=request.POST.get('ps')
        up=request.FILES.get('ph')
        co=request.POST.get('co')
        lo=request.POST.get('lo')
        ad=request.POST.get('ad')
        fs=FileSystemStorage()
        fs.save('medapp/static/doc/'+up.name,up)
        li=request.FILES['li']
        fs.save('medapp/static/cet/'+li.name,li)
        dl=request.POST.get('dl')
        # status fiels is to know whether shop is closed or not
        qry="INSERT INTO `med_reg`( `name`, `contact`, `email`, `password`, `photo`, `district`, `loc`, `address`, `license`,`hm_dl`,`status`) VALUES ('"+na+"','"+co+"','"+em+"','"+ps+"','"+up.name+"','"+dis+"','"+lo+"','"+ad+"','"+li.name+"','"+dl+"','1')"
        dbconnection.insert(qry)
        qry1="INSERT INTO `log`(`email`, `password`, `utype`, `ustatus`) VALUES ('"+em+"','"+ps+"','med_store',0)"
        dbconnection.insert(qry1)
        return render(request,'common/med_reg1.html',{'msg1':'Registered successfully','loc':loc})
    return render(request,'common/med_reg1.html',{'loc':loc})

def dis_pr(request):
    if request.method=='POST':
        formdata = [value for key, value in request.POST.items() if key != "csrfmiddlewaretoken"]
        if all(value == "0" for value in formdata):
            request.session["d_prediction"] = None
        else:
            classifier = joblib.load(os.path.join(settings.BASE_DIR, r"medapp\\RandomForestClassifier_model.joblib"))
            with open(os.path.join(settings.BASE_DIR, r"medapp\\label_encoder.pkl"), "rb") as f:
                label_encoder = pickle.load(f)
            d_pred = classifier.predict([formdata])
            d_pred = label_encoder.inverse_transform(d_pred)
            request.session["d_prediction"] = d_pred[0]
        return HttpResponseRedirect(f"prediction")
    return render(request,'common/dis_pr.html')

def prediction(request):
    d_pred = request.session["d_prediction"]
    if d_pred:
        disease = dbconnection.select1(f"select * from disease where dname = '{d_pred}'")
        try:
            qry1 = f"""select doc_reg.* from doc
                    join doc_reg on doc.doc_id = doc_reg.id
                    where des_id = '{disease[0]}'"""
            doctors = dbconnection.selectall(qry1)
        except TypeError:
            doctors = None
    else:
        disease = doctors = None
    return render(request, "common/prediction.html", {"d_pred": d_pred,
                                                      "disease": disease,
                                                      "doctors": doctors})

# ADMIN

def admhome(request):
    return render(request,'admin/admhome.html')

def add_des(request):
    if request.method=='POST':
        na=request.POST.get('na')
       # na = na.replace("'","")
        ph=request.FILES.get('ph')
        fs=FileSystemStorage()
        fs.save('medapp/static/dpic/'+ph.name,ph)
        desc=request.POST.get('desc')
        desc = desc.replace("'","")
        sql="INSERT INTO `disease`( `dname`, `des`, `pic`) VALUES ('{}','{}','{}')".format(na,desc,ph.name)
        dbconnection.insert(sql)
    qry="select * from disease"
    data=dbconnection.selectall(qry)
    return render(request,'admin/add_des.html',{'data':data})

def add_doc(request):
    did=request.GET['did']
    if request.method=='POST':
        doc_id=request.POST.get('doc_id')
        qry="INSERT INTO `doc`(`doc_id`, `des_id`) VALUES ('"+doc_id+"','"+did+"')"
        dbconnection.insert(qry)
    # select data of all approved doctors, who not already assigned to the selected disease
    qry1="SELECT * FROM doc_reg WHERE NOT EXISTS (SELECT 1 FROM doc WHERE doc.doc_id = doc_reg.id and doc.des_id='"+did+"') and apr='1'"
    data=dbconnection.selectall(qry1)
    return render(request,'admin/add_doc.html',{'data':data})

def addloc(request):
    if request.method=='POST':
        dn=request.POST.get('dn')
        qry="INSERT INTO `district`( `dis`) VALUES ('"+dn+"')"
        dbconnection.insert(qry)
    qry1="select * from district"
    dis=dbconnection.selectall(qry1)
    return render(request,'admin/addloc.html',{'dis':dis})

def add_loc(request):
    did=request.GET['did']
    if request.method=='POST':
        loc=request.POST.get('loc')
        qry="INSERT INTO `location`( dis_id,loc) VALUES ('"+did+"','"+loc+"')"
        dbconnection.insert(qry)
    qry1="select * from location where dis_id='"+did+"'"
    loc=dbconnection.selectall(qry1)
    return render(request,'admin/add_loc.html',{'loc':loc})

def del_dis(request):
    did=request.GET['did']
    qry="delete from disease where id='"+did+"'"
    dbconnection.delete(qry)
    return HttpResponseRedirect('add_des')

def del_dist(request):
    did=request.GET['did']
    qry="delete from district where id='"+did+"'"
    dbconnection.delete(qry)
    return HttpResponseRedirect('addloc')

def del_loc(request):
    lid=request.GET['lid']
    did=request.GET['did']
    qry="delete from location where id='"+lid+"'"
    dbconnection.delete(qry)
    return HttpResponseRedirect('add_loc?did='+did)

def ap_doc(request):
    qry="SELECT * FROM doc_reg where apr=0"
    data=dbconnection.selectall(qry)
    return render(request,'admin/ap_doc.html',{'data':data})

def v_cer(request):
    did=request.GET['did']
    qry="SELECT certificate FROM `doc_reg` WHERE id='"+did+"'"
    data=dbconnection.select1(qry)
    return render(request,'admin/v_cer.html',{'data':data})

def ap_dc(request):
    did=request.GET['did']
    qry="UPDATE `log` SET `ustatus`=1 WHERE email='"+did+"'"
    dbconnection.update(qry)
    qry="UPDATE `doc_reg` SET `apr`=1 WHERE email='"+did+"'"
    dbconnection.update(qry)
    return HttpResponseRedirect('ap_doc')

def ap_med(request):
    qry='''SELECT * FROM med_reg INNER JOIN log ON log.email=med_reg.email where log.ustatus=0 and 
    log.utype="med_store"'''
    data=dbconnection.selectall(qry)
    return render(request,'admin/ap_med.html',{'data':data})

def v_lic(request):
    did=request.GET['did']
    qry="SELECT license FROM `med_reg` WHERE id='"+did+"'"
    data=dbconnection.select1(qry)
    return render(request,'admin/v_lic.html',{'data':data})

def ap_md(request):
    did=request.GET['did']
    qry="UPDATE `log` SET `ustatus`=1 WHERE email='"+did+"'"
    dbconnection.update(qry)
    qry="UPDATE `med_reg` SET `apr`=1 WHERE email='"+did+"'"
    dbconnection.update(qry)
    return HttpResponseRedirect('ap_med')

# USER

def userhome(request):
    return render(request,'user/userhome.html')

def sdoc(request):
    qry="select * from disease"
    data=dbconnection.selectall(qry)
    if request.method=='POST':
        dis=request.POST.get('dis')
        qry1="SELECT * FROM doc INNER JOIN doc_reg on doc.doc_id=doc_reg.id WHERE des_id='"+dis+"'"
        doc=dbconnection.selectall(qry1)
        return render(request,'user/sdoc.html',{'data':data,'doc':doc})
    return render(request,'user/sdoc.html',{'data':data})

def fdoc(request):
    qry="select * from district"
    dis=dbconnection.selectall(qry)
    if request.method=='POST':
        dis=request.POST.get('dis')
        return HttpResponseRedirect('fdoc1?dis='+dis)
    return render(request,'user/fdoc.html',{'dis':dis})

def fdoc1(request):
    dis=request.GET['dis']
    qry="select * from location where dis_id='"+dis+"'"
    loc=dbconnection.selectall(qry)
    if request.method=='POST':
        lo=request.POST.get('loc')
        qry1="SELECT * FROM `doc_reg` WHERE loc='"+lo+"' and apr=1"
        doc=dbconnection.selectall(qry1)
        return render(request,'user/fdoc1.html',{'doc':doc,'loc':loc})
    return render(request,'user/fdoc1.html',{'loc':loc})

def smed1(request):
    qry="select * from district"
    loc=dbconnection.selectall(qry)
    doc='no_data'
    if request.method=='POST':
        #dis=request.POST.get('dis')
        lo=request.POST.get('s')
        qry1="SELECT * FROM `med_reg` WHERE loc='"+lo+"' and apr='1'"
        doc=dbconnection.selectall(qry1)
        if doc==():doc=None
    return render(request,'user/smed1.html',{'doc':doc,'loc':loc})

def get_subcat(request):
    cat=request.POST.get('c')
    qr="select * from location where dis_id='"+cat+"'"
    get_subcat=dbconnection.selectall(qr)
    sublist={}
    for sub in get_subcat:
        sublist[sub[0]]=sub[2]
    return JsonResponse({'res':sublist})

def snd_msg(request):
    mid=request.GET.get('mid')
    em=request.session['em']
    if request.method=='POST':
        msg=request.POST.get('msg')
        d=date.today()
        qry="INSERT INTO `med_msg`(`med`, `msg`, `uemail`, `date`) VALUES ('"+mid+"','"+msg+"','"+em+"','"+str(d)+"')"
        dbconnection.insert(qry)
    qry="select * from med_msg where uemail='"+em+"' and med='"+mid+"'"
    data=dbconnection.selectall(qry)
    # code to view reply
    msid=request.GET.get('msid') 
    if msid:
        qry="SELECT * FROM `med_msg` WHERE id='"+msid+"'"
        rep=dbconnection.select1(qry)
        return render(request,'user/snd_msg.html',{'data':data,'rep':rep,'mid':mid})
    return render(request,'user/snd_msg.html',{'data':data,'mid':mid})

def del_msg(request):
    msid=request.GET['msid']
    mid=request.GET['mid']
    qry="delete from med_msg where id='"+msid+"'"
    dbconnection.delete(qry)
    return HttpResponseRedirect('snd_msg?mid='+mid)

@reg.filter
def get_nearest_weekday(weekday_name):
    days = {day: i for i, day in enumerate(calendar.day_name)}
    today_idx = datetime.today().weekday()
    target_idx = days[weekday_name]
    delta_days = (target_idx - today_idx) % 7 or 7  
    return (datetime.today() + timedelta(days=delta_days)).strftime("%Y-%m-%d")

def b_apnt(request):
    dem=request.GET['dem']
    days=list(calendar.day_name)
    qry="SELECT * FROM mng_time WHERE email='"+dem+"'"
    data=[list(i) for i in dbconnection.selectall(qry)]
    days_ = [i[2] for i in data]
    for slot in data:
        upcoming_date = get_nearest_weekday(slot[2])
        qry2 = f"select count(*) from appointments where slot_id = {slot[0]} and date = '{upcoming_date}'"
        count = dbconnection.select1(qry2)[0]
        slot.append(True) if count < slot[5] else slot.append(False)
        slot.append(upcoming_date)
    return render(request,'user/b_apnt.html',{'days':days,'data':data, 'days_':days_})

def book(request):
    s_id=request.GET['s_id']
    did=request.GET['did']
    uem=request.session['em']
    sql="select name from reg where email='"+uem+"'"
    uinfo=dbconnection.select1(sql)
    qry_1 = f"select day from mng_time where id = {s_id}"
    dt=get_nearest_weekday(dbconnection.select1(qry_1)[0])
    # checking this sloat(time) is free or not (by comparing no. of patients who can book and no of appointments of that sloat)
    qr="SELECT pat_no FROM mng_time WHERE id='"+s_id+"'"
    pn=dbconnection.select1(qr)
    sq="SELECT COUNT(*) FROM appointments where slot_id='"+s_id+"'"
    cnt=dbconnection.select1(sq)
    if pn==cnt:
        easygui.msgbox('slot already booked. Please select another slot')
    else:
        qry="INSERT INTO `appointments`(`uname`, `doc`, `date`, `name`, `slot_id`) VALUES ('"+uem+"','"+did+"','"+str(dt)+"','"+uinfo[0]+"','"+s_id+"')"
        dbconnection.insert(qry)
        qry="SELECT id FROM appointments ORDER BY id DESC LIMIT 1"
        ap_id=dbconnection.select1(qry)
        return HttpResponseRedirect('booked?ap_id='+str(ap_id[0]))
    return HttpResponseRedirect("b_apnt?dem="+did)

def booked(request):
    ap_id=request.GET['ap_id']
    qry="SELECT * FROM appointments INNER JOIN mng_time on appointments.slot_id=mng_time.id INNER JOIN doc_reg on appointments.doc=doc_reg.email where appointments.id='"+ap_id+"'"
    data=dbconnection.select1(qry)
    return render(request,'user/booked.html',{'data':data})

# medical store
def medhome(request):
    em=request.session['em']
    qry="SELECT STATUS FROM `med_reg` WHERE email='"+em+"'"
    st=dbconnection.select1(qry)
    return render(request,'medical/medhome.html',{'st':st[0]})

def v_msg(request):
    em=request.session['em']
    mid=request.GET.get('mid') # when click on 'give reply' button question id will be there otherwise None
    if request.method=='POST':
        reply=request.POST.get('re')
        sql="UPDATE `med_msg` SET `reply`='"+reply+"' WHERE id='"+str(mid)+"'"
        dbconnection.update(sql)
    # select id of the currenty login pharmary
    qry="SELECT id FROM `med_reg` WHERE email='"+em+"'"
    id=dbconnection.select1(qry)
    # select messages send by the user to this pharmacy of id = id
    qry1=f"""SELECT med_msg.id,med_msg.msg,med_msg.date,reg.name FROM med_msg INNER JOIN reg ON 
    med_msg.uemail = reg.email WHERE med = {str(id[0])} AND reply =''"""
    data=dbconnection.selectall(qry1)
    if mid: # True when click on 'give reply' button
        return render(request,'medical/v_msg.html',{'data':data,'mid':int(mid)})
    return render(request,'medical/v_msg.html',{'data':data})

def shop_cld(request):
    em=request.session['em']
    qry="UPDATE `med_reg` SET `status`=0 WHERE email='"+em+"'"
    dbconnection.update(qry)
    return HttpResponseRedirect('medhome')

def shop_op(request):
    em=request.session['em']
    qry="UPDATE `med_reg` SET `status`=1 WHERE email='"+em+"'"
    dbconnection.update(qry)
    return HttpResponseRedirect('medhome')

# DOCTOR

def dochome(request):
    return render(request,'doctor/dochome.html')
def mng_time(request):
    em=request.session['em']
    if request.method=='POST':
        d=request.POST.get('d')
        st=request.POST.get('st')
        et=request.POST.get('et')
        np=request.POST.get('np')
        qry="INSERT INTO `mng_time`(`email`, `day`, `start`, `end`,`pat_no`) VALUES ('"+em+"','"+d+"','"+str(st)+"','"+str(et)+"','"+np+"')"
        dbconnection.insert(qry)
    qry1="select * from mng_time where email='"+em+"'"
    data=dbconnection.selectall(qry1)
    return render(request,'doctor/mng_time.html',{'data':data})
def v_app(request):
    em=request.session['em']
    qry=f"""select * from appointments INNER JOIN mng_time on appointments.slot_id=mng_time.id 
            where doc='{em}' and date >= curdate() order by date"""
    data=dbconnection.selectall(qry)
    return render(request,'doctor/v_app.html',{'data':data})
def dl_time(request):
    id=request.GET['id']
    qry="delete from mng_time where id='"+id+"'"
    dbconnection.insert(qry)
    return HttpResponseRedirect('mng_time')