#
# Cookbook Name:: aem_set_server
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#add crx to sudoers file
currentUser = "crx"
execute "sudoers for #{currentUser}" do
  command "echo '#{currentUser} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
  not_if "grep -F '#{currentUser} ALL=(ALL) NOPASSWD:ALL' /etc/sudoers"
end
