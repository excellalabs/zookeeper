#! /usr/bin/python

from boto import ec2
import boto.utils
import argparse, time, os, json, sys, commands

def wait_fstab(device_key, expected_status):
    volume_status = 'not present'
    sleep_seconds = 2
    sleep_intervals = 30
    for counter in range(sleep_intervals):
        print 'waiting for fstab - elapsed: %s. status: %s.' % (sleep_seconds * counter, volume_status)
        try:
            os.stat(device_key)
            volume_status = expected_status
        except: OSError
            # mount does not exsit yet
            # try again later
        if volume_status == expected_status:
            break
        time.sleep(sleep_seconds)

    if volume_status != expected_status:
        raise Exception('Unable to get %s status for volume %s' % (expected_status, volume.id))

    print 'volume now in %s state' % expected_status


def wait_volume(conn, volume, expected_status):
    volume_status = 'waiting'
    sleep_seconds = 2
    sleep_intervals = 30
    for counter in range(sleep_intervals):
        print 'waiting for volume - elapsed: %s. status: %s.' % (sleep_seconds * counter, volume_status)
        conn = ec2.connect_to_region('us-east-1')
        volume_status = conn.get_all_volumes(volume_ids=[volume.id])[0].status
        if volume_status == expected_status:
            break
        time.sleep(sleep_seconds)

    if volume_status != expected_status:
        raise Exception('Unable to get %s status for volume %s' % (expected_status, volume.id))

    print 'volume now in %s state' % expected_status

def get_volume(conn, region_name, instance_az, tag):
    volumes = conn.get_all_volumes(
            filters={'tag:Name':tag,
                     'availability-zone':instance_az,
                     'status':'available'})

    if volumes:
        return volumes[0]
    else:
        return create_volume (conn, instance_az, tag)

def create_volume(conn, zone, tag):
    volume = conn.create_volume(
            volume_type='gp2',
            encrypted='true',
            size='100',
            zone=zone)

    wait_volume(conn, volume, 'available')
    volume.add_tag('Name', tag)
    return volume

def attach_volume(conn, instance_id, volume, device_key):
    volume_status = conn.attach_volume(volume.id, instance_id, device_key)
    wait_volume(conn, volume, 'in-use')
    wait_fstab(device_key, 'present')
    return True

def format_volume(device_key):
    volume_state = commands.getstatusoutput('file -s ' + device_key)
    if device_key + ': data' in volume_state:
        print 'formatting volume'
        commands.getstatusoutput('mkfs -t ext4 ' + device_key)

def mount_volume(device_key, mount_point):
    print 'mounting volume'
    commands.getstatusoutput('mount ' + device_key + ' ' + mount_point)


tag = sys.argv[1]
device_key = sys.argv[2]
mount_point = sys.argv[3]
data = boto.utils.get_instance_identity()
region_name = data['document']['region']
instance_id = data['document']['instanceId']
instance_az = data['document']['availabilityZone']

conn = ec2.connect_to_region(region_name)
volume = get_volume(conn, region_name, instance_az, tag)

attach_volume(conn, instance_id, volume, device_key)
format_volume(device_key)
mount_volume(device_key, mount_point)

print 'done'
