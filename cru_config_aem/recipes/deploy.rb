chef_gem 'jenkins_api_client'

ruby_block 'deploy-from-jenkins' do
  require 'jenkins_api_client'

  @client = JenkinsApi::Client.new(:server_ip => node['aem']['continuous_integration']['hostname'],
                                   :username => node['aem']['continuous_integration']['username'],
                                   :password => node['aem']['continuous_integration']['password'])

  job_params = Hash.new()
  job_params['targetEnvironment'] = node['aem']['continuous_integration']['target_environment']
  job_params['targetServerIP'] = node['opsworks']['instance']['private_ip']
  job_params['databaseMigration'] = node['aem']['continuous_integration']['database_migration']
  job_params['deployerPassword'] = node['aem']['deploy_password']

  @client.job.build(node['aem']['continuous_integration']['job_name'], job_params, {})

  action :nothing
end
