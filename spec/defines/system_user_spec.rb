require 'spec_helper'

describe 'rvm::system_user' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(gnupg_installed: false) }
      let(:username) { 'johndoe' }
      let(:group) { 'rvm' }
      let(:title) { username }

      context 'when using default parameters', :compile do
        it { is_expected.to contain_user(username) }
        it { is_expected.to contain_group(group) }
        it { is_expected.to contain_exec("rvm-system-user-#{username}").with_command("/usr/sbin/usermod -a -G #{group} #{username}") }
      end
    end
  end
end
