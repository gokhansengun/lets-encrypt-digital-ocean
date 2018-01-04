## Introduction

This repo includes 

- A very basic Terraform configuration to create one droplet in DigitalOcean and an ssh key to connect to it. 

## Instructions for DigitalOcean

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

- `Terraform` will output the droplet's public ip address, take a note of it.

- Run below command to generate SSL/TLS certificate from Let's Encrypt

```bash
$ certbot certonly -n --standalone --email gokhansengun@gmail.com --rsa-key-size 4096 -d do-demo.gokhansengun.com --agree-tos --no-eff-email
```

