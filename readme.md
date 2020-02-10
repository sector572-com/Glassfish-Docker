# A Glassfish 5.x Docker Image

This docker file will download a copy of Eclipse Foundation Glassfish 5.1.0 full profile and create a runnable docker image.

## Building the Image

docker build -t z28ss572/glassfish5 .

## Running the Image

docker run -p "4848:4848" -p "8080:8080" -d z28ss572/glassfish5

## Other Notes

If you would like to change the administrator password, please update the following files and rebuild the image.

1. new_passwordfile.txt
2. old_passwordfile.txt

