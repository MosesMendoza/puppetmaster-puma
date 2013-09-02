## puppetmaster-puma

[puppet master](http://puppetlabs.com/puppet/what-is-puppet) is the server for the puppet master/agent deployment.
[puma](http://puma.io) is "a modern, concurrent web server for ruby."

The common way to improve the request handling performance of the puppet master is to run it with [passenger](https://github.com/phusion/passenger) and apache [httpd](http://httpd.apache.org/). There are alternatives as well, including [nginx and unicorn](http://wiki.unixh4cks.com/index.php/Puppetmaster_:_Nginx_%2B_Unicorn). But what about puma? I learned of puma when it showed up on hacker news, and it seems promising. Can the puppet master run under a puma/nginx configuration?

Let's find out! I'm working on a debian wheezy VM with the hostname 'wheezy.localdomain'. Obviously replace any occurrences of 'wheezy.localdomain' with your hostname.

# setup

Install the puppetlabs release package for your dist from the [PL Repo](http://apt.puppetlabs.com).
```bash
    $ wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb && dpkg -i puppetlabs-release-wheezy.deb && apt-get update
```

Install puppet-common and puppetmaster-common and rack. We're using the "-common" packages because we don't need the init scripts. At the time of writing this, the latest version of puppet is 3.2.4, which is great.
```bash
    $ apt-get install puppet-common puppetmaster-common ruby-rack
```

Install nginx from the ngninx repos. The version carried by distros is pretty old. I did this by adding the ngninx repo to /etc/apt/sources.list. The version of ngninx available at the time of writing this is 1.4.2.
```bash
    $ apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62
    $ echo "deb http://nginx.org/packages/debian/ wheezy nginx" >> /etc/apt/sources.list
    $ apt-get update && apt-get install nginx
```

Install puma from rubygems. I had to install libssl-dev in order for the native extensions to build.
```bash
    $ apt-get install libssl-dev
    $ gem install puma
```

Set up the rack application root for the puppet master. This would normally set up by the puppetmaster-passenger package if we were using passenger.
```bash
    $ mkdir -p /usr/share/puppet/rack/puppetmasterd/{public,tmp}
    $ cp /usr/share/puppet/ext/rack/files/config.ru /usr/share/puppet/rack/puppetmasterd
    $ chown puppet:puppet /usr/share/puppet/rack/puppetmasterd/config.ru
```

Create the certificate for the puppet master.
```bash
    $ puppet cert generate $(puppet master --configprint certname)
```

After munging config examples from a [PL wiki page on unicorn](http://projects.puppetlabs.com/projects/1/wiki/using_unicorn) and [puma](https://github.com/puma/puma/blob/master/examples/config.rb) I came away with configs for [puma](config/puma/config.rb) and [ngninx](config/ngninx/puppetmaster.conf).

You can download and install these configs, but you'll probably want to tweak them for your environment. Don't forget to replace occurrences of "wheezy.localdomain" in the nginx config with your hostname.
```bash
    $ mkdir /etc/puma && cp config.rb /etc/puma
    $ cp puppetmaster.conf /etc/ngninx/conf.d
    $ service ngninx restart
```
Now start puma!
```bash
    $ puma -C /etc/config.rb
```
The puppet master is now running behind puma and nginx!

Exercises left to the reader:
You definitely don't want to run this setup in production as-is. First, I have not evaluated the security of this configuration in any way other than being certain its not very secure:)  Second, puma does not have any sort of process supervisor built in, so you're going to want to set up process management for puma, e.g. using something like [god](http://rubygems.org/gems/god) and service management, perhaps with [jungle](https://github.com/puma/puma/tree/master/tools/jungle).
