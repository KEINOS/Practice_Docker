#!/bin/sh

TIME_SLEEP=${TIME_SLEEP:-300}

if [ ! -f /alldone ]; then
    /bin/sh ${PATH_DIR_RESOURCE}/setup.sh
fi  

cd ${PATH_DIR_DATA}
if [ ! -d ./.git ]; then
    echo "NO git directory found at ${PATH_DIR_DATA}"
    echo 'Closing script ...'
    exit $LINENO
fi

# Start watch git
if [ -f /alldone ]; then
    echo 'Start syncing'
    while true
    do
        MSG_COMMIT="[auto commit] `date`"
        git add . > /dev/null 2>&1
        git commit -m "${MSG_COMMIT}" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "commit found at `date`. Now pushing to origin:"
            git push origin
            echo
        fi
        echo -n -e "`date` Now sleeping ... \r"
        sleep ${TIME_SLEEP}
    done
fi
exit $?
