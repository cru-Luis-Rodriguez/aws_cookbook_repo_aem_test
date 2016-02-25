user 'nexus user' do
  username node['nexus']['user']
  comment 'Nexus User'
  home "#{node['nexus']['dir']}/nexus"
  shell '/bin/bash'
  supports manage_home: false
  action :create
  system true
end

group 'nexus group' do
  group_name node['nexus']['group']
  action :create
  system true
end

nexus = ark 'nexus' do
  url node['nexus']['download_url']
  owner node['nexus']['user']
  group node['nexus']['group']
  version node['nexus']['version']
  checksum node['nexus']['checksum']

  prefix_root node['nexus']['dir']
  prefix_home node['nexus']['dir']
end

link '/etc/init.d/nexus' do
  to ::File.join(nexus.prefix_home, nexus.name, 'bin', 'nexus')
end

ruby_block 'Configure-Nexus-Init-File' do
  block do
    file = Chef::Util::FileEdit.new('/etc/init.d/nexus')
    file.insert_line_after_match('#RUN_AS_USER=', "RUN_AS_USER=#{node['nexus']['user']}")
    file.write_file
    File.delete('/etc/init.d/nexus.old') if File.exist?('/etc/init.d/nexus.old')
  end

  not_if { ::File.read('/etc/init.d/nexus') =~ /RUN_AS_USER=#{node['nexus']['user']}/ }
  notifies :restart, 'service[nexus]', :delayed
end

directory node['nexus']['conf']['nexus-work'] do
  owner node['nexus']['user']
  group node['nexus']['group']
  mode '0755'

  recursive true

  notifies :restart, 'service[nexus]', :delayed
end

template ::File.join(nexus.prefix_home, nexus.name, 'conf', 'nexus.properties') do
  source 'nexus.properties.erb'

  owner node['nexus']['user']
  group node['nexus']['group']
  mode '0644'

  variables :conf => node['nexus']['conf']
  notifies :restart, 'service[nexus]', :delayed
end

wrapper = ::File.join(nexus.prefix_home, nexus.name, 'bin', 'jsw', 'conf', 'wrapper.conf')

ruby_block 'Configure-Wrapper-Memory' do
  block do
    file = Chef::Util::FileEdit.new(wrapper)
    file.search_file_replace_line(/wrapper.java.initmemory=.*/, "wrapper.java.initmemory=#{node['nexus']['wrapper']['init_mem']}")
    file.search_file_replace_line(/wrapper.java.maxmemory=.*/, "wrapper.java.maxmemory=#{node['nexus']['wrapper']['max_mem']}")
    file.write_file
    File.delete("#{wrapper}.old") if File.exist?("#{wrapper}.old")
  end

  not_if do
    content = ::File.read(wrapper)
    content =~ /wrapper.java.initmemory=#{node['nexus']['wrapper']['init_mem']}/ &&
      content =~ /wrapper.java.maxmemory=#{node['nexus']['wrapper']['max_mem']}/
  end

  notifies :restart, 'service[nexus]', :delayed
end

# Start service
service 'nexus' do
  action [:enable, :start]
end
