#!/bin/bash

function create_datasource() {
    VAR_NAME="DS_NAME_$1"
    NAME="${!VAR_NAME}"
    echo "Configuring datasource '$NAME'..."
    VAR_TYPE="DS_TYPE_$1"
    TYPE="${!VAR_TYPE}"
    VAR_DRIVERCLASSNAME="DS_DRIVERCLASSNAME_$1"
    DRIVERCLASSNAME="${!VAR_DRIVERCLASSNAME}"
    VAR_URL="DS_URL_$1"
    URL="${!VAR_URL}"
    VAR_USERNAME="DS_USERNAME_$1"
    USERNAME="${!VAR_USERNAME}"
    VAR_PASSWORD="DS_PASSWORD_$1"
    PASSWORD="${!VAR_PASSWORD}"
    VAR_MAXACTIVE="DS_MAXACTIVE_$1"
    MAXACTIVE="${!VAR_MAXACTIVE}"
    VAR_MAXWAIT="DS_MAXWAIT_$1"
    MAXWAIT="${!VAR_MAXWAIT}"
    VAR_MAXIDLE="DS_MAXIDLE_$1"
    MAXIDLE="${!VAR_MAXIDLE}"

    # Optionals
    VAR_REMOVEABANDONED="DS_REMOVEABANDONED_$1"
    REMOVEABANDONED="${!VAR_REMOVEABANDONED}"
    VAR_LOGABANDONED="DS_LOGABANDONED_$1"
    LOGABANDONED="${!VAR_LOGABANDONED}"
    VAR_DEFAULTAUTOCOMMIT="DS_DEFAULTAUTOCOMMIT_$1"
    DEFAULTAUTOCOMMIT="${!VAR_DEFAULTAUTOCOMMIT}"
    VAR_FACTORY="DS_FACTORY_$1"
    FACTORY="${!VAR_FACTORY}"
    VAR_AUTH="DS_AUTH_$1"
    AUTH="${!VAR_AUTH}"
    VAR_MINEVICTABLEIDLETIMEMILLIS="DS_MINEVICTABLEIDLETIMEMILLIS_$1"
    MINEVICTABLEIDLETIMEMILLIS="${!VAR_MINEVICTABLEIDLETIMEMILLIS}"
    VAR_POOLPREPAREDSTATEMENTS="DS_POOLPREPAREDSTATEMENTS_$1"
    POOLPREPAREDSTATEMENTS="${!VAR_POOLPREPAREDSTATEMENTS}"
    VAR_REMOVEABANDONEDTIMEOUT="DS_REMOVEABANDONEDTIMEOUT_$1"
    REMOVEABANDONEDTIMEOUT="${!VAR_REMOVEABANDONEDTIMEOUT}"
    VAR_TESTWHILEIDLE="DS_TESTWHILEIDLE_$1"
    TESTWHILEIDLE="${!VAR_TESTWHILEIDLE}"
    VAR_TIMEBETWEENEVICTIONRUNSMILLIS="DS_TIMEBETWEENEVICTIONRUNSMILLIS_$1"
    TIMEBETWEENEVICTIONRUNSMILLIS="${!VAR_TIMEBETWEENEVICTIONRUNSMILLIS}"
    VAR_VALIDATIONINTERVAL="DS_VALIDATIONINTERVAL_$1"
    VALIDATIONINTERVAL="${!VAR_VALIDATIONINTERVAL}"
    VAR_INITCONNECTIONSQLS="DS_INITCONNECTIONSQLS_$1"
    INITCONNECTIONSQLS="${!VAR_INITCONNECTIONSQLS}"
    VAR_VALIDATIONQUERY="DS_VALIDATIONQUERY_$1"
    VALIDATIONQUERY="${!VAR_VALIDATIONQUERY}"
    VAR_TESTONBORROW="DS_TESTONBORROW_$1"
    TESTONBORROW="${!VAR_TESTONBORROW}"
    VAR_TESTONRETURN="DS_TESTONRETURN_$1"
    TESTONRETURN="${!VAR_TESTONRETURN}"
    VAR_TESTPEREVICTIONRUNS="DS_TESTPEREVICTIONRUNS_$1"
    TESTPEREVICTIONRUNS="${!VAR_TESTPEREVICTIONRUNS}"

    DS="<Resource name=\"${NAME}\" type=\"${TYPE}\" driverClassName=\"${DRIVERCLASSNAME}\" url=\"${URL}\" username=\"${USERNAME}\" user=\"${USERNAME}\" password=\"${PASSWORD}\" maxActive=\"${MAXACTIVE}\" maxWait=\"${MAXWAIT}\" maxIdle=\"${MAXIDLE}\""
    if [[ $FACTORY != "" ]]; then
        DS="${DS} factory=\"${FACTORY}\""
    fi
    if [[ $AUTH != "" ]]; then
        DS="${DS} auth=\"${AUTH}\""
    fi
    if [[ $MINEVICTABLEIDLETIMEMILLIS != "" ]]; then
        DS="${DS} minEvictableIdleTimeMillis=\"${MINEVICTABLEIDLETIMEMILLIS}\""
    fi
    if [[ $POOLPREPAREDSTATEMENTS != "" ]]; then
        DS="${DS} poolPreparedStatements=\"${POOLPREPAREDSTATEMENTS}\""
    fi
    if [[ $REMOVEABANDONEDTIMEOUT != "" ]]; then
        DS="${DS} removeAbandonedTimeout=\"${REMOVEABANDONEDTIMEOUT}\""
    fi
    if [[ $TESTWHILEIDLE != "" ]]; then
        DS="${DS} testWhileIdle=\"${TESTWHILEIDLE}\""
    fi
    if [[ $TIMEBETWEENEVICTIONRUNSMILLIS != "" ]]; then
        DS="${DS} timeBetweenEvictionRunsMillis=\"${TIMEBETWEENEVICTIONRUNSMILLIS}\""
    fi
    if [[ $VALIDATIONINTERVAL != "" ]]; then
        DS="${DS} validationInterval=\"${VALIDATIONINTERVAL}\""
    fi
    if [[ $INITCONNECTIONSQLS != "" ]]; then
        DS="${DS} initConnectionSqls=\"${INITCONNECTIONSQLS}\""
    fi
    if [[ $VALIDATIONQUERY != "" ]]; then
        DS="${DS} validationQuery=\"${VALIDATIONQUERY}\""
    fi
    if [[ $TESTONBORROW != "" ]]; then
        DS="${DS} testOnBorrow=\"${TESTONBORROW}\""
    fi
    if [[ $TESTONRETURN != "" ]]; then
        DS="${DS} testOnReturn=\"${TESTONRETURN}\""
    fi
    if [[ $TESTPEREVICTIONRUNS != "" ]]; then
        DS="${DS} testPerEvictionRuns=\"${TESTPEREVICTIONRUNS}\""
    fi
    if [[ $REMOVEABANDONED != "" ]]; then
        DS="${DS} removeAbandoned=\"${REMOVEABANDONED}\""
    fi
    if [[ $LOGABANDONED != "" ]]; then
        DS="${DS} logAbandoned=\"${LOGABANDONED}\""
    fi
    if [[ $DEFAULTAUTOCOMMIT != "" ]]; then
        DS="${DS} defaultAutoCommit=\"${DEFAULTAUTOCOMMIT}\""
    fi
    DS="${DS} />"
    sed -i "/^  <\/GlobalNamingResources>/i ${DS}" $CATALINA_HOME/conf/server.xml
}

function create_realm() {
    VAR_APPNAME="REALM_APPNAME_$1"
    APPNAME="${!VAR_APPNAME}"
    echo "Configuring realm '$APPNAME'..."
    VAR_CLASSNAME="REALM_CLASSNAME_$1"
    CLASSNAME="${!VAR_CLASSNAME}"
    VAR_USERCLASSNAMES="REALM_USERCLASSNAMES_$1"
    USERCLASSNAMES="${!VAR_USERCLASSNAMES}"
    VAR_ROLECLASSNAMES="REALM_ROLECLASSNAMES_$1"
    ROLECLASSNAMES="${!VAR_ROLECLASSNAMES}"
    REALM="<Realm appName=\"${APPNAME}\" className=\"${CLASSNAME}\" userClassNames=\"${USERCLASSNAMES}\" roleClassNames=\"${ROLECLASSNAMES}\" />"
    sed -i "/^    <\/Engine>/i ${REALM}" $CATALINA_HOME/conf/server.xml
}

function create_host_valve() {
    VAR_HOST_VALVE_CLASSNAME="HOST_VALVE_CLASSNAME_$1"
    HOST_VALVE_CLASSNAME="${!VAR_HOST_VALVE_CLASSNAME}"
    echo "Configuring host valve '$HOST_VALVE_CLASSNAME'..."
    VAR_HOST_VALVE_APPNAME="HOST_VALVE_APPNAME_$1"
    HOST_VALVE_APPNAME="${!VAR_HOST_VALVE_APPNAME}"
    HOST_VALVE="<Valve className=\"${HOST_VALVE_CLASSNAME}\""
    if [[ $HOST_VALVE_APPNAME != "" ]]; then
        HOST_VALVE="${HOST_VALVE} appName=\"${HOST_VALVE_APPNAME}\""
    fi
    HOST_VALVE="${HOST_VALVE} />"
    sed -i "/^      <\/Host>/i ${HOST_VALVE}" $CATALINA_HOME/conf/server.xml
}

INDEX=0
while : ; do
    BREAK_LOOP="true"
    VAR="DS_NAME_${INDEX}"
    if [[ -z ${!VAR} ]]; then
        if [[ ${INDEX} -eq 0 ]]; then
            echo "No datasource to configure."
        fi
    else
        create_datasource ${INDEX}
        BREAK_LOOP="false"
    fi

    VAR="REALM_APPNAME_${INDEX}"
    if [[ -z ${!VAR} ]]; then
        if [[ ${INDEX} -eq 0 ]]; then
            echo "No healm to configure."
        fi
    else
        create_realm ${INDEX}
        BREAK_LOOP="false"
    fi

    VAR="HOST_VALVE_CLASSNAME_${INDEX}"
    if [[ -z ${!VAR} ]]; then
        if [[ ${INDEX} -eq 0 ]]; then
            echo "No host to configure."
        fi
    else
        create_host_valve ${INDEX}
        BREAK_LOOP="false"
    fi

    if [[ $BREAK_LOOP == "true" ]]; then
        break
    fi
    ((INDEX+=1))
done
