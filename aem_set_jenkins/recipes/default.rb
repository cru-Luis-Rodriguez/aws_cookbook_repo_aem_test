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

node['aem']['jenkins']['jobs'].each do |job|
  aws_s3_file "/tmp/jobs_config/#{job}.xml" do
      bucket "cru-aem6"
      remote_path ("/installation_files/jenkins/jobs_config/#{job}.xml")
      aws_access_key_id aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key']
      mode "0644"
      not_if { ::File.exist?("/tmp/jobs_config/#{job}.xml") }
  end
end
#list of plugin to install
#use the plugin id -- not plugin name
jenkins_plugin 'disk-usage'
jenkins_plugin 'ant'
jenkins_plugin 'cas-plugin'
jenkins_plugin 'cas1'
jenkins_plugin 'credentials'
jenkins_plugin 'cvs'
jenkins_plugin 'external-monitor-job'
jenkins_plugin 'git-client'
jenkins_plugin 'git'
jenkins_plugin 'hipchat'
jenkins_plugin 'javadoc'
jenkins_plugin 'junit'
jenkins_plugin 'ldap'
jenkins_plugin 'mailer'
jenkins_plugin 'mapdb-api'
jenkins_plugin 'matrix-auth'
jenkins_plugin 'matrix-project'
jenkins_plugin 'maven-info'
jenkins_plugin 'maven-plugin'
jenkins_plugin 'metrics-diskusage'
jenkins_plugin 'metrics'
jenkins_plugin 'antisamy-markup-formatter'
jenkins_plugin 'pam-auth'
jenkins_plugin 'scm-api'
jenkins_plugin 'script-security'
jenkins_plugin 'slack'
jenkins_plugin 'ssh-credentials'
jenkins_plugin 'ssh-slaves'
jenkins_plugin 'subversion'
jenkins_plugin 'token-macro'
jenkins_plugin 'translation'
jenkins_plugin 'windows-slaves'

# Create a jenkins job (default action is `:create`)
jenkins_job 'cruorgaem6' do
  config "/tmp/jobs_config/cruorgaem6.xml"
end

jenkins_command 'safe-restart'
