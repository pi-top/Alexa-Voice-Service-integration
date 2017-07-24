#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT="$( dirname "$DIR" )"
source "$PARENT"/config

AVS_ACCESS_TOKEN="${1:-$AVS_ACCESS_TOKEN}"

ENDPOINT="https://access-alexa-na.amazon.com/v1/avs/speechrecognizer/recognize"
METADATA_FILEPATH="$DIR/metadata.json"

if [ ! -f "$AVS_REQ_FILE" ]; then
	echo "No AVS request audio file detected - exiting"
	exit 1
fi

if [ ! -f "$METADATA_FILEPATH" ]; then
	echo "No AVS upload metadata file detected - exiting"
	exit 1
fi

if [[ "$AVS_ACCESS_TOKEN" == "" ]]; then
	echo "No AVS access token detect - exiting"
	exit 1
fi

curl -i -s \
  -H "Authorization: Bearer ${AVS_ACCESS_TOKEN}" \
  -F "metadata=<$METADATA_FILEPATH;type=application/json; charset=UTF-8" \
  -F "audio=<$AVS_REQ_FILE;type=audio/L16; rate=16000; channels=1" \
  -o "$AVS_RESP_TMP_FILE" \
  "$ENDPOINT"

curlSuccess=$?

# Clean up request audio file
rm "$AVS_REQ_FILE"

if [ $curlSuccess -eq 0 ]; then
	if [ -f "$AVS_RESP_TMP_FILE" ]; then
		cp "$AVS_RESP_TMP_FILE" "$AVS_RESP_TMP_BAK_FILE"
		if grep -q "Content-Type: audio\/mpeg" "$AVS_RESP_TMP_FILE"; then
			sed '1,/Content-Type: audio\/mpeg/d' "$AVS_RESP_TMP_FILE" | sed '$d' > "$AVS_RESP_FILE"
			rm "$AVS_RESP_TMP_FILE"
			echo "OK"
			exit 0
		elif grep -q "Content-Type: application\/json" "$AVS_RESP_TMP_FILE"; then
			contentLength="$(grep "Content-Length" "$AVS_RESP_TMP_FILE")"
			if [[ "$contentLength" == *": 0"* ]]; then
				rm "$AVS_RESP_TMP_FILE"
				echo "No Content"
				exit 0
			else
				lastLineOfResp="$(tail -n 1 "$AVS_RESP_TMP_FILE")"
				error="$(echo "$lastLineOfResp" | jq -r .error)"

				if [[ "$error" != "null" ]]; then
					echo "$lastLineOfResp" | jq -r .error.message
				else
					echo "There was an unknown error."
				fi

				rm "$AVS_RESP_TMP_FILE"
				exit 1
			fi
		else
			echo "There was an unrecognized response."
			rm "$AVS_RESP_TMP_FILE"
			exit 1
		fi

	else
		echo "There was a problem finding the output file"
		exit 1
	fi
else
	echo "There was a problem downloading the response - do you have permission to save to $(dirname "$AVS_RESP_TMP_FILE")?"
	exit 1
fi
