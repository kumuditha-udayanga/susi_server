#!/bin/bash
set -e
git config --global push.default simple # we only want to push one branch — master
git fetch --unshallow origin
# add repo on vps as a repote
git remote add production ssh://fossasia@88.198.228.198/home/fossasia/susi-server-git
# push updates
git push -f production HEAD:master
# build and start susi server
ssh fossasia@88.198.228.198 <<EOF
  cd susi-server-git
  bin/stop.sh
  git submodule update --recursive --remote
  git submodule update --init --recursive
  ./gradlew build -x test
EOF

ssh fossasia@88.198.228.198 <<EOF
  cd susi-server-git
  bin/start.sh
EOF
