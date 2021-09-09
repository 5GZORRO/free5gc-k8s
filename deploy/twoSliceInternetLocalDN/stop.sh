#! /usr/bin/env bash

NAMESPACE=${1:-default}

export BETWEEN=3

echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Stop NFs.."
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl delete -f . -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Stop vcache.."
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"
kubectl delete -f ../vcache-edge -n $NAMESPACE


sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Stop networks.."
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl delete -f ../../networks.yaml -n $NAMESPACE
