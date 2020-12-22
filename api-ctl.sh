#!/usr/bin/env bash
set -e
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

command=$1
apiVersion=$2

apiUrl="https://raw.githubusercontent.com/fulfillmenttools/fulfillmenttools-api-reference/${apiVersion}/api.swagger.yaml"

printUsage() {
  printf "usage:\n"
  printf "$0 download <apiVersion: git-hash-or-branchname> \t - downloads the api yaml file with given api version\n"
  printf "$0 generate <apiVersion: git-hash-or-branchname> \t - generates typescript code for the api with the given api version\n"
  printf "$0 convertToV3 <apiVersion: git-hash-or-branchname> \t - converts / the api (v2) to open API v3 format\n"
}

downloadApi() {
  echo "download ${apiVersion}"
  wget -N -nv -P "${SCRIPTDIR}" "${apiUrl}"
}

convertToV3() {
  echo "converting the swagger v2 API with version: ${apiVersion} to Open API v3 format"
  wget -nv -P "${SCRIPTDIR}" https://converter.swagger.io/api/convert?url="${apiUrl}" -O openapiv3.yaml
}

generate() {
  # create body as raw
  get_post_data() {
  cat <<EOF
{
  "swaggerUrl": "${apiUrl}"
}
EOF
}

  echo "generate code for version ${apiVersion}"
  RESPONSE=$(curl -s \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -X POST -d "$(get_post_data)" https://generator.swagger.io/api/gen/clients/typescript-fetch
  )
  LINK=$(echo "${RESPONSE}" | jq -r '.link')
  $(wget -nv -O "stubs.zip" "${LINK}")
  unzip -o stubs.zip
  rm stubs.zip
  cd  typescript-fetch-client
  grep -n -A 64 "import \* as url" api.ts | sed -n 's/^\([0-9]\{1,\}\).*/\1d/p' | sed -f - api.ts  > api.tmp
  grep -n -A 10000  -B 4 "export const " api.tmp  | sed -n 's/^\([0-9]\{1,\}\).*/\1d/p'  | sed -f - api.tmp > api2.tmp
  tail -n +2 api2.tmp > api.ts
  rm api2.tmp
  rm api.tmp
}

main() {
  if [ $# -ne 2 ]; then
    printUsage
    exit 1
  fi
  case ${command} in
    "download") downloadApi ;;
    "generate") generate ;;
    "convertToV3") convertToV3 ;;
    *) printUsage; exit 0 ;;
  esac
}

main "$@"
