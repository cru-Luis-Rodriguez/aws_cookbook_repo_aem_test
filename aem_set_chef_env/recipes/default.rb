#
# Cookbook Name:: aem_set_server
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
if node[:chef_environment] != nil
  node.chef_environment = node[:chef_environment]
end
