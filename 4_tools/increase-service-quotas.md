[Increase service quotas]

VPC per region:
- quota code: L-F678F1CE
- service code:  vpc
- region: eu-west-1, eu-west-2, eu-west-3, north-1, eu-central-1
```
aws service-quotas request-service-quota-increase \
    --service-code vpc \
    --quota-code L-F678F1CE \
    --desired-value 30 \
    --region 
```
	
Elastic IPs (EC2-VPC Elastic IPs): 
- quota code: L-0263D0A3 ()
- service code:  ec2
- region: eu-west-1, eu-west-2, eu-west-3, north-1, eu-central-1
```
aws service-quotas request-service-quota-increase \
    --service-code ec2 \
    --quota-code L-0263D0A3 \
    --desired-value 100 \
    --region 
```

Pending peering attachment per TGW:
- quota code: L-62499967
- service code: vpc
- region: eu-central-1
```
aws service-quotas request-service-quota-increase \
    --service-code vpc \
    --quota-code L-62499967 \
    --desired-value 100 \
    --region eu-central-1
```

 Peering attachment per TGW:
- quota code: L-A1B5A36F
- service code: vpc
- region: eu-central-1
```
aws service-quotas request-service-quota-increase \
    --service-code vpc \
    --quota-code L-A1B5A36F \
    --desired-value 100 \
    --region eu-central-1
```