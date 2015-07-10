#
# Cookbook Name:: aem_set_server
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "maven"


%w{ruby git gcc}.each do |pkg2|
 package "#{pkg2}" do
   action :upgrade
   ignore_failure true
 end
end

gem_package "bundler" do
  action :install
  ignore_failure true
end
