# # USAGE
# # python recognize_faces_image.py --encodings encodings.pickle --image examples/example_01.png
#
# # import the necessary packages
# import datetime
# from email.mime.multipart import MIMEMultipart
# from email.mime.text import MIMEText
#
# import face_recognition
# import argparse
# import pickle
# import cv2
# import pymysql
#
#
#
# def iud(qry,val):
#     con=pymysql.connect(host='localhost',port=3306,user='root',password='pasc',db='missing_child')
#     cmd=con.cursor()
#     cmd.execute(qry,val)
#     id=cmd.lastrowid
#     con.commit()
#     con.close()
#
#     return id
#
# def selectone(qry,val):
#     con=pymysql.connect(host='localhost',port=3306,user='root',password='pasc',db='missing_child',cursorclass=pymysql.cursors.DictCursor)
#     cmd=con.cursor()
#     cmd.execute(qry,val)
#     res=cmd.fetchone()
#
#     return res
#
# def selectall(qry):
#     con=pymysql.connect(host='localhost',port=3306,user='root',password='pasc',db='missing_child',cursorclass=pymysql.cursors.DictCursor)
#     cmd=con.cursor()
#     cmd.execute(qry)
#     res=cmd.fetchall()
#     return res
# def selectall2(qry,val):
#     con=pymysql.connect(host='localhost',port=3306,user='root',password='pasc',db='missing_child',cursorclass=pymysql.cursors.DictCursor)
#     cmd=con.cursor()
#     cmd.execute(qry,val)
#     res=cmd.fetchall()
#     return res
#
#
# cc=selectone("select * from myapp_camera_table where id=%s", ("12"))
# cam_lati=cc['latitude']
# cam_logi=cc['logitude']
#
#
# def rec_face_image(imagepath):
# 	print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk")
#
#
# 	detected_name=[]
# 	idddss=imagepath.split('/')
#
#
# 	ap = argparse.ArgumentParser()
#
# 	data = pickle.loads(open(r'C:\Users\HP\PycharmProjects\missing_child\myapp\faces.pickles', "rb").read())
#
# 	# load the input image and convert it from BGR to RGB
# 	image = cv2.imread(imagepath)
#
# 	#print(image)
# 	h,w,ch=image.shape
#
# 	rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
#
# 	# detect the (x, y)-coordinates of the bounding boxes corresponding
# 	# to each face in the input image, then compute the facial embeddings
# 	# for each face
#
# 	boxes = face_recognition.face_locations(rgb,
# 		model='hog',)
# 	encodings = face_recognition.face_encodings(rgb, boxes)
#
# 	# initialize the list of names for each face detected
# 	names = []
#
# 	# loop over the facial embeddings
# 	for encoding in encodings:
# 		# attempt to match each face in the input image to our known
# 		# encodings
# 		matches = face_recognition.compare_faces(data["encodings"],
# 			encoding,tolerance=0.45)
# 		name = "Unknown"
# 		print (matches)
#
# 		# check to see if we have found a match
# 		if True in matches:
# 			# find the indexes of all matched faces then initialize a
# 			# dictionary to count the total number of times each face
# 			# was matched
# 			matchedIdxs = [i for (i, b) in enumerate(matches) if b]
# 			counts = {}
#
# 			# loop over the matched indexes and maintain a count for
# 			# each recognized face face
# 			for i in matchedIdxs:
#
# 				name = data["names"][i]
# 				counts[name] = counts.get(name, 0) + 1
# 				print(name,"================")
# 				if name not in detected_name:
# 					detected_name.append(name)
# 			print(counts, " rount ")
# 			# determine the recognized face with the largest number of
# 			# votes (note: in the event of an unlikely tie Python will
# 			# select first entry in the dictionary)
#
# 			name = max(counts, key=counts.get)
# 			print("result1111111", name)
# 	return detected_name,""
#
# media_path=r"C:\Users\HP\PycharmProjects\missing_child\media\\"
# def camera():
#
# 	# import the opencv library
# 	import cv2
#
# 	# define a video capture object
# 	vid = cv2.VideoCapture(0)
#
# 	while (True):
#
# 		# Capture the video frame
# 		# by frame
# 		ret, frame = vid.read()
# 		cv2.imwrite("sample.png",frame)
#
# 		res,emo=rec_face_image("sample.png")
# 		print("emo",res)
# 		for i in res:
# 			res = selectone(
# 				"SELECT TIMEDIFF(CURTIME(), TIME) as tm FROM `myapp_cameranotification_table` WHERE DATE=CURDATE() AND latitude=%s AND logitude=%s AND MISSINGCASEID_id=%s order by id desc", (cam_lati, cam_logi,i))
# 			if res is None:
# 				t = datetime.datetime.now().strftime("%H:%M")
# 				id = iud("INSERT INTO `myapp_cameranotification_table` VALUES(NULL,CURDATE(),%s,%s,%s, curtime())", (cam_lati, cam_logi,i))
# 				cv2.imwrite(r"C:\Users\HP\PycharmProjects\missing_child\media/" + str(id) + ".png", frame)
# 			else:
# 				tm_diff = res['tm']
# 				diff_mins = str(tm_diff).split(":")[1]
# 				print("Mins : ", diff_mins)
# 				if int(diff_mins) >= 1:  # save data only after 5 mins if data already exists
# 					t = datetime.datetime.now().strftime("%H:%M")
# 					id = iud("INSERT INTO `myapp_cameranotification_table` VALUES(NULL,CURDATE(),%s,%s,%s, curtime())", (cam_lati, cam_logi,i))
# 					cv2.imwrite(r"C:\Users\HP\PycharmProjects\missing_child\media/" + str(id) + ".png", frame)
#
# 			# id=iud("INSERT INTO `myapp_cameranotification_table` VALUES(NULL,CURDATE(),%s,%s,%s)",(,i))
# 			# cv2.imwrite(r"C:\Users\HP\PycharmProjects\missing_child\media/"+str(id)+".png",frame)
# 		# for i in res:
# 		# 	q="SELECT * FROM `smart_att_attendance_table` WHERE `date`=CURDATE() AND `hour`=%s  AND`student_id`=%s AND `subject_id`=%s"
#         #
# 		# 	res=selectall2(q,(hr,i,sid))
# 		# 	if len(res)>0:
# 		# 		pass
# 		# 	else:
# 		# 		iud("INSERT INTO `smart_att_attendance_table` VALUES(NULL,CURDATE(),%s,1,%s,%s)",(hr,i,sid))
# 		# 		# iud("INSERT INTO `smart_att_depression` VALUES(NULL,CURDATE(),%s,%s,%s)", (hr, emo, sid))
# 		# 	print(i,"=====================2")
# 		# 	if emo!="neutral":
# 		# 		print(emo)
# 		# 		try:
# 		# 			# q="SELECT *  FROM `smart_att_depression` WHERE `hour`=%s AND `date`=CURDATE() AND STUDENT_id=%s"
#          #            #
# 		# 			# rs=selectall2(q,(hr,sid))
# 		# 			# print(rs, "hhhhhhhhhhhhh")
# 		# 			# if rs is None:
# 		# 			#   print("ggggggggggggg")
# 		# 			  iud("INSERT INTO `smart_att_depression` VALUES(NULL,CURDATE(),%s,%s,%s)",(hr,emo,i))
# 		# 			# else:
# 		# 			# 	iud("UPDATE `smart_att_depression` SET `overallscore`=%s WHERE `STUDENT_id`=%s)", (emo, sid))
#         #
# 		# 		except:
# 		# 			pass
# 		# Display the resulting frame
#
#
# 		import smtplib
# 		s = smtplib.SMTP(host='smtp.gmail.com', port=587)
# 		s.starttls()
# 		s.login("childmissing01@gmail.com", "jwyo jdvt tiws zvky")
# 		msg = MIMEMultipart()  # create a message.........."
# 		msg['From'] = "childmissing01@gmail.com"
# 		msg['To'] = id
# 		msg['Subject'] = "new detection"
# 		body = "Your Password is:- - " + str(pwd)
# 		msg.attach(MIMEText(body, 'plain'))
# 		s.send_message(msg)
# 		cv2.imshow('frame', frame)
#
# 		# the 'q' button is set as the
# 		# quitting button you may use any
# 		# desired button of your choice
# 		if cv2.waitKey(1) & 0xFF == ord('q'):
# 			break
#
# 	# After the loop release the cap object
# 	vid.release()
# 	# Destroy all the windows
# 	cv2.destroyAllWindows()
# camera()

#
#
import datetime
import math
import smtplib
import cv2
import face_recognition
import pymysql
import pickle
import os
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Database connection
from django.core.files.storage import FileSystemStorage


def db_connect():
    return pymysql.connect(host='localhost', port=3306, user='root', password='pasc', db='missing_child',
                           cursorclass=pymysql.cursors.DictCursor)

# Insert, update, delete queries
def iud(qry, val):
    con = db_connect()
    cmd = con.cursor()
    cmd.execute(qry, val)
    id = cmd.lastrowid
    con.commit()
    con.close()
    return id


def selectone(qry, val):
    con = db_connect()
    cmd = con.cursor()
    cmd.execute(qry, val)
    res = cmd.fetchone()
    con.close()
    return res

def selectall(qry):
    con = db_connect()
    cmd = con.cursor()
    cmd.execute(qry)
    res = cmd.fetchall()
    con.close()
    return res

def check_table_exists(table_name):
    con = db_connect()
    cmd = con.cursor()
    cmd.execute(f"SHOW TABLES LIKE '{table_name}'")
    result = cmd.fetchone()
    con.close()
    return result is not None

# Ensure `myapp_camera_table` exists
if not check_table_exists("myapp_camera_table"):
    print("Error: 'myapp_camera_table' does not exist. Please create it in the database.")
    exit()

# Fetch camera location
camera_id = 1
cc = selectone("SELECT * FROM `myapp_camera_table` WHERE id=%s", (camera_id,))

if cc is None:
    print(f"Error: No camera found with ID {camera_id}.")
    exit()

cam_lati = float(cc['latitude'])
cam_logi = float(cc['logitude'])

# Haversine formula to calculate distance
def haversine_distance(lat1, lon1, lat2, lon2):
    lat1, lon1, lat2, lon2 = map(math.radians, [lat1, lon1, lat2, lon2])
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = math.sin(dlat / 2) ** 2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2) ** 2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    r = 6371  # Radius of Earth in KM
    return r * c

# Get nearest helpline
def get_nearest_helpline(cam_lat, cam_lon):
    helplines = selectall("SELECT * FROM myapp_childhelpline_table")
    min_distance = float('inf')
    nearest_helpline = None
    for helpline in helplines:
        help_lat = float(helpline['latitude'])
        help_lon = float(helpline['logitude'])
        distance = haversine_distance(cam_lat, cam_lon, help_lat, help_lon)
        if distance < min_distance:
            min_distance = distance
            nearest_helpline = helpline
    return nearest_helpline

# Recognize faces
def rec_face_image(imagepath):
    detected_names = []
    if not os.path.exists(imagepath):
        print(f"Error: Image file not found at {imagepath}")
        return detected_names
    try:
        with open(r'C:\Users\HP\PycharmProjects\missing_child\myapp\faces.pickles', "rb") as f:
            data = pickle.load(f)
    except Exception as e:
        print(f"Error loading face data: {e}")
        return detected_names
    image = cv2.imread(imagepath)
    if image is None:
        print(f"Error: Failed to read image {imagepath}")
        return detected_names
    rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    boxes = face_recognition.face_locations(rgb, model='hog')
    encodings = face_recognition.face_encodings(rgb, boxes)
    for encoding in encodings:
        matches = face_recognition.compare_faces(data["encodings"], encoding, tolerance=0.45)
        name = "Unknown"
        if True in matches:
            matchedIdxs = [i for (i, b) in enumerate(matches) if b]
            counts = {}
            for i in matchedIdxs:
                name = data["names"][i]
                counts[name] = counts.get(name, 0) + 1
            name = max(counts, key=counts.get)
            if name not in detected_names:
                detected_names.append(name)
    return detected_names


# Send email alert (without image attachment)
def send_email(to_email, child_name, cam_lat, cam_lon):
    sender_email = "childmissing01@gmail.com"
    sender_password = "jwyo jdvt tiws zvky"
    subject = "Missing Child Alert"
    body = f"A missing child ({child_name}) has been detected at coordinates ({cam_lat}, {cam_lon}). Please take immediate action."
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = to_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))
    try:
        server = smtplib.SMTP(host="smtp.gmail.com", port=587)
        server.starttls()
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, to_email, msg.as_string())
        server.quit()
        print(f"Email sent successfully to {to_email}")


    except Exception as e:
        print(f"Error sending email: {e}")

# Camera function to detect and send alerts
def camera():
    vid = cv2.VideoCapture(0)
    if not vid.isOpened():
        print("Error: Camera not detected.")
        return
    while True:
        ret, frame = vid.read()


        if not ret:
            print("Error: Failed to capture frame from camera.")
            continue
        image_path = "sample.png"
        cv2.imwrite(image_path, frame)
        detected_names = rec_face_image(image_path)
        for child_name in detected_names:
            nearest_helpline = get_nearest_helpline(cam_lati, cam_logi)
            if nearest_helpline:
                send_email(nearest_helpline['email'], child_name, cam_lati, cam_logi)
                static_path = r"C:\Users\HP\PycharmProjects\missing_child\media/"
                dt = datetime.datetime.now().strftime("%y%m%d_%H%M%S")
                save_path = static_path + dt + ".jpg"
                cv2.imwrite(save_path, frame)
                path = dt + '.jpg'
                print(child_name,"ooooooooo")
                import time

                con = db_connect()
                cmd = con.cursor()

                # Check if a record exists for the same date, latitude, longitude, and MISSINGCASEID_id
                cmd.execute(
                    "SELECT id FROM `missing_child`.`myapp_cameranotification_table` WHERE `date` = CURDATE() AND `latitude` = %s AND `logitude` = %s AND `MISSINGCASEID_id` = %s",
                    (cam_lati, cam_logi, child_name))

                existing_record = cmd.fetchone()
                print(existing_record,"hjhjhj  ")

                if existing_record:
                    record_id = existing_record
                    print(f"Record found. Will update after 5 seconds. ID: {record_id}")

                    # Wait for 5 seconds before updating
                    time.sleep(5)

                    # Update the existing record
                    # cmd.execute(
                    #     "UPDATE `missing_child`.`myapp_cameranotification_table` SET `time` = CURTIME(), `image` = %s WHERE `id` = %s",
                    #     (path, record_id))
                    cmd.execute(
                        "INSERT INTO `missing_child`.`myapp_cameranotification_table` (`date`, `time`, `latitude`, `logitude`, `CAMERANUMBER_id`, `MISSINGCASEID_id`, `image`) VALUES (CURDATE(), CURTIME(), %s, %s, 1, %s, %s)",
                        (cam_lati, cam_logi, child_name, path))
                else:
                    print("No existing record found. Inserting a new one.")

                    # Insert a new record
                    cmd.execute(
                        "INSERT INTO `missing_child`.`myapp_cameranotification_table` (`date`, `time`, `latitude`, `logitude`, `CAMERANUMBER_id`, `MISSINGCASEID_id`, `image`) VALUES (CURDATE(), CURTIME(), %s, %s, 1, %s, %s)",
                        (cam_lati, cam_logi, child_name, path))
                    record_id = cmd.lastrowid

                con.commit()
                con.close()


                # iud(("INSERT INTO `myapp_cameranotification_table` VALUES(NULL,CURDATE(),CURTIME(),%s,%s,%s,%s,%s)"),(cam_lati,cam_logi,child_name,'1',dt + ".jpg",))

        cv2.imshow('frame', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    vid.release()
    cv2.destroyAllWindows()

# Run camera detection
camera()
import datetime
