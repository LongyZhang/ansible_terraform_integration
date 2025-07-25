'''
ansible all -m command -a "sudo yum update -y"
'''

ansible-doc -l |grep aws

ansible node1 -m command can not use pipe and & 


script module, you can use it to run the bash script, ansible test -m script -a "./pack.sh"

copy module:

ansible test -m copy -a "src=~/a3.txt dest=/root"

## create ALL LONGY USER

ansible all -m user -a "name=longy" --become

## create hash512 password for the longy user, it must be hashed, otherwise you can not ssh 
ansible all -m user -a "name=longy password={{'abc'|password_hash('sha512')}}" --become