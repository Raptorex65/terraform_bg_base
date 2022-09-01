resource "random_password" "password" {
  # Keepers: Arbitrary map of values that, when changed, will trigger recreation of resource
  keepers = {
    datetime = timestamp()
  }
  length  = 16
  special = true
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}

resource "random_uuid" "guid" {
}

output "guid" {
  value = random_uuid.guid.result
}

resource "tls_private_key" "tls" {
  algorithm = "RSA"
}

resource "local_file" "tls-public" {
  filename = "id_rsa.pub"
  content  = tls_private_key.tls.public_key_openssh
}

resource "local_file" "tls-private" {
  filename = "id_rsa.pem"
  content  = tls_private_key.tls.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 id_rsa.pem"
  }
}
