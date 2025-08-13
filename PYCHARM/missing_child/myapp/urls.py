
from django.contrib import admin
from django.urls import path,include

from myapp import views

urlpatterns = [
    path('',views.login),
    path('login_post',views.login_post),
    path('logout',views.logout),
    path('adminhomepage',views.adminhomepage),
    path('adminmanagehelpline',views.adminmanagehelpline),
    path('edit_helpline/<id>',views.edit_helpline),
    path('edit_helpline_post',views.edit_helpline_post),
    path('adminmanagehelpline_post',views.adminmanagehelpline_post),
    path('adminviewhelpline', views.adminviewhelpline),
    path('delete_adminhelpline/<id>', views.delete_adminhelpline),
    path('adminviewemergencycomplaint', views.adminviewemergencycomplaint),
    path('adminviewemergencycomplaint_post', views.adminviewemergencycomplaint_post),
    path('adminviewmissingcase', views.adminviewmissingcase),
    path('adminviewmissingcase_post',views.adminviewmissingcase_post),
    path('adminviewupdate', views.adminviewupdate),
    path('adminviewcomplaint', views.adminviewcomplaint),
    path('adminviewcomplain_post', views.adminviewcomplain_post),
    path('sendreply/<id>',views.sendreply),
    path('sendreply_post', views.sendreply_post),
    path('adminviewfeedback', views.adminviewfeedback),
    path('adminviewfeedback_post', views.adminviewfeedback_post),
    path('adimcameramanagement', views.adimcameramanagement),
    path('adimcameramanagement_post', views.adimcameramanagement_post),
    path('edit_admincamera/<id>', views.edit_admincamera),
    path('edit_admincamera_post',views.edit_admincamera_post),
    path('adminviewcamera', views.adminviewcamera),
    path('adminviewcamera_post', views.adminviewcamera_post),
    path('delete_admincamera/<id>', views.delete_admincamera),


    path('childhelplinehomepage', views.childhelplinehomepage),
    path('addnotification',views.addnotification),
    path('addnotification_post',views.addnotification_post),
    path('updatestatus/<id>',views.updatestatus),
    path('updatestatus_post',views.updatestatus_post),
    path('viewemergencyhelpline',views.viewemergencyhelpline),
    path('viewnotification',views.viewnotification),
    path('delete_viewnotification/<id>',views.delete_viewnotification),
    path('editviewnotification/<id>' , views.editviewnotification),
    path('editviewnotification_post' , views.editviewnotification_post),
    path('viewnotificationfromcamera',views.viewnotificationfromcamera),
    path('viewmissingcaseandupdate',views.viewmissingcaseandupdate),
    path('reply/<id>' , views.reply),
    path('reply_post' , views.reply_post),
    path('chatwithuser', views.chatwithuser),
    path('chatview', views.chatview),
    # path('coun_insert_chat', views.coun_insert_chat),
    path('coun_msg/<id>',views.coun_msg),
    path('coun_insert_chat/<str:msg><int:senid>', views.coun_insert_chat, name='coun_insert_chat'),
    path('view_user', views.view_user),
    path('child_chat_to_user/<id>', views.child_chat_to_user),
    path('chat_view', views.chat_view),
    path('chat_send/<msg>', views.chat_send),




    path('android_login',views.android_login),
    path('user_register',views.user_register),
    path('managechildmissingcase',views.managechildmissingcase),
    path('user_view_missingcase',views.user_view_missingcase),
    path('notification',views.notification),
    path('user_view_notification',views.user_view_notification),
    path('updates',views.updates),
    path('user_view_updtes',views.user_view_updtes),
    path('emergencycomplaint',views.emergencycomplaint),
    path('user_view_emergency',views.user_view_emergency),
    path('feedback',views.feedback),
    path('user_view_feedback',views.user_view_feedback),
    path('complaint_and_reply',views.complaint_and_reply),
    path('user_view_complaint',views.user_view_complaint),
    path('user_view_helpline',views.user_view_helpline),
    path('sendemgcomplaint',views.sendemgcomplaint),
    path('viewchat',views.viewchat),
    path('sendchat',views.sendchat),
    path('user_view_updates',views.user_view_updates),
    path('view_missingcase_updates',views.view_missingcase_updates),
    path('delete_missing_case',views.delete_missing_case),
    path('add_missing_case',views.add_missing_case),
    path('edit_missing_case',views.edit_missing_case),
    path('user_view_my_missingcase',views.user_view_my_missingcase),
    path('delete_complaint',views.delete_complaint),
    # path('child_chat_to_user', views.child_chat_to_user, name='child_chat_to_user'),
    path('chatwithuser', views.chatwithuser),
    path('chatview', views.chatview),
    path('registrationcode', views.registrationcode),
    # path('coun_insert_chat', views.coun_insert_chat),
    path('coun_msg/<id>',views.coun_msg),
    path('/coun_insert_chat/<str:msg><int:senid>', views.coun_insert_chat, name='coun_insert_chat'),
    path('forget_password_post',views.forget_password_post),









]
