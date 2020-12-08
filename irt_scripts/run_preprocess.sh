# Preprocess, download, tokenization
# must point to transformers repo currently

export PYTHONPATH=jiant/

BASE_PATH=$(pwd)
JIANT_PATH=${BASE_PATH}/jiant/jiant
WORKING_DIR=${BASE_PATH}/experiments
DATA_DIR=${WORKING_DIR}/tasks
MODELS_DIR=${WORKING_DIR}/models
CACHE_DIR=${WORKING_DIR}/cache


function prepare_all_tasks() {
   MODEL_TYPE=$1
   TASKMASTER_TASKS=(boolq cb commonsenseqa copa rte wic snli qamr cosmosqa hellaswag wsc socialiqa arc_challenge arc_easy squad_v2 arct mnli piqa mutual mutual_plus quoref mrqa_natural_questions newsqa mcscript mctaco quail winogrande abductive_nli)
   for TASK_NAME in "${TASKMASTER_TASKS[@]}"
   do
       echo "run preprocess $TASK_NAME"
       preprocess_task $MODEL_TYPE $TASK_NAME
   done
}



function preprocess_task(){
    MODEL_TYPE=$1
    TASK_NAME=$2

    if [[ $MODEL_TYPE = nyu* ]]
    then
        MODEL_NAME="${MODEL_TYPE##*/}"
    else
        MODEL_NAME=${MODEL_TYPE}
    fi
    echo "$MODEL_NAME: ${TASK_NAME}, ${DATA_DIR}"

    python ${JIANT_PATH}/proj/main/tokenize_and_cache.py \
	    --task_config_path ${DATA_DIR}/configs/${TASK_NAME}_config.json \
            --model_type ${MODEL_NAME} \
            --model_tokenizer_path ${MODELS_DIR}/${MODEL_NAME}/tokenizer \
            --phases train,val,test \
            --max_seq_length 256 \
	    --do_iter \
            --smart_truncate \
	    --output_dir ${CACHE_DIR}/${MODEL_NAME}/${TASK_NAME}
}





