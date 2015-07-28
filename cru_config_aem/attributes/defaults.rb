# General settings
default['aem']['apache']['home'] = "/etc/httpd"
default['aem']['dispatcher']['site_name'] = "some_site"
default['aem']['dispatcher']['alias1'] = "some_site_alias"
default['aem']['dispatcher']['alias2'] = "some_site_alias"
default['aem']['dispatcher']['vhost_email'] = "some_email@domain"
default['aem']['dispatcher']['domain'] = "nil"

default[:aem][:author] = {
  :default_context => "/opt/aem/author",
  :port => "4502",
  :runnable_jar => "aem-author-p4502.jar",
  :base_dir => "/opt/aem/author/crx-quickstart",
  :jvm_opts => {},
  :ldap => {
    :enabled => false,
    :options => {}
  },

  default[:aem][:publish] = {
    :default_context => "/opt/aem/publish",
    :port => "4503",
    :runnable_jar => "aem-publish-p4503.jar",
    :base_dir => "/opt/aem/publish/crx-quickstart",
    :jvm_opts => {},
    :ldap => {
      :enabled => false,
      :options => {}
    },
