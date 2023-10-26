#!/bin/bash

while getopts ":b:d:" opt; do
  case $opt in
    b) batch_dir=$OPTARG;;
    d) output_dir=$OPTARG;;
    *) echo "Usage: $0 -b|-d <directory>"; exit 1;;
  esac
done

if [ -z "$batch_dir" ] && [ -z "$output_dir" ]; then
  echo 'Missing -b or -d' >&2
  exit 1
fi

do_it() {
  echo "dir " $output_dir
  # Chemin du dossier de sortie
  output_cbz_prefix=$(basename "$output_dir")
  workdir="$output_dir"/workdir

  # Regex pour extraire le premier groupe de capture
  REGEX="^(Vol.\d*)"

  mkdir "$workdir"

  # Extrait chaque fichier cbz dans un répertoire portant son nom
  find "$output_dir" -name "*.cbz" | while IFS="" read -r file; do
    filename=$(basename "${file%%.cbz}")
    echo "filename " "$filename"
    # Extraire le nom du volume
    volume=$(echo "$filename" | grep -oP "$REGEX")
    if [ -n "$volume"]; then
      volume="OneShot"
    fi
    echo "volume " $volume
    # Vérifier si le groupe de capture existe déjà
    if [[ ! -d "$workdir/$volume" ]]; then
      mkdir -p "$workdir/$volume"
    fi
    unzip "$file" -d "$workdir/$volume/$filename"
  done

  find "$workdir" -mindepth 1 -maxdepth 1 -type d| while IFS="" read -r volumeDir; do
    echo "zipping "$volumeDir
    # Crée un fichier zip contenant tous les répertoires extraits pour un volume
    pushd "$volumeDir"
    currentVolume=$(basename "$volumeDir")
    zip -r "$output_cbz_prefix - $currentVolume.cbz" .
    popd 
    mv "$volumeDir/$output_cbz_prefix - $currentVolume.cbz" "$output_dir/.."
  done

  # Supprime les répertoires extraits
  rm -rf "$workdir"
}

if [ -n "$batch_dir" ]; then
  find "$batch_dir" -mindepth 1 -maxdepth 1 -type d| while IFS="" read -r output_dir; do
    echo "$output_dir"
    do_it
  done
else
  do_it
fi
