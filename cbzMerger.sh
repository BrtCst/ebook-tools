#!/bin/bash

while getopts ":bd:" opt; do
  case $opt in
    b) batch_mode=true;;
    d) output_dir=$(basename "$OPTARG");;
    *) echo "Usage: $0 -b|-d <directory>"; exit 1;;
  esac
done

if [ -z "$batch_mode" ] && [ -z "$output_dir" ]; then
  echo 'Missing -b or -d' >&2
  exit 1
fi

do_it() {
  echo "dir " $output_dir
  # Chemin du dossier de sortie
  output_cbz="$output_dir.cbz"
  workdir="$output_dir"/workdir

  # Regex pour extraire le premier groupe de capture
  REGEX="^(Vol.\d*)"

  mkdir "$workdir"

  # Extrait chaque fichier cbz dans un répertoire portant son nom
  find "$output_dir" -name "*.cbz" | while IFS="" read -r file; do
    filename=$(basename "${file%%.cbz}")
    echo "filename " "$filename"
    # Extraire le nom du volume
    GROUP=$(echo "$filename" | grep -oP "$REGEX")
    echo "volume " $GROUP
    # Vérifier si le groupe de capture existe déjà
    if [[ ! -d "$workdir/$GROUP" ]]; then
      mkdir -p "$workdir/$GROUP"
    fi
    unzip "$file" -d "$workdir/$GROUP/$filename"

    # Crée un fichier zip contenant tous les répertoires extraits pour un volume
    pushd "$workdir/$GROUP"
    zip -r "$output_dir - $GROUP.cbz" .
    popd 
    mv "$workdir/$GROUP/$output_dir - $GROUP.cbz" .

  done

  # Supprime les répertoires extraits
  rm -rf "$workdir"
}

if [ "$batch_mode" = true ]; then
  for d in */; do
    output_dir="${d%%/}"
    do_it
  done
else
  do_it
fi
