# springboot-demo Application


# Table of Contents
1. [Overview](#Overview)
2. [Design](#Design)
3. [Building](#Building)
4. [Deploying](#Deploying)
5. [CI](#CI)
6. [CD](#CD)


## Overview
This is a very simnple Spring Boot Rest Controller application.  It uses Maven for Java builds and has a Containerfile that constructs an image using the OpenJDK 17 builder image.

It implements a stateless `helloworld` service.

## Design
GitHub workflows are used for CI and CD to the DEV environment.  The ci.yml workflow is triggered on push events to the repository.


> **CI tree**
.github/
└── workflows
    ├── ci.yml
    └── sayhello.yml


## Building
#### With tests
```bash
  mvn clean package 
```
#### Without tests
```bash
  mvn -DskipTests=true clean package
```

### Testing
The application has a single unit test.  The execute the test locally...
```bash
  mvn test
```

## Deploying
This project uses Helm for package management.  The Helm Chart is located in [a separate manifest repository](https://github.com/abryson-redhat/argocd-demo/tree/helm/gitops/manifests/busunit1/integration/teams/appteam1/apps/springboot-demo).

To trigger a deployment, the `ci.yml` workflow executes a **deploytodev** job that updates a `values.yaml` with an updated image pull spec.

This will cause ArgoCD to update the OpenShift deployment with a sync operation.


##  CI
CI is implemented via a [GitHub Workflow](https://docs.github.com/en/actions/using-workflows).

## CD




