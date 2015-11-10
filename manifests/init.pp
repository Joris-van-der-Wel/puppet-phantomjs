class phantomjs (
  $download_url = $phantomjs::params::download_url,
  $download_sha256sum = $phantomjs::params::download_sha256sum,
  $install_dir = $phantomjs::params::install_dir,
) inherits phantomjs::params {

  include phantomjs::install
}

class phantomjs::params {
  $install_dir = "/opt/phantomjs-1.9.7-x86_64"
  $download_url = "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2"
  $download_sha256sum = '473b19f7eacc922bc1de21b71d907f182251dd4784cb982b9028899e91dcb01a'
}

class phantomjs::install {
  $verifyDownload = "/bin/sha256sum -b '/root/${phantomjs::download_sha256sum}.tar.bz2' | /bin/grep '${phantomjs::download_sha256sum}'"

  ensure_packages(['wget', 'tar', 'bzip2']) # stdlib

  exec { 'download phantomjs':
    require => [ Package['wget'] ],
    command => "/bin/wget -O '/root/${phantomjs::download_sha256sum}.tar.bz2' '${phantomjs::download_url}' && ($verifyDownload) && /bin/rm -Rf '${phantomjs::install_dir}'",
    unless => "$verifyDownload",
    notify => Exec['extract phantomjs']
  }
  ->
  file { $phantomjs::install_dir:
    ensure => 'directory',
  }
  ->
  exec { 'extract phantomjs':
    require => [ Package['tar'], Package['bzip2'] ],
    command => "/bin/tar -jxf '/root/${phantomjs::download_sha256sum}.tar.bz2' -C '${phantomjs::install_dir}' --strip-components=1",
    creates => "${phantomjs::install_dir}/bin",
  }
  ->
  file { '/usr/bin/phantomjs':
    ensure => 'link',
    target => "${phantomjs::install_dir}/bin/phantomjs",
  }
}
