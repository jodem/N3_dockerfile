#!/bin/bash

# look for empty dir 
if [ -z "$(ls -A "$NEXUS_DATA")" ]; then
     mv "${NEXUS_DATA}init" "$NEXUS_DATA"
fi

exec "/opt/sonatype/nexus/bin/nexus" "run"
