#! /usr/bin/env bash

NAMESPACE=${1:-default}

kubectl create namespace $NAMESPACE

# 
# It is important to deploy NFs in the following order.
#
# DB > NRF > UDR > UDM > AUSF > NSSF > AMF > PCF > UPF > SMF > N3IWF
#

export BETWEEN=3

echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start networks.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f networks.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start DB.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/db.yaml -n $NAMESPACE

sleep 10
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start NRF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/nrf.yaml -n $NAMESPACE

sleep 10
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start UDR.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/udr.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start UDM.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/udm.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start AUSF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/ausf.yaml -n $NAMESPACE


sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start NSSF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/nssf.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start AMF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/amf.yaml -n $NAMESPACE


sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start PCF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/pcf.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start UPF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/upf.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start SMF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/smf.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start webui.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./deploy/webui.yaml -n $NAMESPACE

#sleep $BETWEEN
#echo ""
#echo ""
#echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
#echo "Start vcache.. in namespace $NAMESPACE"
#echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"
#
#kubectl apply -f ./deploy/vcache.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Configure UPF with NAT.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl exec -it upf -- bash -c "iptables -t nat -A POSTROUTING -o net3 -j MASQUERADE"
kubectl exec -it upf -- bash -c "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

