output "droplet-ip" {
    value = "${digitalocean_droplet.single.ipv4_address}"
}
