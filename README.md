# terraform-test
An example of three major cloud provider implementations in Terraform

This is primarily an initial experiment, but I plan to build some cool stuff with these configurations soon.
All three provider configurations work if you set up:

1. a User Account profile with editor access for AWS.
2. a service account credential as ADC with editor access for GCP.
3. a Service Principal with Contributor access for Azurerm.

If you have all three of those credentials set up to authenticate your CLI tools for the respective platforms with system
environment variables, the code in this main.tf file should run fine with the standard command order:

```
terraform init
terraform plan
terraform apply
```

I'll be publishing instructions soon for setting up those credentials in detail.
For now, this is just an example of how you can spin up basic compute instances on all three platforms. Happy cloud architecting!
