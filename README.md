# Terraforming with workspaces

## Environment reproducibility

The use case here is that we need to be able to have identical environments for our application in which we can run development and testing on, as well as deploy into production. Workspaces will allow us to create a state file per environment, so that we can manage each environment independently, but have identical deployments of our infrastructure, like for like. With the added ability to modify networking, capacity, etc to only one environment if needed.

To implement workspaces, we are going to rely heavily on our state file and the backend. By default, when you run Terraform the persistent data is stored in your backend to a ‘default’ workspace. Hence why you have one state associated to your configuration. In Azure the backed can support multiple named workspaces, meaning we only have one backend still, but have distinct instances of that configuration to be deployed.

We will deploy 3 workspaces (you can create just 2 or more depending on your requirements), that will deploy the modules that we deployed in the last section. In effect, we’ll have a dev, test and production environment with identical resources.

## Working with Workspaces

```sh
terraform workspace new dev
```

Once that workspace is created, you can run ‘terraform plan’ and you’ll be working in that workspace. Terraform will not see any existing resources that existed in the default or any other workspace. You can then go and create a new workspace for ‘dev’ and ‘prod’. All the resources that you deploy exist but cannot be managed from another workspace.

To switch between workspaces, you will need to run:

```sh
terraform workspace select dev
```

You will be easily able to navigate between your workspaces without affecting the other ones. You can change resources or destroy a workspace that may not be needed. This makes it easier to manage our 3 environments independently, and maybe once we’re done testing our code in our ‘dev’ environment we can destroy it. Enabling us to deploy or destroy resources as needed.

## Plan an environment

```sh
terraform plan -var-file="dev/dev.tfvars"
```

## Create an environment

```sh
terraform apply -var-file="dev/dev.tfvars"
```

## Destroy an environment

```sh
terraform destroy -var-file="dev/dev.tfvars"
```
