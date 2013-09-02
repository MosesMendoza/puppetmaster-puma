## puppetmaster-puma

[puppet master](http://puppetlabs.com/puppet/what-is-puppet) is the server for the puppet master/agent deployment.
[Puma](http://puma.io) is "a modern, concurrent web server for ruby."

The common way to improve the request handling performance of the puppet master is to run it with [passenger](https://github.com/phusion/passenger) and apache [httpd](http://httpd.apache.org/). There are alternatives as well, including [nginx and unicorn](http://wiki.unixh4cks.com/index.php/Puppetmaster_:_Nginx_%2B_Unicorn). But what about puma? I learned of puma when it showed up on hacker news, and it seems promising. How would the puppet master perform under a puma/nginx configuration?

Let's find out! I'm working on a debian wheezy VM with the hostname 'wheezy.localdomain'. Obviously replace any occurrences of 'wheezy.localdomain' with your hostname.

# setup

Install the puppetlabs release package for your dist from the [PL Repo](http://apt.puppetlabs.com).

  `$ wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb && dpkg -i puppetlabs-release-wheezy.deb && apt-get update`

Install puppet-common and puppetmaster-common and rack. We're using the "-common" packages because we don't need the init scripts.

  `$ apt-get install puppet-common puppetmaster-common ruby-rack`

Set up the rack application root for the puppet master. This would normally set up by the puppetmaster-passenger package if we were using passenger.

   `$ mkdir -p /usr/share/puppet/rack/puppetmasterd/{public,tmp}
    $ cp /usr/share/puppet/ext/rack/files/config.ru /usr/share/puppet/rack/puppetmasterd
    $ chown puppet:puppet /usr/share/puppet/rack/puppetmasterd/config.ru
   `
Create the certificate for the puppet master.

    $ puppet cert generate $(puppet master --configprint hostcert)
 

