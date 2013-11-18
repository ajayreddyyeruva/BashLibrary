function createEmptyFile() {
	>| "$1"	
}

# To search *log* FILE_REGEX=.*\(log\)*
# To search *.log FILE_REGEX=.*.log 
function findFilesOfDirectoryRecursively() {
	local DIRECTORY_PATH_TO_SEARCH="$1"
	local FILE_REGEX="$2"
	local OUTPUT_FILE_NAME="$3"
	find "$DIRECTORY_PATH_TO_SEARCH" -regex "$FILE_REGEX" -type f -follow > "$OUTPUT_FILE_NAME"
}

#Returns top N lines after sorting the content of file in Descending order
function findNSortedLines() {
	local INPUT_FILE="$1"
	local OUTPUT_FILE="$2"
	local NUMBER_OF_FILES="$3"
	cat "$INPUT_FILE" | sort -gr | head -"$NUMBER_OF_FILES" > "$OUTPUT_FILE" 
}

#Returns 2 dimensional data first column is the size of file and second column is name of file
function getSizeOfFiles() {
	local INPUT_FILE="$1"
	local OUTPUT_FILE="$2"
	createEmptyFile ${OUTPUT_FILE}	
	echo "Calculating of size of files in ${INPUT_FILE} to ${OUTPUT_FILE}"
	while read fileName
	do
		du -sb "$fileName" >> "$OUTPUT_FILE"
	done < "$INPUT_FILE"
}

#Returns 2 dimension data first column is the size of file and second column is name of file, with the filter of minimum size
function findFilesAboveThresholdSize() {
	local INPUT_FILE="$1"
        local OUTPUT_FILE="$2"
        local THRESHOLD_FILE_SIZE="$3"

	getSizeOfFiles ${INPUT_FILE} ${INPUT_FILE}.tmp
	createEmptyFile ${OUTPUT_FILE}
	while read fileNameWithSize
	do
		echo "Processing file ${fileNameWithSize}"
		sizeOfFile=`echo "$fileNameWithSize" | awk '{print $1}'`
		if [ "${sizeOfFile}" -ge "${THRESHOLD_FILE_SIZE}" ]
		then
			echo "$fileNameWithSize" >> "$OUTPUT_FILE"
		#else
		#	exit 0
		fi
	done < "${INPUT_FILE}.tmp"
}

function getLineNoOfMatchingRegex() {
	PATTERN="$1"
	FILE_NAME="$2"

	echo `grep -i -n -w "$PATTERN" "$FILE_NAME" | awk '{print $1}' | cut -d':' -f1`
}

function deleteLineFromFile() {
	LINE_NO="$1"
	FILE_NAME="$2"

	sed -i ''$LINE_NO'd' "$FILE_NAME"
}


	
