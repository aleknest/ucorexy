start_time=`date +%s`

./bom.sh &
./stls.sh

end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.


