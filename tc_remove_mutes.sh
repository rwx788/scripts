#!/bin/bash 

usage() {
  echo "Usage: $0 --issues ISSUE1,ISSUE2 --token TOKEN --url 'https://buildserver.net'"
  echo "All parameters are mandatory."
  exit 1
}

while (( "$#" )); do
  case "$1" in
    --issues)
      issues="$2"
      shift 2
      ;;
    --tag)
      token="$2"
      shift 2
      ;;
    --help)
      usage
      ;;
    --url)
      url="$2"
      shift 2
      ;;
    --) # End of all options
      shift
      break
      ;;
    *) # Anything unexpected
      usage()
      exit 1
  esac
done

# If not all arguments are provided, show the usage message
if [ -z "$issues" ] || [ -z "$url" ] || [ -z "$token" ]; then
  usage
fi

IFS=',' read -r -a issues_array <<< "$issues"

## now loop through the above array
for i in "${issues_array[@]}"
do
   curl -H "Authorization: Bearer $Ttoken" \
   --header "Content-Type: application/json" \
   --request DELETE \
   --url $url/app/rest/mutes/id:$i"
done
