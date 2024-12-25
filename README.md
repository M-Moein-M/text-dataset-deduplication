# Text Dataset Deduplication

### Motivation of this repo:
* _\*From my point of view\*_ and as an average programmer, I had a hard time working with dolma toolkit for deduplication process
* I had to make some additional scripts to go through with the deduplication process
* The scripts are for inspiration and may not satisfy all of the use cases

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
