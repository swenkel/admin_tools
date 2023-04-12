#!/bin/bash

image_quality=90
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
	    image_quality="${i#*=}"
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
	        output_fn="${file%.*}.webp"
	        if  $lossless_mode 
            then
		        cwebp -lossless $file -o $output_fn -quiet
	        else
		        cwebp -q $image_quality $file -o $output_fn -quiet
	        fi
	    fi	    
    fi
done
