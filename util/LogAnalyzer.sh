#!/bin/bash
############################################################################################################
#you need to update below 2 lines according to the directories

source /home/sandy/personal/BashLibrary/library/log_analyze_functions.sh
source /home/sandy/personal/BashLibrary/library/file_functions.sh
source /home/sandy/personal/BashLibrary/library/mail_functions.sh
##########################################################################################################
FILE_TO_ANALYSE=$1
FILE_IDENTIFIER=$2
LINE_NUMBER_FILE="/data/log_analyzer/${FILE_IDENTIFIER}/exception_line_number.txt"
EXCEPTION_FILE="/data/log_analyzer/${FILE_IDENTIFIER}/exception_list.txt"
ADMIN_MAIL_ID=sandeep.rawat@mettl.com

#function sendMail() {
#	local EXCEPTION=$1
#	local EXCEPTION_RECIPIENT=$2
#        echo "Checking if mail needs to be sent for exception ${EXCEPTION}"
#	local TOTAL_LINE=$( numberOfLinesInFile ${EXCEPTION}.txt )
#        if [ -f ${EXCEPTION}.txt ] && [ ${TOTAL_LINE} -gt 0 ]; then

#	        echo "Sending Stacktrace for exception ${EXCEPTION}.txt"
#	        cat ${EXCEPTION}.txt
#                echo "Sending mail for exception ${EXCEPTION} to ${EXCEPTION_RECIPIENT}"
#                cat ${EXCEPTION}.txt | sendmail ${EXCEPTION_RECIPIENT}
#        fi
#}

exitIfFileNotExists ${FILE_TO_ANALYSE}
exitIfFileNotExists ${LINE_NUMBER_FILE}
exitIfFileNotExists ${EXCEPTION_FILE}

LOG_FILE_END_LINE_NO=$( numberOfLinesInFile  ${FILE_TO_ANALYSE})
START_LINE_NO=$( ( cat $LINE_NUMBER_FILE ) )

echo "processing log file ${FILE_TO_ANALYSE} from line no ${START_LINE_NO} to line no ${LOG_FILE_END_LINE_NO}"

if [ $START_LINE_NO -gt ${LOG_FILE_END_LINE_NO}  ] || [ ! ${START_LINE_NO} ] ;then
	echo "Restarting the counter of file as start line number has exceeded end line no"
        initializFile "${LINE_NUMBER_FILE}"
	START_LINE_NO=1
fi

while read EXCEPTION_LINE ; do
	EXCEPTION=$( getWordAtPosition "${EXCEPTION_LINE}" 1 '=' )
	EXCEPTION_RECIPIENT=$( getWordAtPosition "${EXCEPTION_LINE}" 2 '=' )
	funcLogAnalyzer $FILE_TO_ANALYSE ${EXCEPTION} ${START_LINE_NO}
	sendMailForFile ${EXCEPTION_RECIPIENT} "Exception stack trace for ${EXCEPTION}" ${ADMIN_MAIL_ID} ${EXCEPTION}.txt
done < ${EXCEPTION_FILE}
initializFile "$LINE_NUMBER_FILE"

echo "${LOG_FILE_END_LINE_NO}">"${LINE_NUMBER_FILE}"
#./email.sh ./email_list.db  EXCEPTIONS#

