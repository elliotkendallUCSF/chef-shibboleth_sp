template "/etc/yum.repos.d/shibboleth.repo" do
  mode "0644"
  source "shibboleth.repo.erb"
  # First character of version number - kind of a hack
  variables(
    :ver => node["platform_version"].to_s()[0]
  )
end

package "shibboleth" do
  action :install
end

if node['shibboleth_sp']['entityid'] != ''
  entityid = node['shibboleth_sp']['entityid']
else
  entityid = 'https://' + node.name + '.' + node['shibboleth_sp']['entityid_domain']
end

template "/etc/shibboleth/shibboleth2.xml" do
  mode "0644"
  variables(
    :entityid => entityid,
    :remote_user_attributes => node['shibboleth_sp']['remote_user_attributes']
  )
  notifies :restart, "service[shibd]"
end
script "chcon-shibboleth2.xml" do
  interpreter "bash"
  code "chcon -t httpd_config_t /etc/shibboleth/shibboleth2.xml"
end

template "/etc/httpd/conf.d/shib.conf" do
  mode "0644"
  notifies :restart, "service[httpd]"
end
script "chcon-shib.conf" do
  interpreter "bash"
  code "chcon -t httpd_config_t /etc/httpd/conf.d/shib.conf"
end

if node["shibboleth_sp"]["local_attribute_map"]
  cookbook_file "/etc/shibboleth/attribute-map.xml" do
    mode "0644"
    notifies :restart, "service[shibd]"
  end
end

node["shibboleth_sp"]["local_metadata"].each do |file|
  cookbook_file "/etc/shibboleth/#{file}" do
    mode "0644"
    notifies :restart, "service[shibd]"
  end
end

cookbook_file "/etc/shibboleth/shibd.te" do
  mode "0644"
  notifies :run, "script[shibd.te]", :immediately
end

if node['shibboleth_sp']['cert_file'] != ''
  cookbook_file "/etc/shibboleth/sp-cert.pem" do
    source node['shibboleth_sp']['cert_file']
    mode "0644"
  end
end
if node['shibboleth_sp']['key_file'] != ''
  cookbook_file "/etc/shibboleth/sp-key.pem" do
    source node['shibboleth_sp']['key_file']
    owner node['shibboleth_sp']['user']
    mode "0600"
  end
end

script "shibd.te" do
  action :nothing
  interpreter "bash"
  code <<-EOH
    checkmodule -M -m -o /etc/shibboleth/shibd.mod /etc/shibboleth/shibd.te
    semodule_package -o /etc/shibboleth/shibd.pp -m /etc/shibboleth/shibd.mod
    semodule -vi /etc/shibboleth/shibd.pp
  EOH
end

service "shibd" do
  action [:enable, :start]
end

service "httpd" do
  action :nothing
end
