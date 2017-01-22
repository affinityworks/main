#!/bin/bash
i=1
while IFS='' read -r line || [[ -n "$line" ]]; do
    while IFS=',' read -ra ADDR; do
      thezip="${ADDR[0]//\"/}"
      thestate="${ADDR[3]//\"/}"
      echo "${thestate}" > "${thezip}.txt"
    done <<< "$line"
    echo "${i} zip: ${thezip} state: ${thestate}"
    ((i++))
done < "$1"