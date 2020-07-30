
import boto3
import datetime
import logging
import os

logging.basicConfig()
logger = logging.getLogger()
logger.setLevel(logging.INFO)
ec2 = boto3.client('ec2', 'eu-west-1')
account_id = os.environ['ACCOUNT_ID']


def lambda_handler(event, context):

    response = ec2.describe_snapshots(
        OwnerIds=[account_id]
    )
    delete(response, 10, ec2)

def delete(response, time_interval, ec2_client):
    for snapshot in response['Snapshots']:
        time_difference = str(datetime.datetime.now() - snapshot['StartTime'].replace(tzinfo=None)).split(' ')
        logger.info('Age of snapshot {0} is {1} days old'.format(snapshot['SnapshotId'], time_difference[0]))
        if len(time_difference) > 1 and int(time_difference[0]) >= time_interval:
            try:
                logger.info('Deleting snapshot - {0}'.format(snapshot['SnapshotId']))
                output = ec2_client.delete_snapshot(SnapshotId=snapshot['SnapshotId'],   DryRun=False)
                logger.info('Snapshot {0} has been successfully deleted'.format(snapshot['SnapshotId']))
            except:
                logger.error('Snapshot {0} could not be deleted'.format(snapshot['SnapshotId']))
        else:
            logger.info('Snapshot {0} is not older than the retention period...skipping...'.format(snapshot['SnapshotId']))
