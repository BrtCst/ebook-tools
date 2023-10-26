# ebook-tools

Quality of life tools to help managing ebooks.

## cbzMerger.sh

Merge cbz files content to a single cbz. The main use case is to merge multiple chapter cbz to single volume cbz.

There are two operating modes:
- -d to process a single folder
- -b to batch process a complete directory

Given the following file tree:

```
Series
├─Serie 1
│ ├─ Vol.1 Chapter.1.cbz
│ ├─ Vol.1 Chapter.2.cbz
│ ├─ …
│ ├─ Vol.1 Chapter.X.cbz
│ ├─ Vol.2 Chapter.1.cbz
│ ├─ Vol.2 Chapter.2.cbz
│ ├─ …
│ ├─ Vol.2 Chapter.X.cbz
│ ├─ Vol.3 Chapter.1.cbz
│ ├─ Vol.3 Chapter.2.cbz
│ ├─ …
│ └─ Vol.3 Chapter.X.cbz
├─Serie 2
│ ├─ Vol.1 Chapter.1.cbz
│ ├─ Vol.1 Chapter.2.cbz
│ ├─ …
│ ├─ Vol.1 Chapter.X.cbz
│ ├─ Vol.2 Chapter.1.cbz
│ ├─ Vol.2 Chapter.2.cbz
│ ├─ …
│ ├─ Vol.2 Chapter.X.cbz
│ ├─ Vol.3 Chapter.1.cbz
│ ├─ Vol.3 Chapter.2.cbz
│ ├─ …
│ └─ Vol.3 Chapter.X.cbz
└─ Serie - One-shot
  ├─ Chapter.1.cbz
  ├─ Chapter.2.cbz
  ├─ …
  └─ Chapter.X.cbz
```

`./cbzMerger -d "Series/Serie 1"` will process all cbz files in the `Serie 1` folder and output as many cbz files as there are volumes. Original cbz files must start with `Vol.XXX`, or else they will be considered as a one-shot.

`./cbzMerger -b "Series"` will process all directories in `Series`, thus calling internally `./cbzMerger -d "Series/XXX" for each folder in `Series`.
