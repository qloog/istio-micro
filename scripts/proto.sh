#!/bin/bash


proto() {
    dirname=./srv/$1/proto
    swagger_dir=./deployments/config/swagger
    if [ ! -d $swagger_dir ];then
        mkdir -p $swagger_dir
    fi
    if [ -d $dirname ];then
		for f in $dirname/*.proto; do \
		    if [ -f $f ];then \
		        protoc -I. \
                -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
                -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway \
                --grpc-gateway_out=. \
                --swagger_out=$swagger_dir \
                --swagger_out=. \
                --go_out=plugins=grpc:. $f; \
                echo compiled protoc: $f; \
            fi \
		done \
	fi
}

proto_inject() {
    echo "开始注入"
    dirname=./srv/$1/proto
    if [ -d $dirname ];then
		for f in $dirname/*.pb.go; do \
		    if [ -f $f ];then \
                protoc-go-inject-tag -input=./$f; \
                echo "完成注入" protoc-go-inject-tag: $f; \
            fi \
		done \
	fi
}

proto user
proto_inject user
