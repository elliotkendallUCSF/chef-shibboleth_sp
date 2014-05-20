maintainer        "Elliot Kendall"
maintainer_email  "elliot.kendall@ucsf.edu"
license           "Apache 2.0"
description       "Install and configure Shibboleth SP"
version           "0.1.2"

recipe "shibboleth_sp", "Install and configure Shibboleth SP"

%w{ centos }.each do |os|
  supports os
end
