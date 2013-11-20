
source /home/sandy/personal/BashLibrary/library/file_functions.sh

function sendMail() {
	local RECIPIENT=$1
	local SUBJECT=$2
	local FROM=$3
	local BODY=$4

	createEmptyFile tmp.mail
	appendLine tmp.mail "To: ${RECIPIENT}"
	appendLine tmp.mail "From: ${FROM}"
	appendLine tmp.mail "Subject: ${SUBJECT}"

	appendLine tmp.mail ""
	appendLine tmp.mail "${BODY}"

	ssmtp ${RECIPIENT} < tmp.mail
}


function sendMailForFile() {
	local RECIPIENT=$1
	local SUBJECT=$2
	local FROM=$3
	local BODY_FILE=$4

	createEmptyFile tmp.mail
	appendLine tmp.mail "To: ${RECIPIENT}"
	appendLine tmp.mail "From: ${FROM}"
	appendLine tmp.mail "Subject: ${SUBJECT}"
	appendLine tmp.mail ""

	cat ${BODY_FILE} >> tmp.mail

	ssmtp ${RECIPIENT} < tmp.mail

}

