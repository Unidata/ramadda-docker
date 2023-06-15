#!/bin/sh

###
# Java options
###

NORMAL="-server -Xms512m -Xmx4G"

RAMADDA_HOME="-Dramadda_home=$DATA_DIR"

FILE_ENCODING="-Dfile.encoding=utf-8"

JAVA_OPTS="$JAVA_OPTS $NORMAL $RAMADDA_HOME $FILE_ENCODING"
export JAVA_OPTS
