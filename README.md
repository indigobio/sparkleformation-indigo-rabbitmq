## sparkleformation-indigo-rabbitmq
This repository contains a SparkleFormation template that creates a RabbitMQ
EC2 instance.

Additionally, the template creates a private Route53 (DNS) CNAME record:
rabbitmq.`ENV['private_domain']`.

### Dependencies

The template requires external Sparkle Pack gems, which are noted in
the Gemfile and the .sfn file.  These gems interact with AWS through the
`aws-sdk-core` gem to identify or create  availability zones, subnets, and 
security groups.

### Parameters

When launching the compiled CloudFormation template, you will be prompted for
some stack parameters:

| Parameter | Default Value | Purpose |
|-----------|---------------|---------|
| ChefRunlist | role[base],role[openvpn_as] | No need to change |
| ChefServer | https://api.opscode.com/organizations/product_dev | No need to change |
| ChefValidationClientName | product_dev-validator | No need to change |
| ChefVersion | 12.4.0 | No need to change |
| RabbitmqAssociatePublicIpAddress | false | No need to change |
| RabbitmqDeleteEbsVolumesOnTermination | true | Set to false if you want the EBS volumes to persist when the instance is terminated |
| RabbitmqDesiredCapacity | 1 | No need to change |
| RabbitmqEbsOptimized| false | Enable EBS optimization for the instance (instance type must be an m3, m4, c3 or c4 type; maybe others) |
| RabbitmqEbsVolumeSize | 10 | Size (in GB) of additional EBS volumes |
| RabbitmqInstanceMonitoring | false | Set to true to enable detailed cloudwatch monitoring (additional costs incurred) |
| RabbitmqInstanceType | t2.small | Increase the instance size for more network throughput |
| RabbitmqMaxSize | 1 | No need to change |
| RabbitmqMinSize | 0 | No need to change |
| RabbitmqNotificationTopic | auto-determined | No need to change |
| RootVolumeSize | 12 | No need to change |
| SshKeyPair | indigo-bootstrap | No need to change |
