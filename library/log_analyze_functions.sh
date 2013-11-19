. file_functions.sh
. string_functions.sh

EFFECTIVE_FILE="effectiveLogFile.txt"
REG_EXPRESSION="[0-2][0-9][:][0-6][0-9][:][0-6][0-9][,]"


###########################################################################################################
#I will get the exception stack trailing after a particular exception till i find the REG_EXPRESSION and 
# will store the stacktrace of exception in EXCEPTION_TO_CHECK file
#
###########################################################################################################

function getExceptionStack() {
	local EXCEPTION_TO_CHECK=$1
	local EXCEPTION_LINE_NO=$2

	echo "Getting stacktrace of exception ${EXCEPTION_TO_CHECK} at line no ${EXCEPTION_LINE_NO}"
	END_LINE_IN_TEMP_FILE=$( numberOfLinesInFile $EFFECTIVE_FILE )
	EXCEPTION_LINE=$( getStringAtLineNo "${EXCEPTION_LINE_NO}" "${EFFECTIVE_FILE}" )
	echo "Now processing line ${EXCEPTION_LINE}" 

#	while ! ( echo "${EXCEPTION_LINE}" | grep -e "${REG_EXPRESSION}" >>${WASTE_OUTPUT_REDIRECT_FILE})  ; do
	while ( ! matchRegex "${EXCEPTION_LINE}" "${REG_EXPRESSION}" )  ; do
		echo "${EXCEPTION_LINE}" >> ${EXCEPTION_TO_CHECK}.txt
		EXCEPTION_LINE_NO=$((EXCEPTION_LINE_NO+1))
		EXCEPTION_LINE=$( (getStringAtLineNo "${EXCEPTION_LINE_NO}" "$EFFECTIVE_FILE" ) )
		if [ ${EXCEPTION_LINE_NO} -ge ${END_LINE_IN_TEMP_FILE} ] ; then
			break
		fi
#		echo "Now processing line ${EXCEPTION_LINE}" 
	done
	return ${EXCEPTION_LINE_NO}
}

###################################################################################################################
# I'll analyze a log file(LOG_FILE) for the provided exception(EXCEPTION_TO_CHECK) between
# line no(STARTING_LINE_NO, END_LINE_NO) & I'll place all the stacktrace of that exception in a file name by that
# exception only
#
#
###################################################################################################################
function funcLogAnalyzer() {
        local LOG_FILE=$1
        local EXCEPTION_TO_CHECK=$2
        local START_LINE_NO=$3
	local END_LINE_NO=$( ( numberOfLinesInFile ${LOG_FILE} ) )

  	initializFile "${EXCEPTION_TO_CHECK}.txt"
        initializFile "${EFFECTIVE_FILE}"
    
        DIFF=$((END_LINE_NO - START_LINE_NO))
        tail -n "$DIFF" "$LOG_FILE" >> $EFFECTIVE_FILE

        END_LINE_IN_TEMP_FILE=$( ( numberOfLinesInFile ${EFFECTIVE_FILE} ) )
        echo "File is being processed for exception ${EXCEPTION_TO_CHECK} please wait ..."
	EXCEPTION_LINE_NOS=$( getLineNoMatchingRegex "$EFFECTIVE_FILE"  $EXCEPTION_TO_CHECK )
	for LINE_NO in ${EXCEPTION_LINE_NOS}
	do
		READ_LINE_STRING=$( (getStringAtLineNo "$LINE_NO" "$EFFECTIVE_FILE" ) )
		echo "$READ_LINE_STRING"  >> $EXCEPTION_TO_CHECK.txt
		LINE_NO= getExceptionStack "$EXCEPTION_TO_CHECK" $LINE_NO
		LINE_NO=$((LINE_NO+1))
               	    if [ $LINE_NO -ge $END_LINE_IN_TEMP_FILE ] ;then
                            break
              	     fi
	done
}
