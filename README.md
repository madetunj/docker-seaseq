docker build -t version1 .

docker run --rm version1 which python

docker run --mount type=bind,source=$(pwd)/abc,target=/data,readonly version1 python /data/abc.py

docker run --mount type=bind,source=$(pwd)/test_toil,target=/data,readonly --mount type=bind,source=$(pwd)/results,target=/results version1 toil-cwl-runner --outdir results /data/workflow/echo_cat_wf.cwl /data/in.yml

rm -rf toilresults cwlresults runresults
mkdir -p toilresults cwlresults runresults

docker run --mount type=bind,source=$(pwd)/seaseq-dev,target=/data,readonly \
--mount type=bind,source=$(pwd)/toilresults,target=/results version1 \
toil-cwl-runner \
--disableCaching \
--logFile log.txt \
--jobStore jobstore \
--clean never \
--defaultMemory 1G \
--maxMemory 2G \
--workDir ./ \
--cleanWorkDir never \
--outdir results /data/cwl/seaseq-mapping.cwl /data/test/inputyml.yml


docker run --mount type=bind,source=$(pwd)/seaseq-dev,target=/data,readonly \
--mount type=bind,source=$(pwd)/cwlresults,target=/results version1 \
cwltool --parallel --outdir results /data/cwl/seaseq-mapping.cwl /data/test/inputyml.yml


docker run --mount type=bind,source=$(pwd)/seaseq-dev,target=/data,readonly \
--mount type=bind,source=$(pwd)/runresults,target=/results version1 \
cwl-runner --parallel --outdir results /data/cwl/seaseq-mapping.cwl /data/test/inputyml.yml

