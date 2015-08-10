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

%w{ruby git gcc curl}.each do |pkg2|
 package "#{pkg2}" do
   action :upgrade
 end
end

gem_package 'sass' do
  action :install
  ignore_failure true
end

directory "/tmp/jobs_config" do
    owner "root"
    group "root"
    mode "0644"
    action :create
end

#list of plugin to install
#use the plugin id -- not plugin name
node['aem']['jenkins']['plugins'].each do |plugin|
  jenkins_plugin "#{plugin}" do
    action :install
  end
end

#copies the ssh key to the server from s3
node['aem']['jenkins']['ssh_key'].each do |key|
  aws_s3_file "/var/lib/jenkins/.ssh/#{key}" do
      bucket "cru-aem6"
      remote_path ("/installation_files/jenkins/ssh_key/#{key}")
      aws_access_key_id aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key']
      owner "jenkins"
      group "jenkins"
      mode "0600"
      not_if { ::File.exist?("/var/lib/jenkins/.ssh/#{key}") }
  end
end

#copies the jobs config.xml to the server from s3
node['aem']['jenkins']['jobs'].each do |job|
  aws_s3_file "/tmp/jobs_config/#{job}.xml" do
      bucket "cru-aem6"
      remote_path ("/installation_files/jenkins/jobs_config/#{job}.xml")
      aws_access_key_id aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key']
      mode "0600"
      not_if { ::File.exist?("/tmp/jobs_config/#{job}.xml") }
  end
  # Create a jenkins job (default action is `:create`)
  jenkins_job "#{job}" do
    config "/tmp/jobs_config/#{job}.xml"
  end
end

#copies the plugin configuration settings to the server from s3
node['aem']['jenkins']['plugin_conf'].each do |conf|
  aws_s3_file "/var/lib/jenkins/#{conf}.xml" do
      bucket "cru-aem6"
      remote_path ("/installation_files/jenkins/plugin_conf/#{conf}.xml")
      aws_access_key_id aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key']
      owner "jenkins"
      group "jenkins"
      mode "0644"
      not_if { ::File.exist?("/var/lib/jenkins/#{conf}.xml") }
  end
end
#copies the jenkins config to the server from s3
aws_s3_file "/var/lib/jenkins/config.xml" do
      bucket "cru-aem6"
      remote_path ("/installation_files/jenkins/config/config.xml")
      aws_access_key_id aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key']
      owner "jenkins"
      group "jenkins"
      mode "0600"
  end

jenkins_command 'safe-restart'
