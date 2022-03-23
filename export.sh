start_time=`date +%s`

rm -r ./produce/*
mkdir -p ./produce

./bom.sh &
./stls.sh 0

./stls.sh 1

end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s


