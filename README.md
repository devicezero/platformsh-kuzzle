# Kuzzle for Platform.sh

This template provides a Kuzzle project (API and UI). It comes pre-configured to use Elasticsearch and Redis for caching and memory storage. It is intended for you to use as a starting point and modify for your own needs.

## Features

* Node.js 14
* Elasticsearch 7.7
* Redis 5.0
* Automatic TLS certificates

## Customizations

The following changes have been made relative to a plain Kuzzle project. If using this project as a reference for your own existing project, replicate the changes below to your project.

* The `.platform.app.yaml`, `.platform/services.yaml`, and `.platform/routes.yaml` files have been added.  These provide Platform.sh-specific configuration and are present in all projects on Platform.sh.  You may customize them as you see fit.
* `kuzzle-api/.environment` dynamically passes current connection information and credentials to Kuzzle via environment variables.
* The `kourou` CLI is installed. If you want to use it, you need to add the password for the admin user as an environment variable:
```platform variable:create --level project --sensitive true --name env:KUZZLE_PASSWORD --value your_password```
* The Kuzzle UI is available as a `admin.…` subdomain. The connection is set up as a web socket, the connection info is:
  * Host: Your main route, without schema and the `/ws` path, e.g. `foobar-sg3i2vq-randomprojectid.eu-4.platformsh.site/ws`
  * Port: 443
  * SSL: true


## References

* [Kuzzle](https://kuzzle.io/)
* [Node.js on Platform.sh](https://docs.platform.sh/languages/nodejs.html)
