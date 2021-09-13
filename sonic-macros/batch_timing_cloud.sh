for i in {0..9}
do
    python3 timeDiff.py batch_logs/testCloud10_805_${i}.stderr
    python3 timeDiff.py batch_logs/testCloud10_811_${i}.stderr
    python3 timeDiff.py batch_logs/testCloud10_813_${i}.stderr
    python3 timeDiff.py batch_logs/testSyncro_837_${i}.stderr
    python3 timeDiff.py batch_logs/testCloud10_838_${i}.stderr
done
