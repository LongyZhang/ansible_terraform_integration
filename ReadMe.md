# Terraform AWS EC2 Deployment - RHEL Nodes

This project uses Terraform to provision a network infrastructure and launch six Red Hat Enterprise Linux (RHEL) EC2 instances in AWS. It includes:

- One **manager** node
- One **test** node
- Two **web** nodes
- One **proxy** node
- One **database** node

All instances are deployed into a **public subnet** with **SSH (port 22)** access from your current IP.

---

## 📁 Project Structure

terraform-ec2-redhat/
├── main.tf # Main Terraform configuration
├── outputs.tf # Outputs like instance IPs
├── variables.tf # (Optional) variables file
├── README.md # This file


## My plan: 

1: Using terraform to provisiion the ec2 and vpc, All instances are deployed into a **public subnet** with **SSH (port 22)** access from my current IP.

2:Use the manager node to control other node by using ansible, it is gonna be ansible learning and practice