#!/bin/bash
############################################################################################################
# This LogAnalyzer will be used to parse log files which rolls very fast i.e after every 5-10 minutes a
# new log file would be generated. The idea behind this utility is to figure out all the modified in the last
# n minutes i.e the delta after which this utility ran again so that all the new generated log files would be
# scanned.
# For rest of the stuff creating exception file, sending exception existing utilities would be used.
############################################################################################################

############################################################################################################
#you need to update below lines according to the directories, but the preferred installation location would
#always be /opt/scripts/BashLibrary

source /opt/scripts/BashLibrary/library/log_analyze_functions.sh
source /opt/scripts/BashLibrary/library/file_functions.sh
source /opt/scripts/BashLibrary/library/mail_functions.sh
##########################################################################################################
FILE_TO_ANALYSE=$1
FILE_IDENTIFIER=$2
EXCEPTIONS_FILE="/data/log_analyzer/${FILE_IDENTIFIER}/exception_list.txt"
ADMIN_MAIL_ID=sandeep.rawat@mettl.com

exitIfFileNotExists ${FILE_TO_ANALYSE}
exitIfFileNotExists ${EXCEPTIONS_FILE}

for EXCEPTION_FILE in $( findRecentlyModifiedFiles "${FILE_TO_ANALYSE}*" 60 ); do
	echo "Processing log file ${EXCEPTION_FILE}"
	parseLogFileForExceptions ${EXCEPTION_FILE} 1 ${EXCEPTIONS_FILE}
done


