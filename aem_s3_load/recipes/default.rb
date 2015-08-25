#
# Cookbook Name:: s3bucket_ops
# Recipe:: default
#
# Copyright 2015, Cru
#
# All rights reserved - Do Not Redistribute

include_recipe 'aws'
aws = data_bag_item("aws", "main")

#Get AEM from source
aws_s3_file "/tmp/#{node['aem']['jar_source']}.jar" do
    bucket "cru-aem6"
    remote_path ("/installation_files/#{node[:aem][:jar_source]}.jar")
    aws_access_key_id aws['aws_access_key_id']
    aws_secret_access_key aws['aws_secret_access_key']
    mode "0644"
    not_if { ::File.exist?("/tmp/#{node[:aem][:jar_source]}.jar") }
end

#Get license file form source
aws_s3_file "/tmp/license.properties" do
    bucket "cru-aem6"
    remote_path "/installation_files/license.properties"
    aws_access_key_id aws['aws_access_key_id']
    aws_secret_access_key aws['aws_secret_access_key']
    mode "0644"
    not_if { ::File.exist?("/tmp/license.properties") }
end

#Get dispatcher module
aws_s3_file "/tmp/#{node[:aem][:disp_mod_source]}.so" do
      bucket "cru-aem6"
      remote_path "/installation_files/#{node[:aem][:disp_mod_source]}.so"
      aws_access_key_id aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key']
      mode "0644"
      not_if { ::File.exist?("/tmp/#{node[:aem][:disp_mod_source]}.so") }
end
