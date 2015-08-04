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

aws = data_bag_item("aws", "main")

aws_s3_file "/tmp/job_config/cruorgaem6.xml" do
    bucket "cru-aem6"
    remote_path ("/installation_files/jenkins/job_config/cruorgaem6.xml")
    aws_access_key_id aws['aws_access_key_id']
    aws_secret_access_key aws['aws_secret_access_key']
    mode "0644"
    not_if { ::File.exist?("/tmp/job_config/cruorgaem6.xml") }
end


jenkins_plugin 'disk-usageplugin'
jenkins_plugin 'AntPlugin'
jenkins_plugin 'CASPlugin'
jenkins_plugin 'CASprotocolversion1plugin'
jenkins_plugin 'CredentialsPlugin'
jenkins_plugin 'CVSPlug-in'
jenkins_plugin 'ExternalMonitorJobTypePlugin'
jenkins_plugin 'GITclientplugin'
jenkins_plugin 'GITplugin'
jenkins_plugin 'HipChatPlugin'
jenkins_plugin 'JavadocPlugin'
jenkins_plugin 'JUnitPlugin'
jenkins_plugin 'LDAPPlugin'
jenkins_plugin 'MailerPlugin'
jenkins_plugin 'MapDBAPIPlugin'
jenkins_plugin 'MatrixAuthorizationStrategyPlugin'
jenkins_plugin 'MatrixProjectPlugin'
jenkins_plugin 'MavenInfoPlugin'
jenkins_plugin 'MavenIntegrationplugin'
jenkins_plugin 'MetricsDiskUsagePlugin'
jenkins_plugin 'MetricsPlugin'
jenkins_plugin 'OWASPMarkupFormatterPlugin'
jenkins_plugin 'PAMAuthenticationplugin'
jenkins_plugin 'SCMAPIPlugin'
jenkins_plugin 'ScriptSecurityPlugin'
jenkins_plugin 'SlackNotificationPlugin'
jenkins_plugin 'SSHCredentialsPlugin'
jenkins_plugin 'SSHSlavesplugin'
jenkins_plugin 'SubversionPlug-in'
jenkins_plugin 'TokenMacroPlugin'
jenkins_plugin 'TranslationAssistanceplugin'
jenkins_plugin 'WindowsSlavesPlugin'

# Create a jenkins job (default action is `:create`)
jenkins_job 'cruorgaem6' do
  config "/tmp/job_config/cruorgaem6.xml"
end

jenkins_command 'safe-restart'
