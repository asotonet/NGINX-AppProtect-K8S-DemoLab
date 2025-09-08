# Delete All
kubectl delete -f syslog.yaml
kubectl delete -f ap-apple-uds.yaml
kubectl delete -f ap-dataguard-block-policy.yaml
kubectl delete -f ap-logconf.yaml
kubectl delete -f ap-waf-policy.yaml
kubectl delete -f f5app-waf.yaml
kubectl delete -f f5app-ingress-waf.yaml
kubectl delete -f f5app-vs-waf.yaml

# Syslog POD
kubectl apply -f syslog.yaml

# Get syslog POD
SYSLOGPOD=$(kubectl get pod -n default | grep syslog | awk '{print $1}') && echo $SYSLOGPOD && sleep 10
SYSLOGIP=$(kubectl get pod -n default -o wide | grep syslog | awk '{print $6}') && echo $SYSLOGIP
sed -r -i 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$SYSLOGIP"/ f5app-ingress-waf.yaml
sed -r -i 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$SYSLOGIP"/ ap-waf-policy.yaml
grep $SYSLOGIP *

# Signatures
kubectl apply -f ap-apple-uds.yaml
# Policy de NAP como tal
kubectl apply -f ap-dataguard-block-policy.yaml
# Logging configuration NAP
kubectl apply -f ap-logconf.yaml
# NAP Policy
kubectl apply -f ap-waf-policy.yaml

# Deploy App
kubectl apply -f f5app-secret.yaml
kubectl apply -f f5app-waf.yaml
# Deploy Virtual Server Resource
kubectl apply -f f5app-vs-waf.yaml
# Deploy as Ingress Resource
#kubectl apply -f f5app-ingress-waf.yaml
