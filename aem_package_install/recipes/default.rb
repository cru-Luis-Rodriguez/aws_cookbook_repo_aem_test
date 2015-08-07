#
# Cookbook Name:: aem_set_jenkins
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#The :create action requires a Jenkins job config.xml.
#This config file must exist on the target node and contain a valid Jenkins job configuration file.
#Because the Jenkins CLI actually reads and generates its own copy of this file,
#do NOT write this configuration inside of the Jenkins job. We recommend putting them in Chef's file cache path:
#
#need to come up with a way to copy multiple files from the path

include_recipe 'aws'
aws = data_bag_item("aws", "main")
type = node['aem']['role']

#create install directory
directory "/opt/aem/#{type}/crx-quickstart/install" do
    owner "crx"
    group "crx"
    mode "0755"
    action :create
end

#use whitelist array to upload package to install directory
node['aem']['package_list'].each do |package|
  aws_s3_file "/opt/aem/#{type}/crx-quickstart/install/#{package}.zip" do
        bucket "cru-aem6"
        remote_path ("/installation_files/package/#{package}.zip")
        aws_access_key_id aws['aws_access_key_id']
        aws_secret_access_key aws['aws_secret_access_key']
        owner "crx"
        group "crx"
        mode "0644"
        not_if { ::File.exist?("/opt/aem/#{type}/crx-quickstart/install/#{package}.zip") }
    end
end

#use whitelist array to upload hotfix to install directory
node['aem']['hotfix_list'].each do |hotfix|
  aws_s3_file "/opt/aem/#{type}/crx-quickstart/install/#{hotfix}.zip" do
        bucket "cru-aem6"
        remote_path ("/installation_files/hotfix/#{hotfix}.zip")
        aws_access_key_id aws['aws_access_key_id']
        aws_secret_access_key aws['aws_secret_access_key']
        owner "crx"
        group "crx"
        mode "0644"
        not_if { ::File.exist?("/opt/aem/#{type}/crx-quickstart/install/#{hotfix}.zip") }
    end
end

service "aem-#{type}" do
  action :restart
end
