from django.urls import path
from medapp import views
urlpatterns=[
    path('',views.index),
    path('login',views.login),
    path('register',views.register),
    path('doc_reg',views.doc_reg),
    path('doc_reg1',views.doc_reg1),
    path('med_reg',views.med_reg),
    path('med_reg1',views.med_reg1),
    path('dis_pr',views.dis_pr),
    path('prediction',views.prediction),
    #ADMIN
    path('admhome',views.admhome),
    path('add_des',views.add_des),
    path('add_doc',views.add_doc),
    path('addloc',views.addloc),
    path('add_loc',views.add_loc),
    path('del_dis',views.del_dis),
    path('del_dist',views.del_dist),
    path('del_loc',views.del_loc),
    path('ap_doc',views.ap_doc),
    path('ap_med',views.ap_med),
    path('v_cer',views.v_cer),
    path('v_lic',views.v_lic),
    path('ap_dc',views.ap_dc),
    path('ap_md',views.ap_md),
    #USER
    path('userhome',views.userhome),
    path('sdoc',views.sdoc),
    path('fdoc',views.fdoc),
    path('fdoc1',views.fdoc1),
    path('smed1',views.smed1),
    path('snd_msg',views.snd_msg),
    path('del_msg',views.del_msg),
    path('b_apnt',views.b_apnt),
    path('book',views.book),
    path('get_subcat',views.get_subcat),
    path('booked',views.booked),

    #medical store
    path('medhome',views.medhome),
    path('v_msg',views.v_msg),
    path('shop_cld',views.shop_cld),
    path('shop_op',views.shop_op),

    # doctor
    path('dochome',views.dochome),
    path('mng_time',views.mng_time),
    path('v_app',views.v_app),
    path('dl_time',views.dl_time),
]