require 'spec_helper'

describe 'rvm' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(path: '/bin', gnupg_installed: false, root_home: '/root')
      end

      context 'default parameters', :compile do
        let(:facts) do
          os_facts.merge(rvm_version: '1.0.0', gnupg_installed: false, root_home: '/root')
        end

        it { is_expected.not_to contain_class('rvm::dependencies') }
        it { is_expected.to contain_class('rvm::system') }
      end

      context 'with install_rvm false', :compile do
        let(:params) do
          {
            install_rvm: false,
          }
        end

        it { is_expected.not_to contain_class('rvm::dependencies') }
        it { is_expected.not_to contain_class('rvm::system') }
      end

      context 'with system_rubies', :compile do
        let(:facts) do
          os_facts.merge(rvm_version: '1.0.0', gnupg_installed: false, root_home: '/root')
        end
        let(:params) do
          {
            system_rubies: {
              'ruby-1.9' => {
                'default_use' => true,
              },
              'ruby-2.0' => {},
            },
          }
        end

        it {
          is_expected.to contain_rvm_system_ruby('ruby-1.9').with(ensure: 'present',
                                                                  default_use: true)
        }
        it {
          is_expected.to contain_rvm_system_ruby('ruby-2.0').with(ensure: 'present',
                                                                  default_use: nil)
        }
      end

      context 'with system_users', :compile do
        let(:facts) do
          os_facts.merge(rvm_version: '1.0.0', gnupg_installed: false, root_home: '/root')
        end
        let(:params) { { system_users: ['john', 'doe'] } }

        it { is_expected.to contain_rvm__system_user('john') }
        it { is_expected.to contain_rvm__system_user('doe') }
      end
    end
  end
end
