import boto3
import os
import json

def lambda_handler(event, context):
    client = boto3.client('ecs')
    cluster=os.environ.get('CLUSTER')
    service=os.environ.get('SERVICE')
    security_group=os.environ.get('SECURITY_GROUP')
    subnet_one=os.environ.get('SUBNET_ONE')
    subnet_two=os.environ.get('SUBNET_TWO')

    print("replacing apex service...")
    response = client.update_service(
        cluster=cluster,
        service=service,
        desiredCount=2,
        taskDefinition=service,
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': [
                    subnet_one,
                    subne_two
                ]
                'securityGroups': [
                    security_group
                ],
                'assignPublicIp': 'ENABLED'
            }
        },
        forceNewDeployment=True,
        enableExecuteCommand=True
    )
