# Cookbook Name:: aem_disp_config
# Recipe:: default
#
# Copyright 2014, cru
#
# All rights reserved - Do Not Redistribute

service 'httpd' do
    supports :status => true, :restart => true
    provider Chef::Provider::Service::Init
end

template "#{node['aem']['apache']['home']}/conf/httpd.conf" do
    source 'httpd_conf.erb'
    owner "root"
    group "root"
    mode 0644
    notifies :restart, "service[httpd]", :immediately
	only_if { File.exist?("#{node['aem']['apache']['home']}/conf") }
end
