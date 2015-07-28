# Cookbook Name:: aem_disp_config
# Recipe:: default
#
# Copyright 2014, cru
#
# All rights reserved - Do Not Redistribute


#notes
#remember to replace instances of "cru.org" with variable #{node['aem']['dispatcher']['site_name']}

service 'httpd' do
    supports :status => true, :restart => true
    provider Chef::Provider::Service::Init
end

directory "/var/www/html/#{node['aem']['dispatcher']['site_name']}" do
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
  only_if { !File.exist?("/var/www/html/#{node['aem']['dispatcher']['site_name']}") }
end

template "#{node['aem']['apache']['home']}/sites-available/cru.conf" do
    source 'cruorg.erb'
    owner "root"
    group "root"
    mode 0644
    variables(
              :host_name => node['hostname'],
              :host_ip => node['ipaddress'],
              :site => "#{node['aem']['dispatcher']['site_name']}",
              :site_alias1 => node['aem']['dispatcher']['alias1'],
              :site_alias2 => node['aem']['dispatcher']['alias2'],
              :server_admin => "#{node['aem']['dispatcher']['vhost_email']}",
              :domain => "#{node['aem']['dispatcher']['domain']}"
              )

	only_if { File.exist?("#{node['aem']['apache']['home']}/sites-available") }
end

execute 'a2ensite' do
  command 'a2ensite cru.conf'
  action :run
  notifies :restart, "service[httpd]", :immediately
only_if { File.exist?("#{node['aem']['apache']['home']}/sites-available/cru.conf") }
end
