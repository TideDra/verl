eval "$(/workspace/miniconda3/bin/conda shell.bash hook)"

conda activate retriever

echo "launching retriever"
log_path=$AZUREML_CR_EXECUTION_WORKING_DIR_PATH/user_logs/retriever.log

save_path=/mnt/gongrui/data/wiki18
index_file=$save_path/e5_Flat.index
corpus_file=$save_path/wiki-18.jsonl
retriever_name=e5
retriever_path=/mnt/gongrui/checkpoints/e5-base-v2

nohup python examples/sglang_multiturn/search_r1_like/local_dense_retriever/retrieval_server.py \
  --index_path $index_file \
  --corpus_path $corpus_file \
  --topk 3 \
  --retriever_name $retriever_name \
  --retriever_model $retriever_path \
  --faiss_gpu > $log_path 2>&1 &

#save_path=/mnt/gongrui/data/wiki23_zms_multi_chunks/wiki_en_index
#index_file=$save_path/e5_Flat.index
#corpus_file=$save_path/wiki_en_chunks.json
#retriever_name=e5
#retriever_path=/mnt/gongrui/checkpoints/e5-base-v2
#
#nohup python examples/sglang_multiturn/search_r1_like/local_dense_retriever/our_server.py \
#  --index_path $index_file \
#  --corpus_path $corpus_file \
#  --topk 3 \
#  --retriever_name $retriever_name \
#  --retriever_model $retriever_path \
#  --chunk_merge_method merge \
#  --faiss_gpu > $log_path 2>&1 &

sleep 1
# wait for "Application startup complete" in the log
while ! grep -q "Application startup complete" $log_path; do
    sleep 1
done
echo "retriever loaded"