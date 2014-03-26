opsworks-cookbooks for MEAN stacks
==================

This is a fork of the official AWS opsworks recipes but adjusted to work well with NodeJS. 

## NodeJS adjustments
* The default starting file is not the unusual server.js but defaco standard index.js (or whatever you configure it to be in stack settings)
* The default port is 3000 (or whatever you configure it to be in the stack settings, see below)
* Npm install output is logged to the log output
* Npm install runs with --production flag meaning it will not install your local dev settings, as grunt, tests etc.
* The stack settings is exported to a config.json file which is ideal to load with [nconf](https://github.com/flatiron/nconf)
* Multiple node instances are allowed on the same machine and when new deployments are published, only the deployed app will be restarted
* 

See also <https://aws.amazon.com/opsworks/>

LICENSE: Unless otherwise stated, cookbooks/recipes originated by Amazon Web Services are licensed
under the [Apache 2.0 license](http://aws.amazon.com/apache2.0/). See the LICENSE file. Some files
are just imported and authored by others. Their license will of course apply.
