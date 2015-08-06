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

directory "/tmp/jobs_config" do
    owner "root"
    group "root"
    mode "0755"
    action :create
end

#list of plugin to install
#use the plugin id -- not plugin name
node['aem']['jenkins']['plugins'].each do |plugin|
  jenkins_plugin "#{plugin}" do
    action :install
  end
end


#copies the jobs config.xml to the server from s3
%w{cruorgaem6 Backup_AEM_Production_Author_Repo CruOrgaem6_Auto_Production_DailyContentFlush CruOrgaem6_Manual_Prod_Pub_Designs_DispatcherClear Relay_Authentication_Handler aem6.1-communities cruorgaem6DispatcherClear cruorgaem6_PROD cruorgaem6_PRODDispatcherClear cruorgaem6_PRODPublish cruorgaem6_UAT cruorgaem6_UATDispatcherClear'}.each do |job|
  aws_s3_file "/tmp/jobs_config/#{job}.xml" do
      bucket "cru-aem6"
      remote_path ("/installation_files/jenkins/jobs_config/#{job}.xml")
      aws_access_key_id aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key']
      mode "0644"
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
      mode "0755"
      not_if { ::File.exist?("/var/lib/jenkins/#{conf}.xml") }
  end
end

jenkins_command 'safe-restart'
