for i in {0..9}
do
    python3 timeDiff.py batch_logs/test_DT_817_${i}.stderr
    python3 timeDiff.py batch_logs/test_DT_820_${i}.stderr
done
