kubectl create secret docker-registry docker-creds --docker-username=nahuels --docker-password=Ñ@huels01 --docker-email=calderonahuel@gmail.com
files=`find . -type f -name "*.yaml"`
##### DEBUG
for file in $files
do
    kubectl apply -f $file --dry-run=client
done
if [[ `echo $?` != 0 ]]; then
    exit 1
fi


### We need to create the namespace prior the deployments. TODO: update $files array to make this file the first oone
kubectl apply -f namespace.yaml
kubectl apply -f .
