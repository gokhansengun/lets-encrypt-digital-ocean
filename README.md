## Introduction

This repo includes 

- A very basic Terraform configuration to create one droplet in DigitalOcean and an ssh key to connect to it.
- Usage of `certbot` tool to generate `Let's Enrcypt` certificate and private key for the domain.
- An Nginx web server configuration using the certificate and private key generated.

**NOTE:** You should use your own domain and enter the DNS routing with your DNS provider. Example is given for my own domain `do-demo.gokhansengun.com`

### Prerequisite

`terraform` must be installed in the user machine following below instructions.

### Create the Droplet in DigitalOcean with Terraform

- Using DigitalOcean dashboard, create an API token and add it to a local file named like `~/.digitalocean_api_token`

    Its contents may look like below

    ```bash
    $ export DIGITALOCEAN_TOKEN=ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789
    ```

- Open a shell, go to `Terraform` folder and source the file that includes the token, this will add token to the environment variables

    ```bash
    $ cd Terraform
    $ source ~/.digitalocean_api_token
    ```

- Change ssh private key's permissions and run `terraform plan` and `terraform apply`

    ```bash
    $ (sudo) chmod 400 ../ssh/id_rsa # properly set the private key's permissions
    $ terraform plan # to confirm the infrastructure
    $ terraform apply
    ```

- `Terraform` will output the droplet's public ip address, take a note of it and enter an `A DNS Record` in your DNS provider.

- Ssh into the droplet using below command

    ```
    $ ssh -i ../ssh/id_rsa root@<DROPLET_IP_ADDR>
    ```

### Generate the Let's Encrypt Certificates

- Run below command to generate SSL/TLS certificate from Let's Encrypt

    ```bash
    $ certbot certonly -n --standalone --email gokhansengun@gmail.com --rsa-key-size 4096 -d do-demo.gokhansengun.com --agree-tos --no-eff-email
    ```

- Copy generated certificate and private key to root's home folder

    ```
    $ mkdir -p /root/certs
    $ cp /etc/letsencrypt/live/do-demo.gokhansengun.com/fullchain.pem /root/certs/
    $ cp /etc/letsencrypt/live/do-demo.gokhansengun.com/privkey.pem /root/certs/
    ```

- Run Nginx in folder `/root` using Docker by mapping the certs and configuration file

    ```
    $ docker run --rm -p 443:443 \
      -v $(pwd)/certs:/etc/nginx/certs \
      -v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf \
      nginx:1.10
    ```

You should see something like below for your domain.

![nginx tls view](https://github.com/gokhansengun/lets-encrypt-digital-ocean/raw/master/images/demo-image.png "Nginx TLS View")

