#!/bin/bash
CARDS_CDB_FILE=$1

echo "select id from texts;" | sqlite3 $1 | sed 's/$/ 0/g'
