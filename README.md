### DevOps_Proj

**DevOps project to automate the deployment process of Scalable and Secure web application into AWS**

*Approach 1 Tools

- HashiCorp TERRAFORM
- AWS Cloud*

*Approach 2 Tools

- AWS Cloud
- AWS Cloud Formation
- Puppet Open Source*

****************************************WARNING*****************************************************************

Both approaches creates AWS resources like (EC2,ASG,ELB,S3 Bucket) in AWS. You will be billed for the AWS resources accordingly.

****************************************************************************************************************

**_DevOps Project Scenario_**

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
#### Implementation

*Solution 1*

1. Download the appropriate [Terraform](https://www.terraform.io/downloads.html) package for your OS and Arch.
2. Unzip the [Terraform](https://www.terraform.io/intro/getting-started/install.html) Zip archive.
3. Add terraform installed directory to the [PATH] (https://www.terraform.io/intro/getting-started/install.html) environment variable.
4. Run `terraform --version` to check the successfull installation of Terraform.
5. Add the AWS IAM AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to the environment variable.
6. Download the GitHub Repository [DevOps_proj/webclusterha](https://github.com/munikumare/DevOps_Proj) to your server.
7. cd into the directory webclusterha and run the `terraform plan` and `terraform apply` command to launch the scalable and secure web cluster over AWS.
8. Login into the [AWS Console](https://aws.amazon.com/) and the copy the AWS ELB endpoint (DNS Name) and run in the browser to test the website or test it with DNS Route53 Record set name.
9. Clean up all the AWS resources once done with the lab by running the command `terraform destroy` and type `yes` at the prompt.
```
terraform destroy
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

_Files_

- Main.tf -> Actual code to launch the web cluster
- Variabes.tf -> File holds the variables to reference in the Main.tf
- Userdatascript -> File holds the user data script, that's been referenced in the Main.tf
- output.tf -> Prints the ELB DNS name and ELB Zone Id


**Solution 2*

1. Create an Instance on AWS (AMI-ami-6d1c2007).
2. Install open source Puppet Master.
3. Define a Apache module - [DevOps_Proj/apache] (https://github.com/munikumare/DevOps_Proj/tree/master/apache) folder contains the apache module scripts.
4. Create Autosign file with the node name of the instance, which automatically signs the nodes.
5. Declare Apache module at /etc/puppetlabs/code/environments/production/manifests/site.pp
```
node default {
  include apache
}
```
6. Create AWS Cloud Formation JSON template to launch an instance over AWS, bootstraped with CloudFormation helper scripts that needs to interprets the metadata - [DevOps_Proj/SSLFNL.json](https://github.com/munikumare/DevOps_Proj/blob/master/SSLFNL.json) file contains the script.
7. Modify the Puppet Node IP of the instance and Puppet Master Server IP accordingly at the config2 section of Metadata.
```
 "config2" : {
            "files" : {
              "/etc/hosts" : {
                     "content" : {"Fn::Join" : ["", [
                     "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4\n",
                     "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6\n",
                     "192.168.1.18 puppet\n",
                     "192.168.1.105 puppetnode2.training.com mysite.com www.mysite.com\n"

                     ]]}
                     }
            }
          },
```
8. Upload the AWS JSON template to S3 bucket and create the stack, that automatically launches an EC2 Instance.
9. EC2 Instance will be launced with puppet agent, that talks to Puppet Master to run the convergence, download the apache module.
10. Add mysite.com to your local dns, i.e. /etc/hosts file and test the site http://mysite.com


#### Author
**Munikumar** 
- [Twitter](https://twitter.com/kumarenters)
- Please share your suggestions and feedback @ *kumarenters@gmail.com*
- [GitHub URL](https://github.com/munikumare/)


