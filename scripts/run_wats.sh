set -e

cd `dirname $0`

export GOPATH=$PWD/..
export GOBIN=$GOPATH/bin

go get github.com/onsi/ginkgo/ginkgo
# The following line will fail with the || echo, since tests don't
# have a binary and go get will try to build one
go get -t ../tests/... 2>/dev/null || echo "Installed dependencies"

tempfile=`mktemp -t wats`
trap "rm -f $tempfile" EXIT
cat > $tempfile <<HERE
{
  "api": "$API",
  "admin_user": "$ADMIN_USER",
  "admin_password": "$ADMIN_PASSWORD",
  "apps_domain": "$APPS_DOMAIN",
  "secure_address": "$SECURE_ADDRESS",
  "skip_ssl_validation": true
}
HERE
CONFIG=$tempfile ginkgo -r -failFast -slowSpecThreshold=120 $@ ../tests