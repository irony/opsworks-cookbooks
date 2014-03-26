opsworks-cookbooks for MEAN stacks
==================

This is a fork of the official AWS opsworks recipes but adjusted to work well with NodeJS. 

## NodeJS adjustments
* The default starting file is not the unusual server.js but defaco standard index.js
* The default port is 3000 (or whatever you configure it to be in the stack settings, see below)
* Npm install output is logged to the log output
* Npm install runs with --production flag meaning it will not install your local dev settings, as grunt, tests etc.
* The stack settings is exported to a config.json file which is ideal to load with [nconf](https://github.com/flatiron/nconf)
* Multiple node instances are allowed on the same machine and when new deployments are published, only the deployed app will be restarted. Since each app has it's own port you are not getting annyoing conflicts on ports etc.

## How to use
Fork this lib to your own and specify the git URL in the stack settings.
![Change stack settings repository](http://cl.ly/image/0J432g2z3L3B/Image%202014-03-25%20at%2010.15.11%20em.png)

Note! *If you plan to use the current URL directly, please watch this repository so I can communicate with you when breaking changes occur*

## Stack settings
Every app will recieve all custom configuration settings from the stack settings JSON as a config.json file in the current app directory so you either can use `require('./config').port` or use  [nconf](https://github.com/flatiron/nconf) to adjust your application accordingly. To do this you just add a node for each application in the stack settings under the deploy node:
    
    {
      "deploy": {
        "app" : {
          "port" : "3000"
        },
        "worker" : {
          "port" : "4000",
          "custom": {
            "host": "...",
            "port": "...",
            "password": "..."
          },
        }
      }
    }
    
## Included additional recipes
I also have included some recipes that can be handy to have when running NodeJs:
* MongoDB (submodule from [Edelight/chef-mongodb](https://github.com/edelight/chef-mongodb)
* Redis (submodule from [jtescher/redis](https://github.com/jtescher/redis)
* dependencies to get all to work (Build essentials, Python etc)

To use MongoDB, just add these recepies to your layer:
![Settings for layer to configure MongoDB in Opsworks](http://cl.ly/image/1D1J0s3L0w06/Image%202014-03-25%20at%2010.31.30%20em.png)
*Note! Remember to add a separate EBS volume for the data and logs, the locations can be customized in the stack settings*
 
 Stack settings for replicaset, (you still manually need to connect them though with rs.conf() ):
 
    {
       ...
       "mongodb": {
          "auto_configure": {
            "replicaset": "true"
          },
          "cluster_name": "mongo-rs",
          "replicaset_name": "mongo-rs",
          "config" : {
            "dbpath" : "/data/mongo",
            "logpath" : "/data/log"
          }
        }, 
        "redis" : {
          "db_dir" : "/data/redis"
        },
    }

See also <https://aws.amazon.com/opsworks/>

LICENSE: Unless otherwise stated, cookbooks/recipes originated by Amazon Web Services are licensed
under the [Apache 2.0 license](http://aws.amazon.com/apache2.0/). See the LICENSE file. Some files
are just imported and authored by others. Their license will of course apply.
