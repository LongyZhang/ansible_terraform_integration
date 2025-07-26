#!/bin/bash
echo "Running user data..." > /home/ec2-user/user_data.log
yum install -y vim ansible >> /home/ec2-user/user_data.log 2>&1
echo "Finished user data." >> /home/ec2-user/user_data.log