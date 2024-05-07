# AOSP Revision
export AOSP_REVISION=$(grep "name=\"aosp\"" ".repo/manifests/default.xml" -A 3 | tail -1 | awk -F '/' '{print $3}' | awk -F '"' '{print $1}')
echo "=========================================="
echo "    Prepare your self and Environment     "
echo "=========================================="
echo "Going To AfterLife: $AOSP_REVISION"
