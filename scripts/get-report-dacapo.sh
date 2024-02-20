rm ../results/dacapo/report.csv
for path in $(find ../results/dacapo | grep txt)
do
    # echo $path
    python3 parse-dacapo.py $path >> ../results/dacapo/report.csv
done

