# Web Application Setup using MongoDb

## Phase 1

The goal of this project is to apply what we learn about the K8s Components of;
1. Deployment
2. Service
3. ConfigMap
4. Secret
5. Pods

## Project overview:
1. Deploy 2 application, MongoDb App (Back-end) & MongoDb Express(Front End).
2. Only MongoDb-express can acces the MongoDb App(Internal Service) and no outside app can make a connection.
3. Credentials (UserName & Password) should be kept and read using the K8s Secret.
4. MongoDb app references the K8s Secret for its Credentials. Mongo-express also reference K8s ConfigMap for its configurations and K8s Secret for its Credentials.
5. Mongo-express should be accesible outside the k8s Cluster.
6. Use base64 to encrypt the credentials

## Tasks:
1. Create Deployment and Service for MongoDB App.
2. Create Deployment and Service for Mongo Express which can be access be access outside the cluster.
3. Create a Secret for both Mongodb and Mongo-Express.
4. Create a ConfigMap for Mongo-Express configurations.


-> echo -n 'username' | base64
-> echo -n 'password' | base64

## Issues encountered
1. Using the latest mongodb version requires "MongoDB 5.0+ requires a CPU with AVX support". 

To resolve this, modify the mongodb image under your deployment using a lower version that supports AVX.
```
spec:
  containers:
  - name: mongodb
    image: mongo:4.4.18   <-- Use this version
```
