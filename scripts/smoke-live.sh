#!/bin/bash
# Post-launch smoke test: canonical URL matrix + 404 behaviour on the live site.
# Run after any deploy that changes routing:  bash scripts/smoke-live.sh
set -u
# canonical host is the apex; www has no DNS record
DOMAIN="vladws.com"
PAGE="mi-sam-smith"
fail=0

check() { # url  expected_status  expected_location_substring(or -)
  local url=$1 want_status=$2 want_loc=$3
  local out status loc
  out=$(curl -s -o /dev/null -w '%{http_code} %{redirect_url}' "$url")
  status=${out%% *}; loc=${out#* }
  if [ "$status" != "$want_status" ]; then
    echo "FAIL $url -> $status (wanted $want_status)"; fail=1; return
  fi
  if [ "$want_loc" != "-" ] && [[ "$loc" != *"$want_loc"* ]]; then
    echo "FAIL $url -> redirects to '$loc' (wanted *$want_loc*)"; fail=1; return
  fi
  echo "ok   $url -> $status ${loc:+-> $loc}"
}

echo "== canonical matrix (each variant must reach canonical in ONE hop) =="
check "https://$DOMAIN/$PAGE"              200 -
check "http://$DOMAIN/$PAGE"               301 "https://$DOMAIN/$PAGE"
check "https://$DOMAIN/$PAGE.html"         301 "https://$DOMAIN/$PAGE"
check "https://$DOMAIN/$PAGE/"             308 "$PAGE"
check "https://$DOMAIN/index.html"         301 "https://$DOMAIN/"
check "https://$DOMAIN/"                   200 -
check "https://$DOMAIN/colour.html"        301 "https://$DOMAIN/colour"
check "https://$DOMAIN/col-au-ra-killswitch" 200 -

echo "== legacy URLs =="
check "https://$DOMAIN/diamond-store"      301 "/the-diamond-store"
check "https://$DOMAIN/diamond-store.html" 301 "/the-diamond-store"

echo "== 404 behaviour =="
check "https://$DOMAIN/definitely-not-a-page" 404 -
check "https://$DOMAIN/mi-girl-group"         404 -

echo "== essentials =="
check "https://$DOMAIN/sitemap.xml" 200 -
check "https://$DOMAIN/robots.txt"  200 -

exit $fail
