#
# Cookbook Name:: aem_set_chef_env
# Recipe:: default
#
# Copyright 2015, cru
#
# All rights reserved - Do Not Redistribute
#
if node[:chef_environment] != nil
  node.chef_environment = node[:chef_environment]
end

directory "/opt/aem/tmp" do
    owner "root"
    group "opsworks"
    mode "1777"
    action :create
end

directory "/opt/aem/upload" do
    owner "root"
    group "opsworks"
    mode "755"
    action :create
end
