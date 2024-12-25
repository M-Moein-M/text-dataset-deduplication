# Text Dataset Deduplication

### Motivation of this repo:
* _\*From my point of view\*_ and as an average programmer, I had a hard time working with [dolma toolkit](https://github.com/allenai/dolma) for deduplication process (no disrespect towards the developers)
* I had to make some additional scripts to go through with the deduplication process
* The scripts are for inspiration and may not satisfy all of the use cases

### Quick Example
Take a look at the sample dataset in _example/_ folder and run the following to deduplicate the example dataset.
``` bash
python -m venv dedupenv
source dedupenv/bin/activate  # on Windows change to .\dedupenv\Scripts\activate
pip install --upgrade pip
pip3 install -r requirements.txt
./dedup_script.sh 10 'example/documents/*.jsonl' 'example/output'  # for arguments description try ./dedup_script.sh --help
```
Then take a look at _example/output_ (output folder) and you will see the final output which has been deduplicated.

### My use case:
I was trying to clean a dataset of text chunks to fine-tune an LLM.

### Dataset schema:
The dataset consists of *jsonl* files:
``` json
{"id": "id2000", "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eget.", "source: "Lorem Ipsum"}
{"id": "id2000", "text": "Aliquam at massa odio. Sed in sollicitudin tortor.", "source: "Lorem Ipsum"}
{"id": "id2000", "text": "Integer condimentum, nisl in suscipit pulvinar, dui eros mattis.", "source: "Lorem Ipsum"}
```

# TODO / UP COMING
0. Upload files and scripts
1. Add an example for demonstration
2. Add concurrency for "drop" tagging
3. Refactor a bit and make it user friendly
