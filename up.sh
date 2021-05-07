#!/bin/bash

# Start services without the integration tests
# The `-s` flag takes a string of services to run.
# The `-l` flag will use mounted code.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
SERVICES='l1_chain deployer data_transport_layer geth_l2_relayer_batch'
DOCKERFILE="docker-compose-v2.yml"

while (( "$#" )); do
  case "$1" in
    -l|--local)
      DOCKERFILE="docker-compose-v2.local.yml"
      shift 1
      ;;
    -s|--services)
      SERVICES="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument $1" >&2
      shift
      ;;
  esac
done

docker-compose \
    -f $DIR/$DOCKERFILE \
    -f $DIR/docker-compose-v2.env.yml \
    down -v --remove-orphans

docker-compose \
    -f $DIR/$DOCKERFILE \
    -f $DIR/docker-compose-v2.env.yml \
    up $SERVICES  
