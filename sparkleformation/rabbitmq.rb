ENV['volume_count']       ||= '2'
ENV['volume_size']        ||= '10'
ENV['sg']                 ||= 'private_sg'
ENV['chef_run_list']      ||= 'role[base],role[rabbitmq_server]'
ENV['notification_topic'] ||= "#{ENV['org']}-#{ENV['environment']}-deregister-chef-node"

SparkleFormation.new('rabbitmq').load(:base, :chef_base, :trusty_ami, :ssh_key_pair).overrides do
  set!('AWSTemplateFormatVersion', '2010-09-09')
  description <<"EOF"
RabbitMQ EC2 instance, configured by Chef.  Route53 record: rabbitmq.#{ENV['private_domain']}.
EOF

  dynamic!(:iam_instance_profile, 'rabbitmq',
           :policy_statements => [ :modify_route53 ],
           :chef_bucket => registry!(:my_s3_bucket, 'chef')
          )

  dynamic!(:launch_config, 'rabbitmq',
           :iam_instance_profile => 'RabbitmqIAMInstanceProfile',
           :iam_role => 'RabbitmqIAMRole',
           :create_ebs_volumes => true,
           :volume_count => ENV['volume_count'].to_i,
           :volume_size => ENV['volume_size'].to_i,
           :security_groups => _array( registry!(:my_security_group_id) ),
           :chef_run_list => ENV['chef_run_list']
          )

  dynamic!(:auto_scaling_group, 'rabbitmq',
           :min_size => 0,
           :desired_capacity => 1,
           :max_size => 1,
           :launch_config => :rabbitmq_auto_scaling_launch_configuration,
           :subnet_ids => registry!(:my_private_subnet_ids),
           :notification_topic => registry!(:my_sns_topics, ENV['notification_topic'])
          )
end
