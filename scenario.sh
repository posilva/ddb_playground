#!/usr/bin/env bash
REGION=us-east-1
ENDPOINT="http://localhost:4566"
TABLE=local-dev-dev-ownership
OID1="OID_$(uuidgen)"
OID2="OID_$(uuidgen)"
OID3="OID_$(uuidgen)"


OWNER_ID=$(uuidgen)

aws --region ${REGION} --endpoint ${ENDPOINT} dynamodb put-item \
    --table-name ${TABLE} \
    --item '{"OwnershipID": {"S": "'${OID1}'"}, "OwnerID": {"S": "'${OWNER_ID}'"}, "SnapshotData": {"S": "SomeData"}}' \
    --return-values ALL_OLD \
    --return-consumed-capacity TOTAL \
    --return-item-collection-metrics SIZE --no-cli-pager


aws --region ${REGION} --endpoint ${ENDPOINT} dynamodb put-item \
    --table-name ${TABLE} \
    --item '{"OwnershipID": {"S": "'${OID2}'"}, "OwnerID": {"S": "'${OWNER_ID}'"}, "SnapshotData": {"S": "SomeData3"}}' \
    --return-values ALL_OLD \
    --return-consumed-capacity TOTAL \
    --return-item-collection-metrics SIZE --no-cli-pager


aws --region ${REGION} --endpoint ${ENDPOINT} dynamodb put-item \
    --table-name ${TABLE} \
    --item '{"OwnershipID": {"S": "'${OID3}'"}, "OwnerID": {"S": "'${OWNER_ID}'"}, "SnapshotData": {"S": "SomeData3"}}' \
    --return-values ALL_OLD \
    --return-consumed-capacity TOTAL \
    --return-item-collection-metrics SIZE --no-cli-pager


    # This should be used if we add the range_key to the gsi
    #--key-condition-expression "OwnerID = :owner_id and begins_with ( OwnershipID , :sk_val )" \
    #--expression-attribute-values '{":owner_id": {"S": "'.${OWNER_ID}.'"}, ":sk_val": {"S": "OID_"}}' \
aws --region ${REGION} --endpoint ${ENDPOINT} dynamodb query \
    --table-name ${TABLE} \
    --index-name OwnerIDIndex \
    --key-condition-expression "OwnerID = :owner_id " \
    --expression-attribute-values '{":owner_id": {"S": "'${OWNER_ID}'"}}' \
    --no-scan-index-forward \
    --return-consumed-capacity TOTAL --no-cli-pager