# Cookbook Name:: aem_disp_config
# Recipe:: default
#
# Copyright 2014, cru
#
# All rights reserved - Do Not Redistribute
#
#include_recipe 'apt'
#include_recipe 'apache2'

service 'apache2' do
    supports :status => true, :restart => true
    provider Chef::Provider::Service::Init
end

template "#{node['aem']['apache']['home']}/sites-available/cru.conf" do
    source 'cruorg.erb'
    owner "root"
    group "root"
    mode 0644
    variables(
              :host_name => node['hostname'],
              :host_ip => node['ipaddress'],
              :site => node['dispatcher']['site_name'],
              :site_alias1 => node['dispatcher']['alias1'],
              :site_alias2 => node['dispatcher']['alias2'],
	            :server_admin => node['dispatcher']['vhost_email'],
              :host_alias => "node['host_name'].cru.org"
              )

	only_if { File.exist?("#{node['aem']['apache']['home']}/sites-available") }
end

execute 'a2ensite' do
  command 'a2ensite cru.conf'
  action :run
  notifies :restart, "service[apache2]", :immediately
only_if { File.exist?("#{node['aem']['apache']['home']}/sites-available/cru.conf") }
end
