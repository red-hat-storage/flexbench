#!/usr/bin/env python2
"""Canary monitor that performs repeated S3 bucket and object operations

Based on the Kyle Bader's work -
https://gist.github.com/mmgaggle/198004a3e88d124bed48747e8448eac3

"""

import logging
import time
import sys
import os
import string
import random
import binascii
import socket

from argparse import ArgumentParser
from ConfigParser import ConfigParser

import boto
import boto.s3.connection

__author__ = "Paul Cuzner"
__email__ = "pcuzner@redhat.com"
__license__ = "GPL"
__credits__ = ["Paul Cuzner", "Kyle Bader"]


class GraphiteException(Exception):
    pass


class DummyMetrics(object):
    """
    Dummy metrics class. Methods here must mirror the real metric class
    methods.
    """

    def connect(self):
        pass

    def send(self, msg=None):
        pass

    def disconnect(self):
        pass


class Graphite(object):
    """
    Class handling the connection and metrics sent to a Graphite/influxdb
    plaintext target for monitoring response times.
    """

    def __init__(self, host='127.0.0.1', port=2004, prefix="ceph"):
        """
        Define the connection settings for graphite/influxdb
        :param host:
        :param port:
        """
        self.host = host
        self.port = port
        self.addr = (host, port)
        self.socket = None
        self.msg_prefix = "{}.{}.".format(prefix,
                                         socket.gethostname())

    def connect(self):

        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.settimeout(1)

        try:
            self.socket.connect(self.addr)
        except socket.timeout:
            raise GraphiteException("Unable to connect - timeout")
        except socket.gaierror:
            raise GraphiteException("Unknown error connecting")
        except Exception as error:
            raise GraphiteException("Unknown exception : {}".format(error))

    def send(self, message=None):
        """
        Send metrics to the plaintext interface port of graphite/influxdb
        NB. A \n signifies end of message to the server - without it metrics
            will not show up!
        :param message: (str) text of the form "<metric_name> <metric_value>"
        :return: None
        """

        # if the msg is only two parms, add current time
        if len(message.split()) == 2:
            suffix = "{}\n".format(int(time.time()))

        else:
            # assume the msg includes epoc timestamp
            suffix = "\n"

        msg = "{}{} {}\n".format(self.msg_prefix, message, suffix)

        self.socket.sendall(msg)

    def disconnect(self):

        self.socket.shutdown(1)
        self.socket.close()


class RGWTest(object):
    """
    RGW test class providing base class operations and test_sequence method
    that links the bucket/object operations together into a workflow
    """

    test_bucket = "canary"

    def __init__(self, bucket_name=None, runtime_opts=None):
        """
        Create a RGW test instance
        :param bucket_name: (str) bucket name to use for canary testing
        :param runtime_opts: (obj) runtime options
        """

        hostname, port = runtime_opts.rgw.split(':')
        self.opts = runtime_opts
        self.conn = boto.connect_s3(
                                    aws_access_key_id=self.opts.access_key,
                                    aws_secret_access_key=self.opts.secret_key,
                                    host=hostname,
                                    port=int(port),
                                    is_secure=False,
                                    calling_format=boto.s3.connection.OrdinaryCallingFormat(),
                                   )
        self.canary_bucket = bucket_name if bucket_name else RGWTest.test_bucket
        self.objects = []   # list of object names in the canary bucket
        self.obj_size = self.opts.object_size
        self.seed_contents = self._create_seed()
        self.clean_up()

        if self.opts.graphite_server:
            g_host, g_port = self.opts.graphite_server.split(":")
            self.metrics = Graphite(host=g_host,
                                    port=int(g_port),
                                    prefix=self.opts.prefix)
        else:
            self.metrics = DummyMetrics()

        self.metrics.connect()

    def clean_up(self):

        for bkt in self.conn.get_all_buckets():
            if bkt.name == self.canary_bucket:
                logger.debug("Clearing old bucket contents")
                for key in bkt.list():
                    bkt.delete_key(key)
                self.conn.delete_bucket(bkt.name)

    def _create_seed(self):
        return binascii.b2a_hex(os.urandom(int(self.opts.object_size/2)))

    def create_bucket(self):
        logger.debug("Create bucket starting")
        start = time.time()

        try:
            self.bucket = self.conn.create_bucket(self.canary_bucket)
        except boto.exception.S3ResponseError as err:
            print("Canary bucket already exists")
            raise

        elapsed = float(time.time() - start)
        logger.info("Test:create_bucket, secs={}".format(elapsed))
        self.metrics.send("S3canary.BucketCreate.secs {}".format(elapsed))

        logger.debug("Create bucket complete")

    def create_object(self, count=1):
        logger.debug("Create objects starting - for {} objects".format(count))
        start = time.time()
        for n in xrange(count):
            obj_name = ''.join(random.choice(string.ascii_uppercase +
                                             string.digits) for _ in range(8))

            logger.debug("creating {}".format(obj_name))
            obj = self.bucket.new_key(obj_name)
            obj.set_contents_from_string(self.seed_contents)

            self.objects.append(obj_name)

        elapsed = float(time.time() - start)
        obj_bytes = count*self.opts.object_size
        logger.info("Test:create_object, count={}, "
                    "bytes={}, secs={}".format(count,
                                               obj_bytes,
                                               elapsed))
        now = int(time.time())
        self.metrics.send("S3canary.ObjectCreate.count {} {}".format(count,
                                                                     now))
        self.metrics.send("S3canary.ObjectCreate.bytes {} {}".format(obj_bytes,
                                                                     now))
        self.metrics.send("S3canary.ObjectCreate.secs {} {}".format(elapsed,
                                                                    now))

        logger.debug("create object(s) complete")

    def read_object(self):
        num_objects = len(self.objects)
        logger.debug("read object starting - {} object(s)".format(num_objects))
        start = time.time()

        for obj_name in self.objects:
            logger.debug("reading object {}".format(obj_name))
            key = self.bucket.get_key(obj_name)
            key.get_contents_as_string()

        elapsed = float(time.time() - start)
        bytes_read = num_objects * self.opts.object_size
        logger.info("Test:read_object(s), count={}, "
                    "bytes={}, secs={}".format(num_objects,
                                               bytes_read,
                                               elapsed,
                                               ))

        now = int(time.time())
        self.metrics.send("S3canary.ObjectRead.count {} {}".format(num_objects,
                                                                   now))
        self.metrics.send("S3canary.ObjectRead.bytes {} {}".format(bytes_read,
                                                                   now))
        self.metrics.send("S3canary.ObjectRead.secs {} {}".format(elapsed,
                                                                  now))

        logger.debug("read object(s) complete")

    def delete_object(self):
        logger.debug("deleting objects from bucket")
        start = time.time()

        num_objects = len(self.objects)

        for obj_name in list(self.objects):
            logger.debug("deleting {}".format(obj_name))
            self.bucket.delete_key(obj_name)
            self.objects.remove(obj_name)

        elapsed = float(time.time() - start)
        logger.info("Test:delete_objects, count={}, "
                    "secs={}".format(num_objects,
                                     elapsed))

        now = int(time.time())
        self.metrics.send("S3canary.ObjectDelete.count {} {}".format(num_objects,
                                                                     now))
        self.metrics.send("S3canary.ObjectDelete.secs {} {}".format(elapsed,
                                                                    now))

        logger.debug("delete object(s) complete")

    def delete_bucket(self):
        logger.debug("delete bucket starting")
        start = time.time()

        self.conn.delete_bucket(self.canary_bucket)
        self.conn.close()
        logger.debug("{} bucket deleted".format(self.canary_bucket))

        elapsed = float(time.time() - start)
        logger.info("Test:delete_bucket, secs={}".format(elapsed))
        self.metrics.send("S3canary.BucketDelete.secs {}".format(elapsed))

        logger.debug("delete bucket complete")

    def test_sequence(self):

        self.create_bucket()

        self.create_object(count=self.opts.object_count)

        self.read_object()

        self.delete_object()

        self.delete_bucket()


def get_opts():

    defaults = {}
    config = ConfigParser()

    dataset = config.read('parms.conf')
    if len(dataset) > 0:
        if config.has_section("config"):
            defaults.update(dict(config.items("config")))
        else:
            print("Config file detected, but the format is not supported. "
                  "Ensure the file has a single section [config]")
            sys.exit(12)
    else:
        # no config files detected, to seed the run time options
        pass

    parser = ArgumentParser()
    parser.add_argument("-r", "--rgw", type=str,
                        help="RGW http URL (host:port)")
    parser.add_argument("-i", "--interval", type=int,
                        default=60,
                        help="interval (secs) between cycles")
    parser.add_argument("-t", "--time-limit", type=int,
                        help="run time (mins) - default is run forever")
    parser.add_argument("-a", "--access-key", type=str,
                        help="S3 access key")
    parser.add_argument("-s", "--secret-key", type=str,
                        help="S3 secret key")
    parser.add_argument("-o", "--object-size", type=int,
                        default=65536,
                        help="object size in bytes to upload/read")
    parser.add_argument("-g", "--graphite-server", type=str,
                        default=None,
                        help="Graphite server (host:port)")
    parser.add_argument("-p", "--prefix", type=str,
                        default="ceph",
                        help="Prefix for the metrics name used in the log file"
                             " and Graphite")
    parser.add_argument("-c", "--object-count", type=int,
                        default=1,
                        help="# objects to create in the canary bucket")

    parser.set_defaults(**defaults)
    runtime_opts = parser.parse_args()

    return runtime_opts


def main(opts):

    # define the must haves
    if not all([opts.access_key, opts.secret_key, opts.rgw]):
        print("Unable to continue. S3 credentials and RGW URL is needed")
        sys.exit(12)

    logger.info("Started")
    print("\nRun time parameters are:")
    parameters = sorted(opts.__dict__)
    width = max([len(_f) for _f in parameters])
    for prm in parameters:
        print("{:<{}} : {}".format(prm,
                                   width,
                                   getattr(opts, prm)))

    start_time = time.time()        # epoc start (secs)

    if opts.time_limit:
        end_time = start_time + (opts.time_limit * 60)

    rgw = RGWTest(runtime_opts=opts)

    now = time.time()
    print("\nRunning")
    try:
        while True:

            rgw.test_sequence()

            logger.debug("waiting for next test iteration")
            time.sleep(opts.interval)
            now = time.time()
            if opts.time_limit:
                if now > end_time:
                    print("- time limit reached")
                    break

    except KeyboardInterrupt:
        print("\nCleaning up")
        rgw.clean_up()

    rgw.metrics.disconnect()
    print("Stopped")
    logger.info("Finished")

if __name__ == "__main__":

    opts = get_opts()

    logger = logging.getLogger("canary")
    logger.setLevel(logging.DEBUG)
    handler = logging.FileHandler(filename="/var/log/s3_canary.log",
                                  mode="a")

    fmt = logging.Formatter('%(asctime)s [%(levelname)-12s] - %(message)s')
    handler.setFormatter(fmt)
    logger.addHandler(handler)

    main(opts)
