# RedHatSetup
In order to pull from redhats container registry to run openshift, we need to get a pullSecret from them.
Register at https://developer.redhat.com and then login at https://console.redhat.com
There navigate to https://console.redhat.com/openshift/create/local and copy the pullSecret

# IAM Setup
You need to setup an iam user to be used by the openshift-installer. This credentials also getting persistet within the cluster, for future node autoscaling and maintenance tasks.
https://docs.okd.io/4.10/installing/installing_aws/installing-aws-account.html#installation-aws-iam-user_installing-aws-account

Save the credentials in .aws/credentials and set the profile
```export AWS_PROFILE=okd-poc```

# DNS Setup
You need to setup the basedomain in Route53 and do a proper zone delegation in your dns first.
https://us-east-1.console.aws.amazon.com/route53/v2/hostedzones#


# Cluster Setup
Run the openshift installer
```
# caution: create cluster command "consumes" the install-config.yaml stored in this ./cluster-config
openshift-install create cluster --dir=cluster-config
```

Create an AWS programatic IAM User with access to read from secretsmanager and store the credentials in your desired .env.${PHASE}

Start Setup Custom Compontents
```./setup-components.sh```


# STXT - SRF POC Issues
- allowed uid range starts from 1000710000, we are using almost always 1000 which is forbidden on okd
- build-robot should be implemented, not quite sure if it can be done as in cargo
- Global registry credentials, ideally password less access to registry.swisstxt.ch as in the other cargos
- Argocd User-Login für Deployments in Github Action
