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

kubectl apply -f ../../networks.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start DB.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./db.yaml -n $NAMESPACE

sleep 10
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start NRF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./nrf.yaml -n $NAMESPACE

sleep 10
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start UDR.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./udr.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start UDM.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./udm.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start AUSF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./ausf.yaml -n $NAMESPACE


sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start NSSF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./nssf.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start AMF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./amf.yaml -n $NAMESPACE


sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start PCF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./pcf.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start UPF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./upf3.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start SMF.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./smf3.yaml -n $NAMESPACE

sleep $BETWEEN
echo ""
echo ""
echo "-=-=-=-=-=-= TRACE -=-=-=-=-=-=-=-=-=-"
echo "Start webui.. in namespace $NAMESPACE"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-"

kubectl apply -f ./webui.yaml -n $NAMESPACE

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

