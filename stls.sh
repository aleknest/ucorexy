threads=6
PROJ='export.scad'
EX='openscad '$PROJ

rm -r ./produce/*
mkdir -p ./produce

list_export=("$EX -D cmd=\"list\" -o null.stl")
$list_export 2> ./produce/list.txt
cat ./produce/list.txt | grep list | cut -d'"' -f 2 | cut -d ":" -f2 > ./produce/list_parts.txt
rm ./produce/list.txt
list=( $( cat ./produce/list_parts.txt ) )
rm  ./produce/list_parts.txt

declare -a parts
for part in "${list[@]}"
do
    dir=${part%/*}
    mkdir -p ./produce/$dir

    parts+=("$EX -o ./produce/$part.stl -D cmd=\"$part\"")
done

index=0
for (( ; ; ))
do
    count=$(ps aux --no-heading | grep -v grep | grep $PROJ | wc -l)
    if [ "$count" -lt "$threads" ]
    then 
    current=${parts[$index]}
    if [ -z "$current" ]; then break; fi
    index=$((index+1))
    
    echo $current
    $current &
    fi
    sleep 1
done