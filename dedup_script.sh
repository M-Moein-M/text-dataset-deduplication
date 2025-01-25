#!/bin/bash

# Check if all arguments are provided, otherwise use default values
THRESHOLD=$1
INPUT_DIR=$2
INPUT_DOCUMENTS=$INPUT_DIR/documents/*.jsonl
OUTPUT_PATH=$INPUT_DIR/output/
PROCESSES=16

# Print usage if --help is used
if [ "$1" == "--help" ]; then
    echo "Usage: $0 [threshold] [input_documents_path] [output_path]"
    echo "Default values:"
    echo "  length threshold (i.e. 100)"
    echo "  input directory (i.e. example/)"
    exit 0
fi

echo "**** dolma tag ****"
dolma tag --documents "$INPUT_DOCUMENTS" --taggers char_length_with_paragraphs_v1 whitespace_tokenizer_with_paragraphs_v1 --processes $PROCESSES || exit 1

echo "**** dolma dedupe ****"
dolma dedupe --documents "$INPUT_DOCUMENTS" --dedupe.paragraphs.attribute_name 'bff_duplicate_paragraph_spans' --dedupe.skip_empty --bloom_filter.file deduper_bloom_filter.bin --no-bloom_filter.read_only --bloom_filter.estimated_doc_count '6_000_000' --bloom_filter.desired_false_positive_rate '0.0001' --processes $PROCESSES || exit 1

echo "**** FAU mix ****"
ATTR_NAME="drop_filter"
echo creating folder
mkdir -p $INPUT_DIR/attributes/$ATTR_NAME || exit 1
if ! python faumixer.py --dedupe-threshold $THRESHOLD --input-documents "$INPUT_DOCUMENTS"; then
  echo "-----  faumixer failed! -------"
  exit 1;
fi 

echo "**** dolma mix ****"
# Create a temporary file
TEMP_FILE=$(mktemp)

# Write the JSON configuration to the temporary file
cat > "$TEMP_FILE" << EOF
{
    "streams": [
      {
        "name": "dedup_process",
        "documents": [
          "$INPUT_DOCUMENTS"
        ],
        "output": {
          "path": "$OUTPUT_PATH",
          "discard_fields": ["attributes"],
          "max_size_in_bytes": 1000000000
        },
        "attributes": [
          "drop_filter"
        ],
        "filter": {
          "exclude": [
            "\$@.attributes[?(@.drop_filter == 1)]"
          ]
        },
      }
    ],
    "processes": $PROCESSES
}
EOF

# Execute dolma mix with the temporary config file
dolma -c "$TEMP_FILE" mix

# Clean up the temporary file
rm "$TEMP_FILE"
echo all good!
