provider "digitalocean" {
}

data "digitalocean_image" "worker-snapshot" {
  name = "packer-hashi-dev-box-ubuntu-1604-v180104"
}

resource "digitalocean_ssh_key" "single-droplet-ssh" {
  name       = "single-droplet-ssh"
  public_key = "${file("../ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "single" {
  image  = "${data.digitalocean_image.worker-snapshot.image}"
  name   = "single-droplet-node"
  region = "ams2"
  size   = "512mb"

  ssh_keys = [ "${digitalocean_ssh_key.single-droplet-ssh.id}" ]

  connection {
    user        = "root"
    private_key = "${file("../ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello there' > /root/world"
    ]
  }
}
