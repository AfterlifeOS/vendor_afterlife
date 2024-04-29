# AOSP Revision
export AOSP_REVISION=$(grep "default revision" ".repo/manifests/default.xml" | awk -F '/' '{print $3}' | awk -F '"' '{print $1}')
echo "=========================================="
echo "    Prepare your self and Environment     "
echo "=========================================="
echo "Going To AfterLife: $AOSP_REVISION"
