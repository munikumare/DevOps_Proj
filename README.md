# DevOps_Proj
DevOps project to automate the deployment process of  static web application in AWS with AWS Cloud Formation JSON template and Puppet

----------------------- DevOps Project Scenario-----------------------------------
For this project, please think about how you would architect a scalable and

secure static web application in AWS or another IaaS provider.

• Create and deploy a running instance of a web server using a

configuration management tool of your choice. The web server should

serve one page with the following content.

<html>

<head>

<title>Hello World</title>

</head>

<body>

<h1>Hello World!</h1>

</body>

</html>

• Secure this application and host such that only appropriate ports are

publicly exposed and any http requests are redirected to https. This

should be automated using a configuration management tool of your

choice and you should feel free to use a self-signed certificate for the

web server.

• Develop and apply automated tests to validate the correctness of the

server configuration.
---------------------------------------------------------------------------------------------------------------
Implementation:
1. Create an Instance on AWS (AMI-ami-6d1c2007).
2. Install open source Puppet Master.
3. Create a Apache module - Puppet_apache_module file contains the apache module script.
4. Create Autosign file, that automatically signs the nodes.
5. Create AWS Cloud Formation JSON template to launch an instance over AWS, bootstraped with CloudFormation helper scripts that needs to interprets the metadata - AWS_CF_JSON file contains the script.
6. Upload the AWS JSON template to S3 bucket and create the stack, that automatically launches an EC2 Instance.
7. EC2 Instance will be launced with puppet agent, that talks to Puppet Master to run the convergence, download the apache module.
8. Add mysite.com to your local dns, i.e. /etc/hosts file and test the site http://mysite.com
---------------------------------------------------------------------------------------------------------------
