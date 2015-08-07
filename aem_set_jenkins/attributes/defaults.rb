# General settings
default['aem'['jenkins']['ssh_key'] = %w{config id_rsa id_rsa.pub}
default['aem']['jenkins']['jobs'] = %w{cruorgaem6 Backup_AEM_Production_Author_Repo CruOrgaem6_Auto_Production_DailyContentFlush CruOrgaem6_Manual_Prod_Pub_Designs_DispatcherClear Relay_Authentication_Handler aem6.1-communities cruorgaem6DispatcherClear cruorgaem6_PROD cruorgaem6_PRODDispatcherClear cruorgaem6_PRODPublish cruorgaem6_UAT cruorgaem6_UATDispatcherClear}
default['aem']['jenkins']['plugin_conf'] = %w{jenkins.plugins.hipchat.HipChatNotifier jenkins.plugins.slack.SlackNotifier hudson.scm.CVSSCM jenkins.plugins.slack.SlackNotifier}
default['aem']['jenkins']['plugins'] = [
   'disk-usage',
   'ant',
   'cas-plugin',
   'cas1',
   'credentials',
   'cvs',
   'external-monitor-job',
   'git-client',
   'git',
   'hipchat',
   'javadoc',
   'junit',
   'ldap',
   'mailer',
   'mapdb-api',
   'matrix-auth',
   'matrix-project',
   'maven-info',
   'maven-plugin',
   'metrics-diskusage',
   'metrics',
   'antisamy-markup-formatter',
   'pam-auth',
   'scm-api',
   'script-security',
   'slack',
   'ssh-credentials',
   'ssh-slaves',
   'subversion',
   'token-macro',
   'translation',
   'windows-slaves'
]
