from django.urls import path
from .views import (
    dashboard_view,
    password_reset_email_view, verify_otp_view, password_reset_confirm_view, change_password_view, instruction_view, test_view,video_feed,stop_video_feed,stop_and_restart_view,blog_view,letters,services,video_feed_tf,number_test_view
)

urlpatterns = [
    # path('register/', register_view, name='register'),
    # path('login/', login_view, name='login'),
    # path('logout/', logout_view, name='logout'),
    path('', dashboard_view, name='dashboard'),
    path('password-reset/', password_reset_email_view, name='password_reset'),
    path('verify-otp/', verify_otp_view, name='verify_otp'),
    path('password-reset-confirm/', password_reset_confirm_view, name='password_reset_confirm'),

    path('change-password/', change_password_view, name='change_password'),
    


    path('instruction/', instruction_view, name='instruction'),
    path('blogs/', blog_view, name='blogs'),
    path('letters/', letters, name='letters'),
    path('services/', services, name='services'),

    path('test/', test_view, name='test'),
    path('video_feed/', video_feed, name='video_feed'),
    path('stop_video_feed/', stop_video_feed, name='stop_video_feed'),
    path('stop-and-restart/', stop_and_restart_view, name='stop_and_restart_view'),


    path('number_test_view/', number_test_view, name='number_test_view'),    
    path('video_feed_tf/', video_feed_tf, name='video_feed_tf'),
    
    
]
