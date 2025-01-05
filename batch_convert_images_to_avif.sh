#!/bin/bash

speed=2
valid_img_file_extensions=("png" "tif" "tiff" "jpg" "jpeg")
folder_path=""
lossless_mode=false

for i in "$@"
do
    case $i in
        -p=*|--folderpath=*)
            folder_path="${i#*=}"
            ;;
        -ext=*|--file-extension=*)
	    valid_img_file_extensions=("${i#*=}")
            ;;
        -q=*|--compression-quality=*)
	    speed="${i#*=}"
	    ;;
	-l*|--lossless*)
	    lossless_mode=true
	    ;;
    esac
done

for file in "$folder_path"*
do
    if [ -f $file ]
    then
	    ext=${file#*.}
	    if [[ $valid_img_file_extensions =~ (^|[[:space:]])"$ext"($|[[:space:]]) ]]
	    then
	        output_fn="${file%.*}.avif"
	        if  $lossless_mode 
            then
		        avifenc --lossless $file $output_fn
	        else
		        avifenc --speed $speed $file $output_fn
	        fi
	    fi	    
    fi
done
