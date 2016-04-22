# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

from datetime import datetime
from dateutil.parser import parse
import argparse
import logging
import socket
import time

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG,
                    format='%(message)s')
graphite_addr = ('graphite-in.eqiad.wmnet', 2003)
supported_metric_types = ('c', 'ms')
extended_props = {
    'c': ('count', 'lower', 'mean', 'rate', 'sum', 'upper'),
    'ms': ('count', 'mean', 'p50', 'p95', 'p999', 'sample_rate',
           'upper', 'lower', 'median', 'p75', 'p99', 'rate')
}

# Emulate the following:
# echo "mw.js.deprecate.mwCustomEditButtons.rate 0 $(date -d 'April 1 14:00:00 UTC 2016' +%s)" | nc -q0 graphite-in.eqiad.wmnet 2003
# But with a range of dates, and automatically filling in all the derived
# statsd properties as well

"""
    - m_name: Metric name without final property (e.g. "my.metric")
    - m_type: 'c' (counter) or 'ms' (measure), to decide which sub properties
            to replace (extended properties from statsd)
    - start: begin of the date range (unix timestamp)
    - end: end of the date range (unix timestamp)
"""
def graphite_wipe(m_name, m_type, start, end):
    assert m_type in supported_metric_types
    m_value = 0
    for ts in range(start, end, 60):
        logging.debug(datetime.fromtimestamp(ts))
        for sub in extended_props[m_type]:
            # Note: Without the \n this doesn't work!
            message = '%s.%s %d %d\n' % (m_name, sub, m_value, ts)
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect(graphite_addr)
            s.sendall(message.encode('utf-8'))
            s.close()
            logging.debug(message)

def get_time(str):
    try:
        dt = parse(str)
        return int(time.mktime(dt.timetuple()))
    except:
        raise argparse.ArgumentTypeError('Invalid date')

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('name_base', metavar='METRIC',
                        help='Metric base name (e.g. without ".rate")')
arg_parser.add_argument('--type', required=True, choices=('c', 'ms'),
                        help='counter or measure metric from statsd')
arg_parser.add_argument('--from', required=True, dest='start', type=get_time,
                        metavar='TIMESTAMP',
                        help='start timestamp in ISO or RFC822 format')
arg_parser.add_argument('--to', required=True, dest='end', type=get_time,
                        metavar='TIMESTAMP',
                        help='end timestamp in ISO or RFC822 format')
args = arg_parser.parse_args()

graphite_wipe(
    m_name=args.name_base,
    m_type=args.type,
    start=args.start,
    end=args.end
)

