package main

import (
	"github.com/pulumi/pulumi-aws/sdk/v6/go/aws/ec2"
	"github.com/pulumi/pulumi-aws/sdk/v6/go/aws/rds"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

const VPV_ID = "vpc-0bf1b113d76c67336" // replace with your VPC ID

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		group, err := ec2.NewSecurityGroup(ctx, "postgres-sg", &ec2.SecurityGroupArgs{
			VpcId: pulumi.String(VPV_ID), // replace with your VPC ID
			Ingress: ec2.SecurityGroupIngressArray{
				&ec2.SecurityGroupIngressArgs{
					Protocol:   pulumi.String("tcp"),
					FromPort:   pulumi.Int(5432),
					ToPort:     pulumi.Int(5432),
					CidrBlocks: pulumi.StringArray{pulumi.String("0.0.0.0/0"), pulumi.String("86.16.93.133/32")},
				},
				&ec2.SecurityGroupIngressArgs{
					Protocol:   pulumi.String("tcp"),
					FromPort:   pulumi.Int(8080),
					ToPort:     pulumi.Int(8080),
					CidrBlocks: pulumi.StringArray{pulumi.String("0.0.0.0/0")},
				},
				&ec2.SecurityGroupIngressArgs{
					Protocol:   pulumi.String("tcp"),
					FromPort:   pulumi.Int(80),
					ToPort:     pulumi.Int(80),
					CidrBlocks: pulumi.StringArray{pulumi.String("0.0.0.0/0")},
				},
			},
			Egress: ec2.SecurityGroupEgressArray{
				&ec2.SecurityGroupEgressArgs{
					Protocol:   pulumi.String("-1"),
					FromPort:   pulumi.Int(0),
					ToPort:     pulumi.Int(0),
					CidrBlocks: pulumi.StringArray{pulumi.String("0.0.0.0/0")},
				},
			},
		})
		if err != nil {
			return err
		}

		// aws rds describe-db-subnet-groups | jq -r '.DBSubnetGroups[] | select(.VpcId=="vpc-0bf1b113d76c67336") | .DBSubnetGroupName'

		subnets, err := ec2.GetSubnets(ctx, &ec2.GetSubnetsArgs{
			Filters: []ec2.GetSubnetsFilter{
				{
					Name:   "vpc-id",
					Values: []string{VPV_ID}, // replace with your VPC ID
				},
				{
					Name:   "tag:Name",
					Values: []string{"*public*"},
				},
			},
		})
		if err != nil {
			return err
		}

		subnetGroup, err := rds.NewSubnetGroup(ctx, "rds-subnet-project-group", &rds.SubnetGroupArgs{
			SubnetIds: pulumi.StringArrayInput(pulumi.ToStringArray(subnets.Ids)),
		})
		if err != nil {
			return err
		}

		instance, err := rds.NewInstance(ctx, "pulumi-go-postgres", &rds.InstanceArgs{
			Engine:           pulumi.String("postgres"),
			EngineVersion:    pulumi.String("14.7"),
			InstanceClass:    pulumi.String("db.t3.micro"),
			AllocatedStorage: pulumi.Int(10),
			DbName:           pulumi.String("pulumigopostgres"),
			Username:         pulumi.String("postgres"),
			Password:         pulumi.String("postgres"), // DO NOT USE PLAIN TEXT PASSWORDS IN PRODUCTION
			VpcSecurityGroupIds: pulumi.StringArray{
				group.ID(), // replace with your security group ID
				// pulumi.String("sg-name"), // replace with your security group ID
			},
			DbSubnetGroupName:  subnetGroup.Name,
			PubliclyAccessible: pulumi.Bool(true),
			SkipFinalSnapshot:  pulumi.Bool(true),
		})
		if err != nil {
			return err
		}
		ctx.Export("endpoint", pulumi.Sprintf("%s", instance.Endpoint))

		return nil
	})
}
