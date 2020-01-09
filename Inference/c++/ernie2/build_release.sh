#!/bin/sh

paddle_dir=/data/wojtuss/repos/PaddlePaddle/Paddle
build_dir=build_release
build_threads=14
build_type=Release

export PYTHONPATH=${paddle_dir}/${build_dir}/python:${paddle_dir}/${build_dir}/paddle

rm -r paddle
cp ${paddle_dir}/paddle/ . -r
cp ${paddle_dir}/${build_dir}/paddle/fluid/platform/profiler* paddle/fluid/platform/

mkdir ${build_dir} -p
cd ${build_dir} && rm -r *
cmake -DUSE_GPU=OFF -DPADDLE_ROOT=${paddle_dir}/${build_dir}/fluid_install_dir -DCMAKE_BUILD_TYPE=${build_type} -DUSE_PROFILER=ON ..
make -j${build_threads}
cd -
