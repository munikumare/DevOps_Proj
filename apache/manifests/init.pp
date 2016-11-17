class apache {
	package { 'centos-apache' :
		name	=> httpd,
		ensure	=> present,
		before	=> File['httpconf'],
	}
	package { ['mod_ssl', 'openssl', 'vim']:
		ensure	=> present,
		before	=> File['cpsskey', 'cpkey', 'cpcert'],
		#alias	=> 'ssl-packages',
	}
	file { 'cpsskey' :
                ensure  => 'file',
                path    => '/etc/pki/tls/certs/ca.crt',
                source  => 'puppet:///modules/apache/ca.crt',
                owner   => 'root',
                group   => 'root',
                mode    => '644',
        } 
	file { 'cpkey' :
                ensure  => 'file',
                path    => '/etc/pki/tls/private/ca.key',
                source  => 'puppet:///modules/apache/ca.key',
                owner   => 'root',
                group   => 'root',
                mode    => '644',
        }       
        file { 'cpcert' :
                ensure  => 'file',                     
                path    => '/etc/pki/tls/private/ca.csr',
                source  => 'puppet:///modules/apache/ca.csr',
                owner   => 'root',
                group   => 'root',
                mode    => '644',
        }       
	 file { 'sslconf':
                path	=> '/etc/httpd/conf.d/ssl.conf',
		ensure  => file,
                source  => 'puppet:///modules/apache/ssl.conf',
                owner   => root,
                group   => root,
                mode    => '0644',
		#require	=> Package['ssl-packages'],
        }
	   file { 'mysite' :
		ensure	=> 'directory',
		path	=> '/var/www/mysite.com',
		#recurse	=> true,
		owner	=> 'apache',
		group	=> 'apache',
		mode	=> '777',
        } 
	    file { 'publichtml' :
                ensure  => 'directory',
                path    => '/var/www/mysite.com/public_html',
                owner   => 'apache',
                group   => 'apache',
                mode    => '777',
		require	=> File['mysite'],
        }
	file { 'htmlfile' :
                ensure  => 'file',
                path    => '/var/www/mysite.com/public_html/index.html',
		source  => 'puppet:///modules/apache/index.html',
                owner   => 'apache',
                group   => 'apache',
                mode    => '777',
		require	=> File['publichtml'],
        }  
	file { 'sitesavailable' :
                ensure  => 'directory',
                path    => '/etc/httpd/sites-available',
                owner   => 'apache',
                group   => 'apache',
                mode    => '766',
	}
	file { 'sitesenable' :
                ensure  => 'directory',
                path    => '/etc/httpd/sites-enabled',
                owner   => 'apache',
                group   => 'apache',
                mode    => '766',
        } 
	file { 'httpconf' :
                ensure  => 'file',
                path    => '/etc/httpd/conf/httpd.conf',
                source  => 'puppet:///modules/apache/httpd.conf',
                owner   => 'root',
                group   => 'root',
                mode    => '644',
		require => Package['centos-apache'],
	}
	 file { 'vhostfile' :
                ensure  => 'file',
                path    => '/etc/httpd/sites-available/mysite.com.conf',
                source  => 'puppet:///modules/apache/mysite.com.conf',
                owner   => 'root',
                group   => 'root',
                mode    => '644',
        }
	file {'vhostlink' :
		ensure	=> link,
		path	=> '/etc/httpd/sites-enabled/mysite.com.conf',
		target	=> '/etc/httpd/sites-available/mysite.com.conf',
		require	=> File['vhostfile'],
	}
	 file { 'selinux' :
                ensure  => 'file',
                path    => '/etc/selinux/config',
                source  => 'puppet:///modules/apache/config',
                owner   => 'root',
                group   => 'root',
                mode    => '644',
        }
	service { 'apacheservice' :
                name            => httpd,
                ensure          => running,
                enable          => true,
                subscribe       => File['httpconf','vhostfile','htmlfile'],
        }
}
