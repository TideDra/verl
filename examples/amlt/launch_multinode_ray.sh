echo "NODE_COUNT: $NODE_COUNT"

if [ $NODE_RANK -eq 0 ]
then 
    ray start --head --port=$MASTER_PORT --disable-usage-stats

    while [ $NODE_COUNT -ne $(ray list nodes | grep -m1 'Total:' | awk '{print $2}') ]
    do
        echo "Waiting for $NODE_COUNT nodes to be ready"
        sleep 5
    done
    ray status
else
    sleep 10
    ray start --address="$MASTER_ADDR:$MASTER_PORT" --block --disable-usage-stats
fi