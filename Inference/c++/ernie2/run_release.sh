#!/bin/bash

set -xe

num_threads=1
if [ $# -ge 1 ]; then
  num_threads=$1
fi

USE_GPU=false
export CUDA_VISIBLE_DEVICES=""

DATA_FILE=/data/wojtuss/datasets/Ernie/2-inputs/1.8w.bs1
LABEL_FILE=/data/wojtuss/datasets/Ernie/2-inputs/label.xnli.dev
REPEAT=1
PROFILE=1
PRINT_OUTPUT=0

export KMP_AFFINITY=granularity=fine,compact,1,0
export KMP_BLOCKTIME=1

paddle_dir=/data/wojtuss/repos/PaddlePaddle/Paddle
build_dir=build_release

### FP32

# MODEL_DIR=/data/wojtuss/models/ernie2.0base_QATmodel_xnli_act/origin/
MODEL_DIR=/data/wojtuss/models/origin/
./${build_dir}/inference --logtostderr \
    --model_dir=${MODEL_DIR} \
    --data=${DATA_FILE} \
    --label=${LABEL_FILE} \
    --repeat=${REPEAT} \
    --use_gpu=${USE_GPU} \
    --num_threads=${num_threads} \
    --profile=${PROFILE} \
    --output_prediction=${PRINT_OUTPUT} \
    # --enable_memory_optim \
    # --short \

### INT8

# MODEL_DIR=/data/wojtuss/models/ernie_quant_int8/
# MODEL_DIR=/data/wojtuss/models/transformed_qat_int8_model/
MODEL_DIR=/data/wojtuss/models/ernie_int8_fc_reshape_transpose
./${build_dir}/inference --logtostderr \
    --model_dir=${MODEL_DIR} \
    --data=${DATA_FILE} \
    --label=${LABEL_FILE} \
    --repeat=${REPEAT} \
    --use_gpu=${USE_GPU} \
    --num_threads=${num_threads} \
    --profile=${PROFILE} \
    --output_prediction=${PRINT_OUTPUT} \
    --use_int8 \
    --squash \
    # --short \

