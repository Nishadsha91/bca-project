import datetime

from django.contrib.auth.decorators import login_required
from django.core.files.storage import FileSystemStorage
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, redirect

# Create your views here.
from missing_child import settings
from myapp.models import *
from django.contrib import auth



def logout(request):
    auth.logout(request)
    return render(request,'index.html')

def login(request):
    return render(request,'index.html')
def login_post(request):
    username=request.POST['textfield']
    password=request.POST['textfield2']
    a=login_table.objects.filter(username=username,password=password)
    if a.exists():
        b = login_table.objects.get(username=username, password=password)
        request.session['lid']=b.id
        if b.type=='admin':
            ob1 = auth.authenticate(username='admin', password='admin')
            if ob1 is not None:
                auth.login(request, ob1)
            return HttpResponse('''<script>window.location='/adminhomepage'</script>''')

        elif b.type == 'childhelpline':
            ob1 = auth.authenticate(username='admin', password='admin')
            if ob1 is not None:
                auth.login(request, ob1)
            return HttpResponse('''<script>;window.location='/childhelplinehomepage'</script>''')
        else:
            return HttpResponse('''<script>alert('invalid');window.location='/'</script>''')
    else:
        return HttpResponse('''<script>alert('invalid');window.location='/'</script>''')


@login_required(login_url='/')
def adminhomepage(request):
    return render(request,'admin/index.html')

@login_required(login_url='/')
def adminmanagehelpline(request):
    return render(request,'admin/adminmanagehelpline.html')

@login_required(login_url='/')
def edit_helpline(request,id):
    request.session['id']=id
    ob=childhelpline_table.objects.get(id=id)
    return render(request, 'admin/edit.html',{'data':ob})

@login_required(login_url='/')
def edit_helpline_post(request):
    Name=request.POST['textfield1']
    Email=request.POST['textfield2']
    Phone=request.POST['textfield3']
    Place=request.POST['textfield4']
    Pincode=request.POST['textfield5']
    Post=request.POST['textfield6']
    Latitude=request.POST['textfield7']
    Logitude=request.POST['textfield8']




    b=childhelpline_table.objects.get(id=request.session['id'])
    b.name=Name
    b.email=Email
    b.phone=Phone
    b.place=Place
    b.pin=Pincode
    b.post=Post
    b.latitude=Latitude
    b.logitude=Logitude
    b.save()
    return HttpResponse('''<script>alert('Registerd');window.location='/adminhomepage'</script>''')

@login_required(login_url='/')
def adminmanagehelpline_post(request):
    Name=request.POST['textfield']
    Email=request.POST['textfield2']
    Phone=request.POST['textfield3']
    Place=request.POST['textfield4']
    Pincode=request.POST['textfield5']
    Post=request.POST['textfield6']
    Latitude=request.POST['textfield7']
    Logitude=request.POST['textfield8']


    a=login_table()
    a.username=Email
    a.password=Phone
    a.type='childhelpline'
    a.save()

    b=childhelpline_table()
    b.LOGIN=a
    b.name=Name
    b.email=Email
    b.phone=Phone
    b.place=Place
    b.pin=Pincode
    b.post=Post
    b.latitude=Latitude
    b.logitude=Logitude
    b.save()
    return HttpResponse('''<script>alert('Registerd');window.location='/adminhomepage'</script>''')

@login_required(login_url='/')
def adminviewhelpline(request):
    a=childhelpline_table.objects.all()
    return render(request,'admin/adminviewhelpline.html',{'data':a})


@login_required(login_url='/')
def delete_adminhelpline(request,id):
    a=childhelpline_table.objects.get(id=id)
    a.cameranumber.delete()
    a.delete()
    return redirect('/adminviewhelpline')


@login_required(login_url='/')
def adminviewemergencycomplaint(request):
    a=emergencycomplaint_table.objects.all()
    return render(request,'admin/adminviewemergencycomplaint.html',{'data':a})


@login_required(login_url='/')
def adminviewemergencycomplaint_post(request):
    date=request.POST['date']
    a = emergencycomplaint_table.objects.filter(date__exact=date)
    return render(request, 'admin/adminviewemergencycomplaint.html', {'data': a})


@login_required(login_url='/')
def adminviewmissingcase(request):
    a=missingcase_table.objects.all()
    return render(request,'admin/adminviewmissingcase.html',{'data':a})

@login_required(login_url='/')
def adminviewmissingcase_post(request):
    date=request.POST['date']
    a = missingcase_table.objects.filter(missingdate__exact=date)
    return render(request, 'admin/adminviewmissingcase.html', {'data': a})

@login_required(login_url='/')
def adminviewupdate(request):
    a=update_table.objects.all()
    return render(request,'admin/adminviewupdate.html',{'data':a})

@login_required(login_url='/')
def adminviewcomplaint(request):
    a=complaint_table.objects.all().order_by('-id')
    return render(request,'admin/adminviewcomplaint.html',{'data':a})

@login_required(login_url='/')
def adminviewcomplain_post(request):
    date=request.POST['date']
    a = complaint_table.objects.filter(date__exact=date)
    return render(request, 'admin/adminviewcomplaint.html', {'data': a})

@login_required(login_url='/')
def sendreply(request,id):
    a=complaint_table.objects.get(id=id)
    return render(request,'admin/sendreply.html',{'data':a})

@login_required(login_url='/')
def sendreply_post(request):
    id=request.POST['id']
    reply=request.POST['reply']
    a=complaint_table.objects.get(id=id)
    a.reply=reply
    a.save()
    return redirect('/adminviewcomplaint')




@login_required(login_url='/')
def adminviewfeedback(request):
    a=feedback_table.objects.all()
    return render(request,'admin/adminviewfeedback.html',{'data':a})


@login_required(login_url='/')
def adminviewfeedback_post(request):
    date=request.POST['date']
    a = feedback_table.objects.filter(date__exact=date)
    return render(request, 'admin/adminviewfeedback.html', {'data': a})

@login_required(login_url='/')
def adimcameramanagement(request):
    return render(request,'admin/adimcameramanagement.html')
def adimcameramanagement_post(request):
    CameraNumber=request.POST['textfield']
    Latitude=request.POST['textfield2']
    Logitude=request.POST['textfield3']


    a=camera_table()
    a.cameranumber=CameraNumber
    a.latitude=Latitude
    a.logitude=Logitude
    a.save ()
    return HttpResponse('''<script>alert('Added');window.location='/adminhomepage'</script>''')

@login_required(login_url='/')
def edit_admincamera(request,id):
    request.session['id']=id
    ob=camera_table.objects.get(id=id)
    return render(request, 'admin/editcamera.html',{'data':ob})

@login_required(login_url='/')
def edit_admincamera_post(request):
    CameraNumber = request.POST['textfield']
    Latitude = request.POST['textfield2']
    Logitude = request.POST['textfield3']
    a = camera_table.objects.get(id=request.session['id'])
    a.cameranumber = CameraNumber
    a.latitude = Latitude
    a.logitude = Logitude
    a.save()
    return HttpResponse('''<script>alert('Added');window.location='/adminhomepage'</script>''')

@login_required(login_url='/')
def adminviewcamera(request):
    a=camera_table.objects.all()
    return render(request,'admin/adminviewcamera.html',{'data':a})


@login_required(login_url='/')
def adminviewcamera_post(request):
    date=request.POST['date']
    a = camera_table.objects.filter(date__exact=date)
    return render(request, 'admin/adminviewcamera.html', {'data': a})


@login_required(login_url='/')
def delete_admincamera(request,id):
    a=camera_table.objects.get(id=id)
    a.delete()
    return redirect('/adminviewcamera')





@login_required(login_url='/')
def childhelplinehomepage(request):
    return render(request,'child help line/index.html')

@login_required(login_url='/')
def viewmissingcaseandupdate(request):
    ob = missingcase_table.objects.all()
    return render(request,'child help line/viewverifiedmissingcaseandupdate.html',{'data':ob})

@login_required(login_url='/')
def updatestatus(request,id):
    request.session['mid']=id
    ob=missingcase_table.objects.get(id=id)
    return render(request,'child help line/updatestatus.html',{'val':ob})

@login_required(login_url='/')
def updatestatus_post(request):
    Description=request.POST['textfield']

    ob=update_table()
    ob.MISSINGCASEID=missingcase_table.objects.get(id=request.session['mid'])
    ob.description = Description
    ob.date = datetime.datetime.now().today().date()
    ob.save()
    return HttpResponse('''<script>alert('updated');window.location='/viewmissingcaseandupdate'</script>''')

@login_required(login_url='/')
def addnotification(request):
    return render(request,'child help line/addnotification.html')

@login_required(login_url='/')
def addnotification_post(request):
    Heading=request.POST['textfield']
    Description=request.POST['textfield2']
    ob=notification_table()
    ob.heading=Heading
    ob.description=Description
    ob.date=datetime.datetime.now().today().date()
    ob.save()
    return HttpResponse('''<script>alert('Added');window.location='/viewnotification'</script>''')


@login_required(login_url='/')
def childaddnotification(request):
    return render(request,'child help line/addnotification.html')

@login_required(login_url='/')
def viewnotification(request):
    ob=notification_table.objects.all()
    return render(request,'child help line/viewnotification.html',{"data":ob})

@login_required(login_url='/')
def delete_viewnotification(request,id):
    ob=notification_table.objects.get(id=id)
    ob.delete()
    return redirect('/viewnotification')


@login_required(login_url='/')
def editviewnotification(request,id):
    request.session['id']=id
    ob=notification_table.objects.get(id=id)
    return render(request,'child help line/editviewnotification.html',{"data":ob})

@login_required(login_url='/')
def editviewnotification_post(request):
    Heading = request.POST['textfield']
    Description = request.POST['textfield2']
    ob = notification_table.objects.get(id=request.session['id'])
    ob.heading = Heading
    ob.description = Description
    ob.save()
    return HttpResponse('''<script>alert('Added');window.location='/viewnotification'</script>''')

@login_required(login_url='/')
def viewnotificationfromcamera(request):
    ob = cameranotification_table.objects.all().order_by("-id")
    return render(request,'child help line/viewnotificationfromcamera.html',{"data":ob})

@login_required(login_url='/')
def viewemergencyhelpline(request):
    ob = emergencycomplaint_table.objects.filter(CHILDLINE__LOGIN_id=request.session['lid'])
    return render(request,'child help line/viewemergencyhelpline.html',{"data":ob})

@login_required(login_url='/')
def reply(request,id):
    ob= emergencycomplaint_table.objects.get(id=id)
    request.session['id']=id
    return render(request,'child help line/reply.html',{"data":ob})

@login_required(login_url='/')
def reply_post(request):
    reply = request.POST['reply']
    a=emergencycomplaint_table.objects.get(id=request.session['id'])
    a.reply=reply
    a.save()
    return HttpResponse('''<script>alert('Replied');window.location='/viewemergencyhelpline'</script>''')
#
# def view_user(request):
#     ob=user_table.objects.all().order_by('-id')p
#
#     return render(request,'child help line/view_user.html',{'data':ob})


from django.db.models import Count

from django.db.models import Count


# def view_user(request):
#     # Fetching all users ordered by their id
#     users = user_table.objects.all().order_by('-id')
#
#     pending_counts = {}
#
#     for user in users:
#         pending_count = chat_table.objects.filter(TOID=user.LOGIN).count()
#         pending_counts[user.id] = pending_count
#
#     # Pass both the users and the pending_counts dictionary to the template
#     return render(request, 'child help line/view_user.html', {'users': users, 'pending_counts': pending_counts})

def view_user(request):
    # Fetching all users ordered by their id
    users = user_table.objects.all().order_by('-id')

    # Initialize an empty dictionary to store the pending counts
    pending_counts = {}

    # Loop through each user and calculate their pending message count
    for user in users:
        login_id = user.LOGIN.id  # Access the login ID associated with the user
        # Count the number of pending messages for this user's login (TOID matches LOGIN)
        pending_count = chat_table.objects.filter(TOID__id=login_id, status='pending').count()
        # Store the pending count in the dictionary using the user's ID as the key
        pending_counts[user.id] = pending_count

    # Pass both the users and the pending_counts dictionary to the template
    return render(request, 'child help line/view_user.html', {'users': users, 'pending_counts': pending_counts})


def android_login(request):
    username=request.POST['username']
    password=request.POST['password']
    a = login_table.objects.filter(username=username, password=password)
    if a.exists():
        b = login_table.objects.get(username=username, password=password)
        if b.type == 'user':
           return JsonResponse({'status':'ok','lid':str(b.id),'type':b.type})

        else:
            return JsonResponse({'status':'invalid'})
    else:
        return JsonResponse({'status': 'invalid'})


def user_register(request):
    name=request.POST['name']
    email=request.POST['email']
    phone=request.POST['phone']
    place=request.POST['place']
    pin=request.POST['pin']
    post=request.POST['post']
    password=request.POST['password']
    image=request.FILES['image']
    fs=FileSystemStorage()
    path=fs.save(image.name,image)

    a=login_table()
    a.password=password
    a.username=email
    a.type='user'
    a.save()

    b=user_table()
    b.LOGIN=a
    b.name=name
    b.email=email
    b.phone=phone
    b.place=place
    b.pin=pin
    b.post= post
    b.image=path
    b.save()
    return JsonResponse({'status': 'ok'})


def managechildmissingcase(request):
    lid=request.POST['lid']
    childname=request.POST['childname']
    childimage=request.FILES['childname']
    age=request.POST['age']
    description=request.POST['description']
    missingdate=request.POST['missingdate']
    uploaddate=request.POST['uploaddate']

    a=missingcase_table()
    a.USERID=user_table.objects.get(LOGIN__id=lid)
    a.childname=childname
    a.childimage=childimage
    a.age=age
    a.description=description
    a.missingdate=missingdate
    a.uploaddate=uploaddate
    a.save()
    return JsonResponse({'status': 'ok'})


def user_view_missingcase(request):
    lid=request.POST['lid']
    a=missingcase_table.objects.all().exclude(USERID__LOGIN__id=lid).order_by('-id')
    l=[]
    for i in a:
        l.append({'id':i.id,'childname':i.childname,'age':str(i.age),
                  'childimage':i.childimage.url[1:],'description':i.description,'missingdate':str(i.missingdate),
                  'uploaddate':str(i.uploaddate)})
    print(l)
    return JsonResponse({"status": 'ok', 'data': l})



def user_view_my_missingcase(request):
    lid=request.POST['lid']
    a=missingcase_table.objects.filter(USERID__LOGIN__id=lid)
    l=[]
    for i in a:
        l.append({'id':i.id,'childname':i.childname,'age':str(i.age),
                  'childimage':i.childimage.url[1:],'description':i.description,'missingdate':str(i.missingdate),
                  'uploaddate':str(i.uploaddate)})
    return JsonResponse({"status": 'ok', 'data': l})



def user_view_updates(request):
    a=update_table.objects.all()
    l=[]
    for i in a:
        l.append({'id':i.id, 'description':i.description, 'date':str(i.date)})
        return JsonResponse({"status": 'ok', 'data': l})


def view_missingcase_updates(request):
    if request.method == "POST":
        case_id = request.POST.get("case_id")
        updates = update_table.objects.filter(MISSINGCASEID_id=case_id)
        l = []
        for update in updates:
            l.append({
                'description': update.description,
                'date': str(update.date),
            })
        return JsonResponse({"status": "ok", "data": l})
    else:
        return JsonResponse({"status": "error", "message": "Invalid request"})

def notification(request):
    heading=request.POST['heading']
    description=request.POST['description']
    date=request.POST['date']


def user_view_notification(request):
    a=notification_table.objects.all()
    l=[]
    for i in a:
        l.append({'id':i.id,'heading':i.heading,'description':i.description,'date':str(i.date)})
    return JsonResponse({"status": 'ok', 'data': l})


def updates(request):
    mid = request.POST['mid']
    description= request.POST['description']
    date=request.POST['date']

def user_view_updtes(request):
    a = update_table.objects.all()
    l = []
    for i in a:
        l.append({'id':i.id,'description':i.description,'date':str(i.date)})
    return JsonResponse({"status": 'ok', 'data': l})

def emergencycomplaint(request):
    hid = request.POST['hid']
    lid = request.POST['lid']
    message=request.POST['message']
    date=request.POST['date']
    status=request.POST['status']
    reply=request.POST['reply']

    a=emergencycomplaint_table()
    a.CHILDLINE=emergencycomplaint_table.objects.get(cid=id)
    a.USERID=user_table.objects.get(LOGIN__id=lid)
    message=message
    date=date
    status=status
    reply=reply
    a.save()
    return JsonResponse({'status': 'ok'})


def user_view_helpline(request):
    a=childhelpline_table.objects.all()
    l=[]
    for i in a:
        l.append({'id':i.id,
                  "lid":i.LOGIN.id,
            'name':i.name,
            'phone':str(i.phone),
            'place':str(i.place),
            'post':str(i.post),
            'email':str(i.email),


                  })
    print(l)
    return JsonResponse({'status':'ok','data':l})

def user_view_emergency(request):
    hid=request.POST['hid']
    lid=request.POST['lid']
    a = emergencycomplaint_table.objects.filter(CHILDLINE__id=hid,USERID__LOGIN__id=lid)
    l = []
    for i in a:
        l.append({'id':i.id,'message':i.message,'date':str(i.date),'status':i.status,
                  'reply':str(i.reply)})
    return JsonResponse({"status": 'ok','data':l})


def sendemgcomplaint(request):
    lid = request.POST['lid']
    hid=request.POST['hid']
    msg=request.POST['msg']
    a=emergencycomplaint_table()
    a.USERID = user_table.objects.get(LOGIN__id=lid)
    a.CHILDLINE = childhelpline_table.objects.get(id=hid)
    a.message=msg
    a.reply='pending'
    a.date=datetime.datetime.today()
    a.save()
    return JsonResponse({"task": 'ok'})




def feedback(request):
    print(request.POST,'kkkkkkkkkkkkk')
    lid = request.POST['lid']
    description=request.POST['description']
    rating=request.POST['rating']

    a=feedback_table()
    a.USERID = user_table.objects.get(LOGIN__id=lid)
    a.description=description
    a.rating=rating
    a.date=datetime.datetime.now().today()
    a.save()
    return JsonResponse({"status": 'ok'})

def user_view_feedback(request):
    a=feedback_table.objects.all()
    l=[]
    for i in a:
        l.append({'id':i.id,'description':i.description,'date':str(i.date)})
    return JsonResponse({"status": 'ok', 'data': l})


def complaint_and_reply(request):
    print(request.POST,'kkkkkkkkkkkkkkk')
    lid = request.POST['lid']
    description=request.POST['description']

    a=complaint_table()
    a.USERID = user_table.objects.get(LOGIN_id=lid)
    a.description=description
    a.reply='pending'
    a.date=datetime.datetime.now().today().date()
    a.save()
    return JsonResponse({"status": 'ok'})



def viewreply(request):
    lid=request.POST["lid"]
    ob=complaint_table.objects.filter(USER=lid)
    print(ob,"hhhhhhhhhhhhh")
    mdata=[]
    for i in ob:
        data={'description':i.description,'reply':i.reply,'date':str(i.date)}
        mdata.append(data)
        print(mdata)
        return JsonResponse({"status":"ok","data":mdata})



def user_view_complaint(request):
    print(request.POST,'ppppppppppppppppppp')
    lid = request.POST['lid']
    a=complaint_table.objects.filter(USERID__LOGIN_id=lid)
    l=[]
    for i in a:
        l.append({'id':i.id,'description':i.description,'reply':i.reply,'date':str(i.date)})
    return JsonResponse({"status": 'ok', 'data': l})




def viewchat(request):
    print(request.POST)
    fromid = request.POST['from_id']
    toid=request.POST['to_id']
    ob1 = chat_table.objects.filter(FROMID__id=fromid, TOID__id=toid)
    ob2 = chat_table.objects.filter(FROMID__id=toid, TOID__id=fromid)
    combined_chat = ob1.union(ob2)
    combined_chat = combined_chat.order_by('id')
    res = []
    for i in combined_chat:
        res.append({'msg': i.message, 'fromid': i.FROMID.id, 'toid': i.TOID.id, 'date':i.date})
    print(res,"===============================++++++++++++++++++++++++++++++++++========================")
    return JsonResponse({"status": "ok", "data": res})


def sendchat(request):
    print(request.POST)
    msg=request.POST['message']
    fromid=request.POST['fromid']
    toid=request.POST['toid']
    ob=chat_table()
    ob.message=msg
    ob.FROMID=login_table.objects.get(id=fromid)
    ob.TOID=login_table.objects.get(id=toid)
    ob.date=datetime.datetime.now().date()
    ob.save()
    return JsonResponse({"status": "ok"})








def notification(request):
    ob=notification_table.objects.all()


def missingcaseupdate(request):
    ob=missingcase_table.objects.all()
    ob=update_table.objects.all()


def delete_missing_case(request):
    id = request.POST['id']
    s = missingcase_table.objects.get(id=id)
    s.delete()
    return JsonResponse({'status':'success'})


def add_missing_case(request):
    lid = request.POST['id']
    childname=request.POST['childname']
    childimage=request.FILES['childname']
    age=request.POST['age']
    description=request.POST['description']
    missingdate=request.POST['missingdate']

    a=missingcase_table()
    a.USERID=user_table.objects.get(LOGIN__id=lid)
    a.childname=childname
    a.childimage=childimage
    a.age=age
    a.description=description
    a.missingdate=missingdate
    a.uploaddate=datetime.datetime.now().today().date()
    a.save()
    return JsonResponse({'status': 'ok'})

def edit_missing_case(request):
    id = request.POST['case_id']
    missing = missingcase_table.objects.get(id=id)
    missing.childname = request.POST['childname']
    missing.age = request.POST['age']
    missing.description = request.POST['description']
    missing.missingdate = request.POST['missingdate']
    if 'image' in request.FILES:
        image = request.FILES['image']
        fs = FileSystemStorage()
        fp = fs.save(image.name,image)
        missing.childimage = fp
        missing.save()

    missing.save()
    return JsonResponse({'status':'ok'})


def delete_complaint(request):
    com = request.POST['complaint']
    c = complaint_table.objects.get(id=com)
    c.delete()
    return JsonResponse({'status':'ok'})


#
# def child_chat_to_user(request, id):
#     request.session["userid"] = id
#     cid = str(request.session["userid"])
#     request.session["new"] = cid
#     qry = user_table.objects.get(LOGIN=cid)
#     print(qry.login.id,'login----------')
#
#     return render(request, "child help line/Chat.html", { 'name': qry.name, 'toid': cid})
#     # return render(request, "shop/Chat.html", {'photo': qry.image, 'name': qry.name, 'toid': cid})


@login_required(login_url='/')
def chatwithuser(request):
    ob = user_table.objects.all()
    return render(request,"child help line/fur_chat.html",{'val':ob})



@login_required(login_url='/')
def chatview(request):
    ob = user_table.objects.all()
    d=[]
    for i in ob:
        r={"name":i.name,'email':i.email,'loginid':i.LOGIN.id}
        d.append(r)
    return JsonResponse(d, safe=False)




def coun_insert_chat(request,msg,senid):
    print("===",msg,id)
    print(request.POST,'==================')
    ob=chat_table()
    ob.FROMID=login_table.objects.get(id=request.session['lid'])
    ob.TOID=login_table.objects.get(id=senid)
    ob.message=msg
    ob.date=datetime.datetime.now().strftime("%Y-%m-%d")
    ob.save()

    return JsonResponse({"task":"ok"})
    # refresh messages chatlist


def coun_msg(request,id):

    ob1=chat_table.objects.filter(FROMID__id=id, TOID__id=request.session['lid'])
    ob2=chat_table.objects.filter(FROMID=request.session['lid'], TOID__id=id)
    combined_chat = ob1.union(ob2)
    combined_chat=combined_chat.order_by('id')
    res=[]
    for i in combined_chat:
        res.append({"from_id":i.FROMID.id,"msg":i.message,"date":i.date,"chat_id":i.id})

    obu=user_table.objects.get(LOGIN__id=id)


    return JsonResponse({"data":res,"name":obu.name,"user_lid":obu.LOGIN.id})




@login_required(login_url='/')
def child_chat_to_user(request, id):
    request.session["userid"] = id
    cid = str(request.session["userid"])
    request.session["new"] = cid
    qry = user_table.objects.get(LOGIN=cid)
    print(qry.LOGIN.id,'login----------')

    return render(request, "child help line/Chat.html", { 'name': qry.name, 'toid': cid})

@login_required(login_url='/')
def chat_view(request):
    fromid = request.session["lid"]
    toid = request.session["userid"]
    qry = user_table.objects.get(LOGIN_id=request.session["userid"])
    from django.db.models import Q

    res = chat_table.objects.filter(Q(FROMID_id=fromid, TOID_id=toid) | Q(FROMID_id=toid, TOID_id=fromid))
    l = []
    print(qry.name,'userssssssssss')

    for i in res:
        l.append({"id": i.id, "message": i.message, "to": i.TOID_id, "date": i.date, "from": i.FROMID_id})

    return JsonResponse({ "data": l, 'name': qry.name, 'toid': request.session["userid"]})

@login_required(login_url='/')
def chat_send(request, msg):
    lid = request.session["lid"]
    toid = request.session["userid"]
    message = msg

    import datetime
    d = datetime.datetime.now().date()
    chatobt = chat_table()
    chatobt.message = message
    chatobt.TOID_id = toid
    chatobt.FROMID_id = lid
    chatobt.date = d
    chatobt.save()

    return JsonResponse({"status": "ok"})

def registrationcode(request):
    print(request.POST)
    name = request.POST['nme']
    print(name,"nm")
    email = request.POST['email']
    phone = request.POST['phone']
    place = request.POST['place']
    pin = request.POST['pin']
    post = request.POST['post']
    # image = request.FILES['image']
    username = request.POST['username']
    password = request.POST['password']



    a = login_table()
    a.username = username
    a.password = password
    a.type = "user"
    a.save()

    b = user_table()
    b.name = name
    b.LOGIN = a
    b.email = email
    b.phone = phone
    b.place = place
    b.pin = pin
    b.post = post
    b.save()

    return JsonResponse({'status': 'ok'})






from django.core.mail import send_mail


def forget_password_post(request):
    em = request.POST['email']
    import random
    import string
    # password = random.randint(000000, 999999)
    log = login_table.objects.filter(username=em)

    length = 10 # Adjust the password length as needed
    chars = string.ascii_letters + string.digits + string.punctuation
    password = ''.join(random.choice(chars) for _ in range(length))

    if log.exists():
        logg = login_table.objects.get(username=em)
        message = 'temporary Password  is!... ' + str(password)
        send_mail(
            'temporary...! Password',            message,
            settings.EMAIL_HOST_USER,
            [em, ],
            fail_silently=False
        )
        logg.password = password
        logg.save()
        return JsonResponse({'status':'ok'})
    else:
        return JsonResponse({'status':'ok'})


