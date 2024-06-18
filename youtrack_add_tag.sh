#!/bin/bash

usage() {
  echo "Usage: $0 --issue ISSUE --tag TAG --token TOKEN"
  echo "All parameters are mandatory."
  exit 1
}

while (( "$#" )); do
  case "$1" in
    --issue)
      issue="$2"
      shift 2
      ;;
    --tag)
      tag="$2"
      shift 2
      ;;
    --token)
      token="$2"
      shift 2
      ;;
    --help)
      usage
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
if [ -z "$issue" ] || [ -z "$tag" ] || [ -z "$token" ]; then
  usage
fi

// Get Tag Id from the name
tag_id=`curl -X GET "https://youtrack.jetbrains.com/api/tags?fields=id,name&query=$tag" -H 'Accept: application/json' -H "Authorization: Bearer $token" | jq -r '.[0].id'`

curl -X POST "https://youtrack.jetbrains.com/api/issues/$issue/tags?fields=id,name" \
-H 'Accept: application/json' \
-H "Authorization: Bearer $token" \
-H 'Content-Type: application/json' \
--data-raw "{\"id\": \"$tag_id\"}"
