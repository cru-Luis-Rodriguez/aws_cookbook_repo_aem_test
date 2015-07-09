#
# Cookbook Name:: aem_set_server
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"

case node["platform"]
  when "ubuntu", "debian"
    execute 'apt-get-update' do
      command 'apt-get update'
      ignore_failure true
      not_if { ::File.exist?('/var/lib/apt/periodic/update-success-stamp') }
    end
  when "redhat", "centos"
      execute 'yum-update' do
        command 'yum update'
        ignore_failure true
    end



package "curl" do
  action :install
end

case node["platform"]
  when "redhat", "centos"
    package "libcurl-devel" do
      action :upgrade
    end
  when "ubuntu", "debian"
   %w{libcurl4-gnutls-dev libcurl4-openssl-dev}.each do |pkg1|
     package "#{pkg1}" do
       action :upgrade
      end
    end
end

%w{maven ruby git gcc}.each do |pkg2|
 package "#{pkg2}" do
   action :upgrade
 end
end

gem_package "bundler" do
  action :install
  ignore_failure true
end

case node["platform"]
  when "redhat", "centos"
    chef_gem "curb" do
      compile_time true if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
      action :nothing
    end.run_action(:install)
  when "ubuntu", "debian"
    chef_gem "curb" do
      compile_time true if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
      action :install
      ignore_failure true
    end

case node["platform"]
  when "ubuntu", "debian"
    directory "#{node[:apache][:dir]}/conf" do
      owner "root"
      group node[:apache][:root_group]
      mode "0775"
      action :create
      only_if { ::File.directory?('#{node[:apache][:dir]}') }
    end
  when "redhat", "centos"
        action :nothing
    end

end
