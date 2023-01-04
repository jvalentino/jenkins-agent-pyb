#!/bin/bash
set -x
docker compose run --rm jenkins_agent_pyb sh -c "cd workspace; ./test.sh"