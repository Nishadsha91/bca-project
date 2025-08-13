from django.db import models

# Create your models here.
class login_table(models.Model):
    username=models.CharField(max_length=100)
    password=models.CharField(max_length=100)
    type=models.CharField(max_length=100)


class childhelpline_table(models.Model):
    LOGIN=models.ForeignKey(login_table,on_delete=models.CASCADE)
    name=models.CharField(max_length=100)
    email=models.CharField(max_length=100)
    phone=models.BigIntegerField()
    place=models.CharField(max_length=100)
    pin=models.BigIntegerField()
    post=models.CharField(max_length=100)
    latitude=models.CharField(max_length=100)
    logitude=models.CharField(max_length=100)

class user_table(models.Model):
    LOGIN=models.ForeignKey(login_table,on_delete=models.CASCADE)
    name=models.CharField(max_length=100)
    email=models.CharField(max_length=100)
    phone=models.BigIntegerField()
    place=models.CharField(max_length=100)
    pin=models.BigIntegerField()
    post=models.CharField(max_length=100)


class emergencycomplaint_table(models.Model):
    CHILDLINE=models.ForeignKey(childhelpline_table,on_delete=models.CASCADE)
    USERID=models.ForeignKey(user_table,on_delete=models.CASCADE)
    message=models.CharField(max_length=100)
    date=models.DateField()
    status=models.CharField(max_length=100)
    reply=models.CharField(max_length=100)

class missingcase_table(models.Model):
    USERID=models.ForeignKey(user_table,on_delete=models.CASCADE)
    childname=models.CharField(max_length=100)
    childimage=models.FileField()
    age=models.IntegerField()
    description=models.CharField(max_length=100)
    missingdate=models.DateField()
    uploaddate=models.CharField(max_length=50)

class complaint_table(models.Model):
    USERID = models.ForeignKey(user_table, on_delete=models.CASCADE)
    description=models.CharField(max_length=100)
    reply=models.CharField(max_length=100)
    date=models.DateField()

class feedback_table(models.Model):
    USERID = models.ForeignKey(user_table, on_delete=models.CASCADE)
    description = models.CharField(max_length=100)
    rating = models.FloatField()
    date = models.DateField()

class update_table(models.Model):
    MISSINGCASEID=models.ForeignKey(missingcase_table, on_delete=models.CASCADE)
    description = models.CharField(max_length=100)
    date = models.DateField()

class notification_table(models.Model):
    heading=models.CharField(max_length=100)
    description = models.CharField(max_length=100)
    date = models.DateField()


class camera_table(models.Model):
    cameranumber=models.BigIntegerField()
    latitude = models.CharField(max_length=100)
    logitude = models.CharField(max_length=100)

class cameranotification_table(models.Model):
    MISSINGCASEID = models.ForeignKey(missingcase_table, on_delete=models.CASCADE)
    image = models.FileField()
    date = models.DateField()
    time = models.DateTimeField()
    latitude = models.CharField(max_length=100)
    logitude = models.CharField(max_length=100)
    CAMERANUMBER = models.ForeignKey(camera_table, on_delete=models.CASCADE)

class chat_table(models.Model):
    date = models.DateField()
    FROMID=models.ForeignKey(login_table, on_delete=models.CASCADE,related_name='from_id')
    TOID=models.ForeignKey(login_table, on_delete=models.CASCADE,related_name='to_id')
    message=models.CharField(max_length=100)
    status=models.CharField(max_length=100)



