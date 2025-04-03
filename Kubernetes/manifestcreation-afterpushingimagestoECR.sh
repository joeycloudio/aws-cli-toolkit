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
          image: YOUR-ECR-IMAGE-URI-HERE #You should replace YOUR-ECR-IMAGE-URL-HERE with the URI of the Docker image you pushed to Amazon ECR. This lets Kubernetes know where to pull the container image from when it deploys your application.
          ports:
            - containerPort: 8080
EOF

nano flask-deployment.yaml

# control-x to exit nano
