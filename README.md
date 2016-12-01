# Docker image Debian+Apache+PHP7

A docker image to quick deploy php7 applications with apache based on debian

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See install for notes on how to deploy the project on a live system.

### Prerequisites

install [docker](https://www.docker.com) 


### Installing

Clone this repository:
```
git clone https://github.com/mcezzare/dockerphp7.git
```
Enter the docker-build folder
```
./docker_build.sh 
```

And on finish

```
./docker_compose_run.sh
```

Open your favorite Browser and navigate to http://localhost:8080/ and you'll see phpinfo()

## Running the tests

composer is installed, create a task test to invoke phpunit ;)


## Deployment

Your root apache folder is public, where you can create the index.php for bootstrap  your app or a dispatcher you may prefer.
OBS: if you don't want to use a dispatcher, remove the .htaccess file with the rewrite rule.

## Built With
Sublime text : rulez ;)

## Contributing
soon

## Versioning

soon
## Authors

* **Mario Cezzare** - *Initial work* - 
* [Personal web site](http://www.mcezzare.com.br)
* [Linkedin](http://br.linkedin.com/pub/mario-cezzare-angelicola-chiodi/16/430/425) 

## License

soon...

## Acknowledgments

I was tired of using php docker images with strange configurations, and i don't want to leave Infrastructure configurations inside the applications folder, so it's only up the container on terminal inside the docker_build folder and start to build a pretty app ;)
