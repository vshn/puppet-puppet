# This manifest installs the puppet client
#
# This manifest should NOT be called directly, use:
#
# include puppet
# 
# for default install.

class puppet::install(
	$pluginsync,
	$puppetlabs_repo,
	$web_ui
) {
	package{$puppet::params::puppet_package: ensure => installed}

	file{$puppet::params::conf_dir:
		ensure 		=> directory,
		owner			=> $puppet::params::user,
		group 		=> $web_ui ? {
			false		=> $puppet::params::group,
			default => $apache::params::group,
		}
	}

	if $puppetlabs_repo == true {
		require apt
		apt::source { "puppetlabs":
		  location          => "http://apt.puppetlabs.com/ubuntu",
		  release           => $lsbdistcodename,
		  repos             => "main",
		  key               => "4BD6EC30",
		  include_src       => true
		}
	}

	augeas{'puppet_main_config':
		context => $puppet::params::conf_path,
		changes	=> [
			"set main/pluginsync ${pluginsync}",
		],
	}
}