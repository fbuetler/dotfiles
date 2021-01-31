#!/bin/bash

set -e

temp_file=`mktemp`

echo "kube-helper.sh (c) 2019 Ben Fiedler"
echo "Special thanks to Philippe Voinov"

# set $user and $pass here
# source .env

#if [ -z $user -o -z $pass ]; then
#    echo 'set the variables `user` and `pass` in .env'
#    exit 1
#fi

user="flbuetle"
echo 'nethz: ' $user
echo -n 'password: '
read -s pass
echo

echo Visiting login site
auth_url=$(curl -Ss -D $temp_file https://kube.vis.ethz.ch/auth/login)
auth_url=$(cat $temp_file | grep -i Location: | awk '{ sub(/\r/,"",$NF); print $2; }')
echo Auth URL: $auth_url

echo Select ldap login
select_ldap=$(curl -sS $auth_url | xmllint --html --xpath '//body/div/div/div/div/a' - | grep tectonic-ldap | head -n 1 | sed -e 's|.*<a href="\(.*\)" target.*|\1|')
echo LDAP login path: $select_ldap

# fuck me, you have to see the login field first before you can actually login
_NOT_USED=$(curl -s https://kube.vis.ethz.ch$select_ldap)

echo Actually login
login=$(curl -H 'Expect:' -e https://kube.vis.ethz.ch$select_ldap -sS -D $temp_file -d "login=$user" -d "password=$pass" https://kube.vis.ethz.ch$select_ldap -o /dev/null)

echo Retrieve header
approval=$(cat $temp_file | grep -i Location: | awk '{ sub(/\r/,"",$NF); print $2; }')
echo Redirect: $approval

echo Follow redirect
oauth_callback_url=$(curl -sS -e https://kube.vis.ethz.ch$select_ldap -D $temp_file https://kube.vis.ethz.ch$approval) # | sed -e 's|<a href="\(.*\)".*|\1|; s|\&amp;|\&|g')
cat $temp_file
echo ""
cat $temp_file | grep -i Location
oauth_callback_url=$(cat $temp_file | grep -i Location: | awk '{ sub(/\r/,"",$NF); print $2; }')

echo Acquire cookie
cookie_resp=$(curl -e https://kube.vis.ethz.ch$select_ldap -sS -D $temp_file -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0' $oauth_callback_url)

cookie=$(cat $temp_file | grep tectonic-session | awk '{ print $2; }' | rev | cut -c 2- | rev)
echo Cookie: $cookie

echo Opening code entry URL
auth_url=$(curl -Ss -D $temp_file -b "$cookie" https://kube.vis.ethz.ch/api/tectonic/kubectl/code | sed -e 's|<a href="\(.*\)".*|\1|')

echo Select ldap login
select_ldap=$(curl -b "$cookie" -s $auth_url | xmllint --html --xpath '//body/div/div/div/div/a' - | grep tectonic-ldap | head -n 1 | sed -e 's|.*<a href="\(.*\)" target.*|\1|')

_NOT_USED=$(curl -s -b "$cookie" https://kube.vis.ethz.ch$select_ldap)

echo Actually login
login=$(curl -b "$cookie" -D $temp_file -sS -d "login=$user" -d "password=$pass" https://kube.vis.ethz.ch$select_ldap -o /dev/null)

echo Retrieve header
approval=$(cat $temp_file | grep -i Location: | awk '{ sub(/\r/,"",$NF); print $2; }')

echo Follow redirect
code=$(curl -b "$cookie" -sS https://kube.vis.ethz.ch$approval | xmllint --html --xpath '//body/div/div/input/@value' - | sed -e 's|.*value="\(.*\)".*|\1|')
echo Code: $code

echo Visit profile
ret=$(curl -b "$cookie" -D $temp_file -Ss https://kube.vis.ethz.ch/settings/profile)

echo Exchange code
config=$(curl -s -b "$cookie" -d "code=$code" https://kube.vis.ethz.ch/api/tectonic/kubectl/config -o /tmp/kubeconfig)
echo Got kubeconfig

echo mv /tmp/kubeconfig ~/.kube/config
mv /tmp/kubeconfig ~/.kube/legacy-config

rm $temp_file
