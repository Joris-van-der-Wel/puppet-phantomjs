class phantomjs::selinux::httpd {
  # Include this class if you are going to execute phantomjs from a php script
  # (assuming php is loaded as an apache module)

  if !defined(Selinux::Boolean['httpd_execmem']) {
    selinux::boolean { 'httpd_execmem':
      ensure => "on",
    }
  }

  # needed for printing to a pdf
  selinux::module { 'phantomjs_httpd_cups':
    ensure => present,
    source => 'puppet:///modules/phantomjs/phantomjs_httpd_cups.te',
  }
}
