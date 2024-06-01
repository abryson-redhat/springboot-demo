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
The CI workflow is defined [here](https://github.com/abryson-redhat/springboot-demo/.github/workflows/ci.yml).

It has 5 jobs:
- **javabuild**:    builds the java archive and executes unit tests.
- **sonarqube**:    executes sonarqube code analysis by connecting to a remote sonarqube instance.
- **imagebuild**:   uses the buildah runner image to execute a buildah image build using the Containerfile.
- **imagescan**:    executes an ACS image scan using the image-scan runner image.
- **deploytodev**:  deploys the project via an update to the `values.yaml` file for the DEV instance.


## CD
CD is implemented via ArgoCD and Helm.  The project has a Helm chart hosted in a separate manifest repository.  The last job in the CI flow updates the `values.yaml` file with the new image pull spec.  This will trigger an ArgoCD sync operation.

#### CD sequencing
![CD sequencing](https://github.com/abryson-redhat/springboot-demo/blob/main/images/CD_sequence_diagram-Helm.png)

