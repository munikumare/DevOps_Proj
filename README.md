# DevOps_Proj
DevOps project to automate the deployment process of Scalable and secure web application into AWS.

Approach 1 Tools: Using HashiCorp TERRAFORM; AWS Cloud

Approach 2 Tools : AWS IAS; AWS Cloud Formation; Puppet Open Source

----------------------- DevOps Project Scenario-----------------------------------

For this project, please think about how you would architect a scalable and secure static web application in AWS or another IaaS provider.

Create and deploy a running instance of a web server using a configuration management tool of your choice. The web server should serve one page with the following content.

<html>

<head>

<title>Hello World</title>

</head>

<body>

<h1>Hello World!</h1>

</body>

</html>

Secure this application and host such that only appropriate ports are publicly exposed and any http requests are redirected to https. This should be automated using a configuration management tool of your choice and you should feel free to use a self-signed certificate for the web server.

Develop and apply automated tests to validate the correctness of theserver configuration.

Express everything in code and provide your code via a Git repository in GitHub.


---------------------------------------------------------------------------------------------------------------
Implementation:

Solution 1 :

1. Download the appropriate package for your OS and Arch.
2. Unzip the Terraform Zip archive
3. Add terraform installed directory to the PATH environment variable.
4. Run terraform --version to check the successfull installation of Terraform.
5. Add the AWS IAM AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to the environment variable.
6. Download the GitHub Repository webclusterha to your server.
7. cd into the directory webclusterha and run the terraform plan and terraform apply command to launch the scalable and secure web cluster over AWS.
8. Login into the AWS Console and the copy the AWS ELB endpoint and run in the browser to test the website.

Files

Main.tf -> Actual code to launch the web cluster
Variabes.tf -> File holds the variables to reference in the Main.tf
Userdatascript -> File holds the user data script, that's been referenced in the Main.tf


Solution 2:

1. Create an Instance on AWS (AMI-ami-6d1c2007).
2. Install open source Puppet Master.
3. Define a Apache module - Puppet_apache_module file contains the apache module script.
4. Create Autosign file with the node name of the instance, which automatically signs the nodes.
5. Declare Apache module at /etc/puppetlabs/code/environments/production/manifests/site.pp
node default {
	include apache
}
6. Create AWS Cloud Formation JSON template to launch an instance over AWS, bootstraped with CloudFormation helper scripts that needs to interprets the metadata - AWS_CF_JSON file contains the script.
7. Modify the private ip of the instance accordingly at the config2 section of Metadata.
7. Upload the AWS JSON template to S3 bucket and create the stack, that automatically launches an EC2 Instance.
8. EC2 Instance will be launced with puppet agent, that talks to Puppet Master to run the convergence, download the apache module.
9. Add mysite.com to your local dns, i.e. /etc/hosts file and test the site http://mysite.com

~~~~~~~~~~~~~~END~~~~~~~~~~~~~~~~~~~~~~
---------------------------------------------------------------------------------------------------------------

