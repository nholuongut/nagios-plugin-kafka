#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: nholuongut
#  Date: 2015-11-05 23:29:15 +0000 (Thu, 05 Nov 2015)
#
#  https://github.com/nholuongut/nagios-plugin-kafka
#
#  License: see accompanying nholuongut LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/nholuong
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$srcdir/..";

# shellcheck disable=SC1091
. bash-tools/lib/utils.sh

bash-tools/checks/check_all.sh

# TODO: find time to build and test newer versions of Kafka docker etc.
exit 0

section "Running Nagios Plugin Kafka ALL"

find tests -name 'test*.sh' -exec {} \;
