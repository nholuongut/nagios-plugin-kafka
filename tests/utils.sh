#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: nholuongut
#  Date: 2015-05-25 01:38:24 +0100 (Mon, 25 May 2015)
#
#  https://github.com/nholuongut/nagios-plugin-kafka
#
#  License: see accompanying nholuongut LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/nholuong
#

set -eu
[ -n "${DEBUG:-}" ] && set -x
srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcdir_kafka_utils="$srcdir"

#. "$srcdir/excluded.sh"
# shellcheck disable=SC1090
. "$srcdir/../bash-tools/lib/utils.sh"
# shellcheck disable=SC1090
. "$srcdir/../bash-tools/lib/docker.sh"

srcdir="$srcdir_kafka_utils"
