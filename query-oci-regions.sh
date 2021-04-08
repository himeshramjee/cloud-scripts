#!/bin/bash

set -e

# Dependency checks
# TODO: Is oci cli installed and properly configured?

# Param checks
useDataCache=true
# $# -ne 0 && -z "$1" && 
if [[ -z "$1" && "$1" == "--no-cache" ]]; then
    # Default is to use local cache/hardcoded data
    useDataCache=false
else
    printf "\nNote: You're seeing cached data. Use '--no-cache' to make live calls.\n\n"
fi

ociRegions=()
if [ $useDataCache == false ]; then
    ociRegions=$(oci iam region list | jq -r '.data[].name')
else
    ociRegions=("eu-amsterdam-1" "ap-mumbai-1" "uk-cardiff-1" "me-dubai-1" "eu-frankfurt-1" "sa-saopaulo-1" "ap-hyderabad-1" "us-ashburn-1" "ap-seoul-1" "me-jeddah-1" "ap-osaka-1" "uk-london-1" "ap-melbourne-1" "ap-tokyo-1" "us-phoenix-1" "sa-santiago-1" "us-sanjose-1" "ap-sydney-1" "ap-chuncheon-1" "ca-montreal-1" "ca-toronto-1" "eu-zurich-1")
fi


# ${ociRegions[@]} -> Values
# ${!ociRegions[@]} -> Indices
availabilityDomainForRegionCounter=0;
totalRegions=0;
totalAvailabilityDomains=0;
ociAvailabilityDomains=()
for region in ${ociRegions[@]}; do
    # Pull AD list
    totalRegions=$(($totalRegions+1))
    printf $totalRegions". "$region"\n"
    ociAvailabilityDomains=$(oci iam availability-domain list --region=$region | jq -r '.data[].name')
    
    for availabilityDomain in ${ociAvailabilityDomains[@]}; do
        totalAvailabilityDomains=$(($totalAvailabilityDomains+1))
        availabilityDomainForRegionCounter=$(($availabilityDomainForRegionCounter+1))

        printf "\t"$availabilityDomainForRegionCounter". "$availabilityDomain"\n"
    done
done

printf "\nTotal Regions: "$totalRegions".\n"
printf "Total ADs: "$totalAvailabilityDomains".\n"
