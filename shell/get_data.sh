mkdir -p data/Vegetation
mkdir -p data/HUC4
mkdir -p data/RPU
mkdir -p data/HorizonAngle
mkdir -p data/Elevation
mkdir -p data/HLR

aws s3 sync s3://dmap-epa-prod-anotedata/RShade/Vegetation ./data/Vegetation
aws s3 sync s3://dmap-epa-prod-anotedata/RShade/RPU ./data/RPU
aws s3 sync s3://dmap-epa-prod-anotedata/RShade/HUC4 ./data/HUC4
aws s3 sync s3://dmap-epa-prod-anotedata/RShade/HLR ./data/HLR