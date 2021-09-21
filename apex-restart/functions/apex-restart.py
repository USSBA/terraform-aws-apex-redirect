import boto3
import os
import json

def lambda_handler(event, context):
    client = boto3.client('ecs')
    cluster=os.environ.get('CLUSTER')
    service=os.environ.get('SERVICE')

    print("replacing apex service...")
    response = client.update_service(
        cluster=cluster,
        service=service,
        forceNewDeployment=True,
    )
