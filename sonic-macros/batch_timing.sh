for i in {0..9}
do
    #echo $i
    ###python3 timeDiff.py batch_logs/testDirect10_769_${i}.stderr
    ###python3 timeDiff.py batch_logs/testCloud10_771_${i}.stderr
    ###python3 timeDiff.py batch_logs/testDirect10_772_${i}.stderr
    ###python3 timeDiff.py batch_logs/testCloud10_774_${i}.stderr
    ###python3 timeDiff.py batch_logs/testDirect10_775_${i}.stderr
    #above are pre warm start
    #python3 timeDiff.py batch_logs/testDirect10_777_${i}.stderr
    #python3 timeDiff.py batch_logs/testCloud10_778_${i}.stderr
    #python3 timeDiff.py batch_logs/testCloud10_780_${i}.stderr
    #python3 timeDiff.py batch_logs/testDirect10_781_${i}.stderr
    #python3 timeDiff.py batch_logs/testDirect10_782_${i}.stderr
    #python3 timeDiff.py batch_logs/testCloud10_783_${i}.stderr
    #python3 timeDiff.py batch_logs/testDirect10_785_${i}.stderr
    #python3 timeDiff.py batch_logs/testCloud10_786_${i}.stderr
    #above are NOT SONIC!
    #python3 timeDiff.py batch_logs/testCloud10_805_${i}.stderr
    python3 timeDiff.py batch_logs/testDirect10_806_${i}.stderr
    #python3 timeDiff.py batch_logs/testCloud10_811_${i}.stderr
done

for i in {0..29}
do
    python3 timeDiff.py batch_logs/testDirect10_807_${i}.stderr
done
