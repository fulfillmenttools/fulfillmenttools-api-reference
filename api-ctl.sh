#!/usr/bin/env bash
set -e
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

command=$1
apiVersion=$2

apiUrl="https://raw.githubusercontent.com/fulfillmenttools/fulfillmenttools-api-reference/${apiVersion}/api.swagger.yaml"

openapigenerator="https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/7.14.0/openapi-generator-cli-7.14.0.jar"


printUsage() {
  printf "usage:\n"
  printf "$0 download <apiVersion: git-hash-or-branchname> \t - downloads the api yaml file with given api version\n"
  printf "$0 generate <apiVersion: git-hash-or-branchname> \t - generates typescript code for the api with the given api version\n"
}

downloadApi() {
  echo "download ${apiVersion}"
  wget -N -nv -P "${SCRIPTDIR}" "${apiUrl}"
}

generate() {
  echo "generate code for version ${apiVersion}"
  wget -N -nv -P "${SCRIPTDIR}" "${openapigenerator}" -O "${SCRIPTDIR}/openapi-generator.jar"
  mkdir -p typescript-fetch-client
  downloadApi
  java -jar "${SCRIPTDIR}/openapi-generator.jar" generate -g typescript-fetch -i "${SCRIPTDIR}/api.swagger.yaml" -o ./typescript-fetch-client --verbose
  cd typescript-fetch-client
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
    *) printUsage; exit 0 ;;
  esac
}

main "$@"
