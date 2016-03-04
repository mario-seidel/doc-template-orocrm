# doc Template for OroCRM

This template can be used with doc script from [doc repo](https://github.com/mario-seidel/doc)

**Usage:**

```doc initproject myorocrm```

This will build all needed images and you will be on a system where the
development can be started immediately after the TYPO3 installation is finished.

When the built is finished you will get 2 images:
- myusername/myorocrm:1.0
- myusername/orobase:latest

```doc up local``` - Brings up the containers configured in docker-compose.local.yml and mounts
the sources directory as volume to the web container for local development.

```doc deploy username/projectname``` - tags and push the image passed as second parameter
(image name must exist in docker-compose.yml)
