terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.59.0"
    }
    google = {
      source = "hashicorp/google"
      version = "4.57.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.48.0"
    }
  }
}

provider "aws" {
  profile = "developer"
  region  = "us-east-2"
}

provider "google" {
  project = "podcast-platform-23"
  region = "us-central1"
}

provider "azurerm" {
  features {}
  use_msi = true
}

resource "azurerm_resource_group" "example" {
  name     = "terraform-example"
  location = "eastus"
}

variable "ADMIN_PASSWORD" {
  type    = string
  description = "The admin password for the virtual machine"
}

resource "azurerm_linux_virtual_machine" "hello-azure" {
  name                  = "terraform-vm"
  location              = "eastus"
  resource_group_name   = "terraform-example"
  size                  = "Standard_DS1_v2"
  admin_username        = "adminuser"
  admin_password = var.ADMIN_PASSWORD
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name              = "osdisk-terraform"
    caching           = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}
resource "azurerm_network_interface" "example" {
  name                = "terraform-nic"
  location            = "eastus"
  resource_group_name = "terraform-example"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "terraform-subnet"
  resource_group_name  = "terraform-example"
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_virtual_network" "example" {
  name                = "terraform-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
}
resource "aws_instance" "hello_aws" {
  ami           = "ami-05502a22127df2492"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloAWS"
  }
}

resource "google_compute_instance" "hello_google" {
  name = "terraform-instance"
  machine_type = "f1-micro"
  zone = "us-central1-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}