require 'spec_helper'

describe 'simple-nexus::default' do
  before do
    allow(::File).to receive(:read).and_call_original
    allow(::File).to receive(:read).with('/etc/init.d/nexus').and_return('empty nexus file')
    allow(::File).to receive(:read).with('/opt/nexus/bin/jsw/conf/wrapper.conf').and_return('empty wrapper file')
  end

  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      node.override['nexus']['user'] = 'nxu'
      node.override['nexus']['group'] = 'nxg'
    end.converge(described_recipe)
  end

  it 'creates user for nexus' do
    expect(chef_run).to create_user('nxu')
  end

  it 'creates group for nexus' do
    expect(chef_run).to create_group('nxg')
  end

  it 'configures nexus init script' do
    expect(chef_run).to run_ruby_block('Configure-Nexus-Init-File')
  end

  it 'configures wrapper for nexus' do
    expect(chef_run).to run_ruby_block('Configure-Wrapper-Memory')
  end

  # No matchers in 0.9.0 ark. Wait for new version
  #  it 'arks nexus archive' do
  #    expect(chef_run).to install_ark('nexus')
  #  end
end
