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

directory "/opt/aem/aem_tmp_cache/" do
    owner "crx"
    group "crx"
    mode "755"
    action :create
end

directory "/opt/aem/upload" do
    owner "luisrodriguez"
    group "luisrodriguez"
    mode "755"
    action :create
end
