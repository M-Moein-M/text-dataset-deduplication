# related to a project at FAU (fau.de)
import json
from pathlib import Path
import argparse


ATTR_NAME="drop_filter"

def get_attr(path, dedupe_threshold):
    print(40*"#", dedupe_threshold, path)
    path = Path(path)
    top_dir = path.parent.parent
    bff_file = f"{top_dir}/attributes/bff_duplicate_paragraph_spans/{path.name}"
    len_file = f"{top_dir}/attributes/char_length_with_paragraphs_v1/{path.name}"
    output_file = f"{top_dir}/attributes/{ATTR_NAME}/{path.name}"
    with open(bff_file, 'r', encoding='utf-8') as bffjson, \
        open(len_file, 'r', encoding='utf-8') as lenjson, \
        open(output_file, 'w', encoding='utf-8') as output:
        counter = 0
        for bdoc, ldoc in zip(bffjson, lenjson):
            b = json.loads(bdoc)
            l = json.loads(ldoc)
            assert b["id"] == l["id"]
            bff_spans = b["attributes"]["bff_duplicate_paragraph_spans"]
            length_spans = l["attributes"]["char_length_with_paragraphs_v1__char_length_with_paragraphs_v1__document"]
            dup_chars = 0
            if bff_spans:
                for s in bff_spans:
                    start, end = s[:2]
                    dup_chars += end-start
            length = 0
            if length_spans:
                for l in length_spans:
                    start, end = l[:2]
                    length += end - start
            
            ratio = dup_chars/length
            print("######", b["id"], ratio, dup_chars, length)
            if ratio >= dedupe_threshold:
                drop = 1
            else:
                drop = 0
            print(json.dumps({"id": b["id"], "attributes": {ATTR_NAME: drop}}), file=output)

def mix(input_documents, dedupe_threshold):
    parent, pattern = '/'.join(input_documents.split("/")[:-1]), input_documents.split("/")[-1]
    for path in list(Path(parent).rglob(pattern)):
        get_attr(path, dedupe_threshold)
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="mixer for setting up attribute files for dropping deduplication")
    parser.add_argument(
        "--input-documents", type=str, required=True,
        help="wild-card pattern. i.e. example/documents/*.jsonl"
    )
    parser.add_argument(
        "--dedupe-threshold", type=float, required=True,
        help="drops a document if it has a 'duplicated region/length' ratio more than threshold"
    )
    args = parser.parse_args()
    mix(args.input_documents, args.dedupe_threshold)
