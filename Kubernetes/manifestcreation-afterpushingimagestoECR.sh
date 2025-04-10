cd ..
mkdir manifests
cd manifests

# making a directory then making a deployment manifest below

cat << EOF > flask-deployment.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nextwork-flask-backend
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nextwork-flask-backend
  template:
    metadata:
      labels:
        app: nextwork-flask-backend
    spec:
      containers:
        - name: nextwork-flask-backend
          image: YOUR-ECR-IMAGE-URI-HERE
          ports:
            - containerPort: 8080
EOF

# You should replace YOUR-ECR-IMAGE-URL-HERE with the URI of the Docker image you pushed to Amazon ECR. This lets Kubernetes know where to pull the container image from when it deploys your application.

nano flask-deployment.yaml

# control-x to exit nano

cat << EOF > flask-service.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: nextwork-flask-backend
spec:
  selector:
    app: nextwork-flask-backend
  type: NodePort
  ports:
    - port: 8080
      targetPort: 8080
      protocol: TCP
EOF

# there's no response, just a new terminal prompt when the yaml manifest files are created

kubectl apply -f flask-deployment.yaml
kubectl apply -f flask-service.yaml

# applying the manifests BUT YOU NEED TO MAKE SURE KUBECTL IS INSTALLED

sudo curl -o /usr/local/bin/kubectl \
https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl

sudo chmod +x /usr/local/bin/kubectl
# need to give ourselves the permission to use it just like we did for Docker
