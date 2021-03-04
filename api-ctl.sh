#!/usr/bin/env bash
set -e
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

command=$1
apiVersion=$2

apiUrl="https://raw.githubusercontent.com/fulfillmenttools/fulfillmenttools-api-reference/${apiVersion}/api.swagger.yaml"

swaggerCodeGen="https://repo1.maven.org/maven2/io/swagger/swagger-codegen-cli/2.4.18/swagger-codegen-cli-2.4.18.jar"


printUsage() {
  printf "usage:\n"
  printf "$0 download <apiVersion: git-hash-or-branchname> \t - downloads the api yaml file with given api version\n"
  printf "$0 generate <apiVersion: git-hash-or-branchname> \t - generates typescript code for the api with the given api version\n"
  printf "$0 convertToV3 <apiVersion: git-hash-or-branchname> \t - converts / the api (v2) to open API v3 format\n"
}

downloadApi() {
  echo "download ${apiVersion}"
  wget -N -nv -P "${SCRIPTDIR}" "${apiUrl}"
  wget -N -nv -O swagger-codegen-cli.jar -P "${SCRIPTDIR}" "${swaggerCodeGen}"
}

convertToV3() {
  echo "converting the swagger v2 API with version: ${apiVersion} to Open API v3 format"
  wget -nv -P "${SCRIPTDIR}" https://converter.swagger.io/api/convert?url="${apiUrl}" -O openapiv3.yaml
}

generate() {
  echo "generate code for version ${apiVersion}"
  java -jar swagger-codegen-cli.jar generate -i api.swagger.yaml -l typescript-fetch -o ./typescript-fetch-client
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

