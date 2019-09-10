#!/bin/bash

echo 'start start start'

sudo su -
yum install python3 -y
dnf install python3-pip
export PATH=~/.local/bin:$PATH
source ~/.bash_profile
pip3 install awscli --upgrade --user

# INSTALL NGINX

yum update -y
yum install nginx -y
systemctl enable nginx
systemctl start nginx

# SWAP PAGES

cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.copy
yes | cp /usr/share/nginx/html/404.html /usr/share/nginx/html/index.html
systemctl restart nginx

# FAKING PROCESS RUN

count=1
while [$count -le 10]
do
	sleep 5
	echo 'loop loop loop'
	((count++))
done

# TRIGGER LIFE CYCLE HOOKS FOR PROCESS COMPLETE

INSTANCE_ID="`wget -q -O - http://instance-data/latest/meta-data/instance-id`" && \
aws autoscaling complete-lifecycle-action --lifecycle-action-result CONTINUE --instance-id $INSTANCE_ID --lifecycle-hook-name ASG-hook --auto-scaling-group-name EC2AutoScalingGroup --region ca-central-1 || \
aws autoscaling complete-lifecycle-action --lifecycle-action-result ABANDON --instance-id $INSTANCE_ID --lifecycle-hook-name ASG-hook --auto-scaling-group-name EC2AutoScalingGroup --region ca-central-1


echo 'done done done'



# USER DATA

# #!/bin/bash
# yum install wget -y
# wget https://digital-helloworld.s3.amazonaws.com/Nginx-PageNotFound.sh
# chmod +x Nginx-PageNotFound.sh
# ./Nginx-PageNotFound.sh

# BASE 64

# IyEvYmluL2Jhc2gKeXVtIGluc3RhbGwgd2dldCAteQp3Z2V0IGh0dHBzOi8vZGlnaXRhbC1oZWxsb3dvcmxkLnMzLmFtYXpvbmF3cy5jb20vTmdpbngtUGFnZU5vdEZvdW5kLnNoCmNobW9kICt4IE5naW54LVBhZ2VOb3RGb3VuZC5zaAouL05naW54LVBhZ2VOb3RGb3VuZC5zaAoKCgo=