Description
===========

Installs the Shibboleth SAML SP and Apache module

Requirements
============

Platform
--------

Tested and developed on CentOS

Cookbooks
---------

Requires an install of Apache that reads /etc/httpd/conf.d, like the one
that comes with most RedHat-like systems.

Attributes
==========

* `node["shibboleth_sp"]["entityid"]` - The entityID to use for this SP.  If
set, `entityid_domain` is ignored.

* `node["shibboleth_sp"]["entityid_domain"]` - The DNS domain name suffix to
append to the system's hostname to generate an entityID.  Ignored if
`entityid` is set.

* `node["shibboleth_sp"]["idp_entityid"]` - The entityID of the SAML IdP to
authenticate to.  WAYF is not yet supported.

* `node["shibboleth_sp"]["remote_metadata"]` - A list of URLs from which to
download and load metadata.  If using HTTP URLs, you should also use
metadata signature checking, which is not yet supported by this cookbook.

* `node["shibboleth_sp"]["local_metadata"]` - A list of local files from
which to load metadata.  Each file listed here should be placed in
files/default/.

* `node["shibboleth_sp"]["protected_paths"]` - A list of absolute paths on
the Apache server which should require Shibboleth authentication, each of
which should end with a slash.  Set this to `/` if you want the entire web
server protected.

* `node["shibboleth_sp"]["optional_paths"]` - A list of absolute paths on
the Apache server which should support but not require Shibboleth
authentication, each of which should end with a slash.  In other words,
these locations will get environment variables for attributes from already
existing Shibboleth sessions, but not force people to log in if they have no
existing session.  Set this to `/` if you want the entire web server to
support Shibboleth auth.

* `node["shibboleth_sp"]["cert_file"]` - The name of a PEM certificate file
to be used by the SP. The file should be placed in files/default/.  If this
attribute is not set, a certificate will be automatically generated.

* `node["shibboleth_sp"]["cert_file"]` - The name of a PEM private key file
to be used by the SP.  The file should be placed in files/default/.  If this
attribute is not set, a key will be automatically generated.

* `node["shibboleth_sp"]["user"]` - The user that shibd runs as. Defaults
to `shibd`.

* `node["shibboleth_sp"]["local_attribute_map"]` - Set to true if you want
to use a custom attribute-map.xml file.  If you do, also place it in
files/default/.

Usage
=====

Either set `entityid_domain` to your organization's domain name to
auto-generate entityIDs from server hostnames, or set `entityid` directly.

Set one or both of `remote_metadata` and `local_metadata` to load metadata
for your IdP.

Set `idp_entityid` to match your IdP.

Set `protected_paths` to include the paths you want to require
authentication.

If you want to use an existing SSL certificate and private key, place them
in files/default/ and set `cert_file` and `key_file` with their names.  This
is necessary if the SP will be spread across multiple load-balanced systems
using the same entityID.

Here is an example node configuration:

    {
      "name": "shibboleth-sp",
      ...
      "run_list": [
        ...
        "recipe[shibboleth-sp]"
      ],
      "override_attributes": {
        ...
        "shibboleth_sp": {
          "entityid_domain": "ucsf.edu",
          "local_metadata": "idp-metadata.xml",
          "idp_entityid": "urn:mace:incommon:ucsf.edu",
          "protected_paths": [ "/secure/" ],
          "optional_paths": [ "/" ],
          "local_attribute_map": true
        }
      }
    }

License and Author
==================

Author:: Elliot Kendall (<elliot.kendall@ucsf.edu>)

Copyright:: 2013, Regents of the University of California
