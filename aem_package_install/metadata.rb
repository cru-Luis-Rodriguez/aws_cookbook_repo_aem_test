name             'aem_package_install'
maintainer       'cru'
maintainer_email 'luis.rodriguez@cru.org'
license          'All rights reserved'
description      'Configures Chef server enviroment variable for use in Opsworks'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'




depends "aws"
depends "aem_s3_load"
