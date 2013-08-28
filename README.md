## puppetmaster-puma

[puppet master](http://puppetlabs.com/puppet/what-is-puppet) is the server for the puppet master/agent deployment.
[Puma](http://puma.io) is "a modern, concurrent web server for ruby."

In theory, it should be possible to configure puma to handle requests to the
puppet master, enabling greater performance and request handling than the out
of the box webrick server provided by puppet. This repo will contain
packaging and automation for a meta-package that will pull in the puppet
master and puma, and configure the necessaries to enable the puppet master to
serve requests via puma.

The meta-package will be an RPM or a puppet module perhaps.
