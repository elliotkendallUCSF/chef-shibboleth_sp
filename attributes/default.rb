#
# Cookbook Name: shibboleth_sp
# Attributes:: default
#

default["shibboleth_sp"]["entityid_domain"] = "example.org"
default["shibboleth_sp"]["entityid"] = ''
default["shibboleth_sp"]["idp_entityid"] = "https://idp.example.org"
default["shibboleth_sp"]["remote_metadata"] = []
default["shibboleth_sp"]["local_metadata"] = []
default["shibboleth_sp"]["protected_paths"] = []
default["shibboleth_sp"]["optional_paths"] = []
default["shibboleth_sp"]["cert_file"] = ''
default["shibboleth_sp"]["key_file"] = ''
default["shibboleth_sp"]["user"] = 'shibd'
default["shibboleth_sp"]["local_attribute_map"] = false
default["shibboleth_sp"]["remote_user_attributes"] = "eppn eduPersonPrincipalName persistent-id targeted-id"
