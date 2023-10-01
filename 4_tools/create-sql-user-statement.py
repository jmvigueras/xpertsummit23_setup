####################################################################
# Script to generete sql statement with students data
#
# jvigueras@fortinet.com
####################################################################
import json
import ipaddress

# UPDATE variable
account_forticloud    = "1412xxx"
pass_forticloud       = "secret-pass"
users_forticloud_file = open('./users_forticloud.txt.example')
  
# Opening tfstate from deployments
# - Deploy terraform modules before execute this script
users_tfstate  = open('../1_student-accounts/terraform.tfstate')
cloud9_tfstate = open('../3_student-IDE-cloud9/terraform.tfstate')
hub_tfstate    = open('../2_student-hub-spoke-servers/terraform.tfstate')

# Opening users emails
# - Update with file name with student emails
users_email_file = open('./users_email.txt.example')

# returns JSON object as a dictionary
users  = json.load(users_tfstate)
cloud9 = json.load(cloud9_tfstate)
hub    = json.load(hub_tfstate)

# Variables 
externalid_token = users['outputs']['externalid_token']['value']
accountid_aws    = users['outputs']['iam-user_account_id']['value']
hub_fgt_pip      = hub['outputs']['hub']['value']['fgt-1_public']

i = 0
ii = 0
iii = 0
sql = "USE students;\n"

# Read users from files
users_email = users_email_file.readlines()
users_forticloud = users_forticloud_file.readlines()

# Generated INSERT sql statement per user in email list
while i < len(users['outputs']['iam-user_access-key']['value']):
        region_user_data = users['outputs']['iam-user_access-key']['value'][i]
        region_user_pass = users['outputs']['iam-user_console-password']['value'][i]
        ii=0
        while ii < len(region_user_data['access_key']):
                email =  users_email[iii].strip()
                user_forticloud = users_forticloud[iii].strip()
                access_key = region_user_data['access_key'][ii]
                secret_key = region_user_data['secret_key'][ii]
                user_id = region_user_data['user'][ii]
                user_id_split = user_id.split("-")
                user_sort = user_id_split[4]+"-"+user_id_split[5]
                region = user_id_split[1]+"-"+user_id_split[2]+"-"+user_id_split[3]
                region_az1 = user_id_split[1]+"-"+user_id_split[2]+"-"+user_id_split[3]+"a"
                vpc_cidr = "10."+user_id_split[3]+"."+user_id_split[5]+".0/24"
                server_ip = "10."+user_id_split[3]+"."+user_id_split[5]+".202"
                user_password = region_user_pass['password'][ii]
                sql += "INSERT INTO students (user_id, user_sort, server_ip, vpc_cidr, email, access_key, secret_key, user_password, externalid_token, server_test, server_check, region, region_az1, accountid, hub_fgt_pip, user_forticloud, pass_forticloud, account_forticloud) VALUES ("
                sql += "'"+user_id+"', "
                sql += "'"+user_sort+"', "
                sql += "'"+server_ip+"', "
                sql += "'"+vpc_cidr+"', "
                sql += "'"+email+"', "
                sql += "'"+access_key+"', "
                sql += "\""+secret_key+"\", "
                sql += "\""+user_password+"\", "
                sql += "'"+externalid_token+"', "
                sql += "'0', "
                sql += "'00:00:00 AM', "
                sql += "'"+region+"', "
                sql += "'"+region_az1+"', "
                sql += "'"+accountid_aws+"', "
                sql += "'"+hub_fgt_pip+"', "
                sql += "'"+user_forticloud+"', "
                sql += "'"+pass_forticloud+"', "
                sql += "'"+account_forticloud+"'"
                sql += ");\n"
                ii+=1
                iii+=1
        i+=1

# Generated UPDATES sql statement per user to populate Cloud9 URL
i = 0
while i < len(cloud9['outputs']['cloud9-user-env']['value']):
        cloud9_url = cloud9['outputs']['cloud9-user-env']['value'][i]['url']
        cloud9_user = cloud9['outputs']['cloud9-user-env']['value'][i]['user']
        sql += "UPDATE `students` SET `cloud9_url`='"+cloud9_url+"' WHERE `user_id` ='"+ cloud9_user+"';\n"
        i+=1

print("Done")

# Closing file
users_tfstate.close()
cloud9_tfstate.close()
users_email_file.close()

insert_sql = open('./sql_insert_users.sql','w')
insert_sql.writelines(sql)
insert_sql.close()