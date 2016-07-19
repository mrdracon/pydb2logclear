class pyDb2LogClear {
	# Get all data from Hiera
#	$all_data = hiera_hash('servers')
#	$node_data = $all_data[$hostname]

	$conf_file = hiera(pydb2_conf_file)   
	$crontab = hiera(crontab)

	# Make sure directory exists
	file { '/root/scripts':
		ensure	=> 'directory',
	}	
	
	# Script file
	file { 'trim_log.py':
		ensure	=> present,
		mode	=> 0755,
		source	=> 'puppet:///modules/pydb2logclear/trim_log.py',
		path	=> '/root/scripts/trim_log.py',
	}

	# Conf file. Different for each host.
	file { 'trim_log.conf':
		ensure	=> present,
		mode	=> 0644,
		path	=> '/root/scripts/trim_log.conf',
		source	=> "puppet:///modules/pydb2logclear/conf/$conf_file",
	}

	# Cron job as file in /etc/cron.d
	file { 'trim_log.cron':
		ensure	=> 'present',
		path	=> '/etc/cron.d/trimlog.cron',
		owner	=> 'root',
		group	=> 'root',
		mode	=> 0644,
		content	=> $crontab,
	}
}
