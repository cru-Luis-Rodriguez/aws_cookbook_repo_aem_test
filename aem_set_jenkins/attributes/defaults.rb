# General settings
default['aem']['jenkins']['jobs'] = [
  "cruorgaem6",
  "Backup_AEM_Production_Author_Repo",
  "CruOrgaem6_Auto_Production_DailyContentFlush",
  "CruOrgaem6_Manual_Prod_Pub_Designs_DispatcherClear",
  "Relay_Authentication_Handler",
  "aem6.1-communities",
  "cruorgaem6DispatcherClear",
  "cruorgaem6_PROD",
  "cruorgaem6_PRODDispatcherClear",
  "cruorgaem6_PRODPublish",
  "cruorgaem6_UAT",
  "cruorgaem6_UATDispatcherClear"

],
default['aem']['jenkins']['plugin_conf'] = [
  "jenkins.plugins.hipchat.HipChatNotifier"
]
