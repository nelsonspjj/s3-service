#!/bin/bash

VPC_ID="vpc-018b5cef28d1e7243"
REGION="us-east-1"

echo "🔎 Liberando Elastic IPs associados à VPC..."
ALLOC_IDS=$(aws ec2 describe-addresses --region $REGION --query "Addresses[*].{AllocationId:AllocationId}" --output text)
for ALLOC_ID in $ALLOC_IDS; do
    echo "➡️  Liberando EIP: $ALLOC_ID"
    aws ec2 release-address --region $REGION --allocation-id "$ALLOC_ID" || true
done

echo "🔎 Removendo NAT Gateways associados à VPC..."
NAT_GW_IDS=$(aws ec2 describe-nat-gateways --region $REGION --filter Name=vpc-id,Values=$VPC_ID --query "NatGateways[*].NatGatewayId" --output text)
for NAT_ID in $NAT_GW_IDS; do
    echo "➡️  Excluindo NAT Gateway: $NAT_ID"
    aws ec2 delete-nat-gateway --region $REGION --nat-gateway-id "$NAT_ID"
done

echo "⏳ Aguardando exclusão dos NAT Gateways..."
sleep 30

echo "🔎 Removendo interfaces de rede da VPC..."
ENI_IDS=$(aws ec2 describe-network-interfaces --region $REGION --filters Name=vpc-id,Values=$VPC_ID --query 'NetworkInterfaces[*].NetworkInterfaceId' --output text)
for ENI_ID in $ENI_IDS; do
    echo "➡️  Deletando ENI: $ENI_ID"
    aws ec2 delete-network-interface --region $REGION --network-interface-id "$ENI_ID" || true
done

echo "✅ Limpeza finalizada. Agora execute: terraform destroy"
