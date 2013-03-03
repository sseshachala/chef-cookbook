About The Rackspace Kitchen
========
Assembled by: Matt Surabian
Email: matt@mattsurabian.com

This is the repo that contains all the cookbooks and roles I use to configure my personal cloud servers on RackSpace.
Personally I use a separate web and data server setup, so I can scale either behind a load balancer if necessary.
I've added a LAMP server role for convenience to others that just want a quick way to leverage chef and create
a standard LAMP environment within the RackSpace OpenCloud.

Prerequisites
=============
 * Your workstation is setup with Chef http://docs.opscode.com/install_workstation.html
 * The RackSpace knife plugin `gem install knife-rackspace`
 * A hosted chef account at OpsCode
 * A .chef folder in this repo containing your knife.rb file, your validator.pem file and your personal.pem file all downloadable from OpsCode
 * Environment variables set for your RACKSPACE_USERNAME, and RACKSPACE_API_KEY.  I set them in my .bash_profile as follows

 ````
 export RACKSPACE_USERNAME=<RACKSPACE USERNAME>
 export RACKSPACE_API_KEY=<RACKSPACE API>
 ````

 * The following lines in your knife.rb file

````
knife[:rackspace_api_username] = "#{ENV['RACKSPACE_USERNAME']}"
knife[:rackspace_api_key] = "#{ENV['RACKSPACE_API_KEY']}"
knife[:rackspace_version] = 'v2'

````

Usage
=====
Edit the role files to include your RackSpace username and API key so the RackSpace backup client
can be installed successfully.  Ensure you have followed the prerequisite steps and can access your
OpsCode hosted chef server using knife.

If you've made modifications to the cookbooks update your metadata
````
knife cookbook metadata -a
````

Upload your cookbooks to your chef server
````
knife cookbook upload -a
````

Upload your roles to your chef server
````
knife role from file roles/data_server.json
knife role from file roles/web_server.json
knife role from file roles/lamp_server.json
````

Use the knife rackspace plugin to fire up a new server! (the image hash used corresponds to Ubuntu 12 LTS)
````
knife rackspace server create -r 'role[webserver]' --server-name WebServer --node-name WebServer --image 5cebb13a-f783-4f8c-8058-c4182c724ccd --flavor 2
````
or for a dataserver
````
knife rackspace server create -r 'role[dataserver]' --server-name DataServer --node-name DataServer --image 5cebb13a-f783-4f8c-8058-c4182c724ccd --flavor 2
````
or for a lamp
````
knife rackspace server create -r 'role[lampserver]' --server-name LampServer --node-name LampServer --image 5cebb13a-f783-4f8c-8058-c4182c724ccd --flavor 2
````
If something goes wrong and you want to remove the server you can do so through the GUI's in RackSpace
 AND OpsCode, you can also use knife
````
knife rackspace server list
knife rackspace server delete <ID OF THE SERVER TO DELETE FROM THE LIST>
knife client delete NODE-NAME (used in the server create method above)
knife node delete NODE-NAME (used in the server create method above)
````

Roles
=====
The roles included cover my basic server setup and are in no way exhaustive.  You should modify the roles to suit your needs.
All of the roles provided here configure the RackSpace backup client, you must set values for your RackSpace username and API Key
for the backup client to register itself properly.  Check the README inside the roles directory for more details on the provided roles.

Passwords and Access
====================
The knife rackspace command will output the node's root password when the server has been configured.
The mysql root password can be copied from the /etc/mysql/grants.sql file

Repository Directories
======================

This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* `certificates/` - SSL certificates generated by `rake ssl_cert` live here.
* `config/` - Contains the Rake configuration file, `rake.rb`.
* `cookbooks/` - Cookbooks you download or create.
* `data_bags/` - Store data bags and items in .json in the repository.
* `roles/` - Store roles in .rb or .json in the repository.

Rake Tasks
==========

The repository contains a `Rakefile` that includes tasks that are installed with the Chef libraries. To view the tasks available with in the repository with a brief description, run `rake -T`.

The default task (`default`) is run when executing `rake` with no arguments. It will call the task `test_cookbooks`.

The following tasks are not directly replaced by knife sub-commands.

* `bundle_cookbook[cookbook]` - Creates cookbook tarballs in the `pkgs/` dir.
* `install` - Calls `update`, `roles` and `upload_cookbooks` Rake tasks.
* `ssl_cert` - Create self-signed SSL certificates in `certificates/` dir.
* `update` - Update the repository from source control server, understands git and svn.

Configuration
=============

The repository uses two configuration files.

* config/rake.rb
* .chef/knife.rb

The first, `config/rake.rb` configures the Rakefile in two sections.

* Constants used in the `ssl_cert` task for creating the certificates.
* Constants that set the directory locations used in various tasks.

If you use the `ssl_cert` task, change the values in the `config/rake.rb` file appropriately. These values were also used in the `new_cookbook` task, but that task is replaced by the `knife cookbook create` command which can be configured below.

The second config file, `.chef/knife.rb` is a repository specific configuration file for knife. If you're using the Opscode Platform, you can download one for your organization from the management console. If you're using the Open Source Chef Server, you can generate a new one with `knife configure`. For more information about configuring Knife, see the Knife documentation.

http://help.opscode.com/faqs/chefbasics/knife

Next Steps
==========

Read the README file in each of the subdirectories for more information about what goes in those directories.
