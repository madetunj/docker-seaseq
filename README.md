docker build -t version1 .

docker run --rm version1 which python

docker run --mount type=bind,source=$(pwd)/abc,target=/data,readonly version1 python /data/abc.py

