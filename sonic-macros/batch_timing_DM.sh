for i in {0..9}
do
    python3 timeDiff.py batch_logs/test_DM_816_${i}.stderr
    python3 timeDiff.py batch_logs/test_DM_819_${i}.stderr
done
