# EBS Delete old snapshots
Find any old snapshots that have been there longer than x days and deletes them

## Getting Started

These instructions will get you a copy of the Tool up and running on your local machine.

### Prerequisites
backend and provoder setup

Usage 
module "aws_ebs_cleanup" {
  source                  = ""

}
```



## Optional Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| snapshot\_cleanup\_cron | Rate expression for when to run the review of snaps| string | `"cron(0 0 ? * * *)"` | no 
| function\_prefix | Prefix for the name of the lambda created | string | `""` | no |
| time\_interval| how many days a volumes needs to be unattached to delete| string | `"7"` | no |
| DryRun| True or false for if you want the lambda to delete the snaps| string | `"false"` | no |

## Testing 

Configure your AWS credentials using one of the [supported methods for AWS CLI
   tools](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html), such as setting the
   `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. If you're using the `~/.aws/config` file for profiles then export `AWS_SDK_LOAD_CONFIG` as "True".
1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
1. Install [Golang](https://golang.org/) and make sure this code is checked out into your `GOPATH`.
cd test
go mod init github.com/sg/sch
go test -v -run TestTerraformAws