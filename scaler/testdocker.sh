docker rm -f testscaler

docker network create scaler-net

docker run --net scaler-net -d --rm --name testscaler -p 9180:1080 scaler:test

docker run --net scaler-net --rm -v $(pwd)/scaler/Protos:/protos fullstorydev/grpcurl -import-path /protos -proto externalscaler.proto -plaintext localhost:9180 describe

docker run --net scaler-net --rm -v $(pwd)/scaler/Protos:/protos fullstorydev/grpcurl -import-path /protos -proto externalscaler.proto -plaintext testscaler:1080 externalscaler.ExternalScaler.GetMetricSpec
docker run --net scaler-net --rm -v $(pwd)/scaler/Protos:/protos fullstorydev/grpcurl -import-path /protos -proto externalscaler.proto -plaintext -d '{"scaledObjectRef" : { "scalerMetadata" : {"latitude" : "test", "longitude" : "test"} } }' testscaler:1080 externalscaler.ExternalScaler.GetMetrics
