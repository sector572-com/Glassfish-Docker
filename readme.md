# A Glassfish 5.x Docker Image

This docker file will download a copy of Eclipse Foundation Glassfish 5.1.0 full profile and create a runnable docker image.

## Building the Image

`docker build -t z28ss572/glassfish5 .`

## Running the Image

`docker run -p "4848:4848" -p "8080:8080" -d z28ss572/glassfish5`

## Other Notes

### Automatic Password Generation
The admin password will be generated automatically at runtime time.

The initial admin password is stored in the file:

`/var/lib/glassfish/initialAdminPassword`

You can quickly view the password by issuing the command below after the container has been started.

`docker exec -it <container id> cat /var/lib/glassfish/initialAdminPassword`

In addition, upon starting the container, you can watch for the password log message to appear by issuing the command below.

`docker logs -f <container id>`

