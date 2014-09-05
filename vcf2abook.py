#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import os.path
import sys


class Header:

    """ abook header """

    def __init__(self, version='0.6.0pre2'):
        self.version = version

    def __str__(self):
        return '[format]\n' \
            'program=abook\n' \
            'version={}\n' \
            .format(self.version)


class Address:

    """ abook address """

    def __init__(self, count=0):
        self.count = count
        self.name = ''
        self.nick = ''
        self.emails = []

    def __str__(self):
        return '\n[{}]\n' \
            'name={}\n' \
            'nick={}\n' \
            'email={}\n' \
            .format(self.count,
                    self.name,
                    self.nick,
                    ', '.join(self.emails))

    def isComplete(self):
        if not self.name:
            return False
        elif not self.emails:
            return False
        else:
            return True


def main(argv=sys.argv):

    """ Convert from Google vcard addresses to abook format. """

    __version__ = '0.1.0'

    parser = argparse.ArgumentParser(
        prog=os.path.basename(argv[0]),
        usage='%(prog)s [options] infile outfile',
        description='Convert Google vcard address book to abook format.',
        epilog='© 2014 Frank H Jung mailto:frankhjung@linux.com')
    parser.add_argument(
        'infile',
        nargs='?',
        type=argparse.FileType('r'),
        default=sys.stdin,
        help='Google vcard export')
    parser.add_argument(
        'outfile',
        nargs='?',
        type=argparse.FileType('w'),
        default=sys.stdout,
        help='abook addressbook')
    parser.add_argument(
        '-v',
        '--version',
        action='version',
        version=__version__)

    # process command line arguments
    args = parser.parse_args()
    infile = args.infile
    outfile = args.outfile

    # start abook
    outfile.write(str(Header()))

    # first address
    count = 0
    address = Address(count)

    # read infile until end of file
    for line in infile.readlines():
        # print completed address
        if line.startswith('END:VCARD'):
            if address.isComplete():
                outfile.write(str(address))
                count += 1
            # start a new address
            address = Address(count)
        # set name but ignore google+ info
        elif line.startswith('FN:') \
                and line.find('(Google+)') == -1 \
                and line.find('Reply+') == -1:
            address.name = line.split(':')[-1].strip()
        # append to list of emails
        elif line.startswith('EMAIL;') and address.name:
            email = line.split(':')[-1].strip()
            address.emails.append(email)
        # set nickname
        elif line.startswith('NICKNAME:') and address.name:
            address.nick = line.split(':')[-1].strip().lower()

    return 0


"""
Main program to convert from Google vcard addresses to abook format.
"""

#
# MAIN
#
if __name__ == '__main__':
    rc = main(sys.argv)
    sys.exit(rc)

#EOF
