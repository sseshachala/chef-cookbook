#
# Cookbook Name:: rackspace_cloud_backup
# Recipe:: default
#
# Copyright 2012, Binary Marbles Trond Arve Nordheim
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

execute "apt-get update" do
  action :nothing
end

execute "install drivesrv apt key" do
  command "wget -q \"http://agentrepo.drivesrvr.com/debian/agentrepo.key\" -O- | apt-key add -"
  not_if "apt-key list | grep F6A5034C"
end

template "/etc/apt/sources.list.d/driveclient.list" do
  source "sources.list.erb"
  mode 0644
  notifies :run, "execute[apt-get update]", :immediately
end

package "driveclient" do
  action :install
end

service "driveclient" do
  action :enable
end

execute "configure driveclient" do
  command "driveclient -c -u #{node[:rackspace_cloud_backup][:username]} -k #{node[:rackspace_cloud_backup][:api_key]}"
end
 
service "driveclient" do
  action :start
end
