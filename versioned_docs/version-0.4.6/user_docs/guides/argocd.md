---
title: "ArgoCD"
sidebar_position: 12
---

## Prerequisite

Install ArgoCD:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Config ArgoCD Plugin with KCL

ArgoCD has already some common built-in plugins, including helm, jsonnet, and kustomize. For KCL, as a brand-new configuration language, if you want to integrate ArgoCD to complete drift detection, you need to follow its plugin mechanism and configure KCL as a third-party plugin. The specific operations are as follows:

1. Write the patch YAML configuration file and update the ArgoCD configuration:

```bash
cat <<EOF > patch-argocd-cm.yaml
data:
  configManagementPlugins: |
    - name: kusion
      generate:
        command: ["sh", "-c"]
        args: ["kcl -Y kcl.yaml ci-test/settings.yaml -o ci-test/stdout.golden.yaml"]
      lockRepo: true
EOF
kubectl -n argocd patch cm/argocd-cm -p "$(cat patch-argocd-cm.yaml)"
```

## Update ArgoCD Deployment

After completing the first step, ArgoCD will recognize the KCL plugin, but the KCL plugin has not been loaded into the ArgoCD image. To implement configuration drift detection, we have to tune the Deployment of argocd-repo-server.

1. Download [patch](https://github.com/KusionStack/examples/blob/main/kusion/argo-cd/patch-argocd-repo-server.yaml) file

```bash
wget -q https://raw.githubusercontent.com/KusionStack/examples/main/kusion/argo-cd/patch-argocd-repo-server.yaml
```

2. Update configuration

```bash
kubectl -n argocd patch deploy/argocd-repo-server -p "$(cat patch-argocd-repo-server.yaml)"
```

3. Update complete

```bash
kubectl get pod -n argocd -l app.kubernetes.io/name=argocd-repo-server
```

## Create KCL Project

At this point, the preparation work has been completed, and now the verification process is started. Here we use example projects from the open-source [Konfig](https://github.com/KusionStack/konfig) library.

1. Enable local port forwarding

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

2. Login to ArgoCD

```bash
argocd login localhost:8080
```

3. Create ArgoCD Application

```bash
argocd app create guestbook-test \
--repo https://github.com/KusionStack/konfig.git \
--path appops/guestbook/prod  \
--dest-namespace default \
--dest-server https://kubernetes.default.svc \
--config-management-plugin kusion
```

:::info

If you are using a private repository, you need to configure the private repository access with private key credentials before executing the create command.

Please refer [Private Repositories](https://argo-cd.readthedocs.io/en/stable/user-guide/private-repositories/#ssh-private-key-credential) for more details.
:::

After successfully creating, you can see the following output:

```
application 'guestbook-test' created
```

Through the ArgoCD UI, you can see that the created applications have not been synchronized yet. 
Here, you can manually synchronize or set automatic synchronization.

![](/img/docs/user_docs/guides/argocd/out-of-sync.jpg)

4. Set synchronization policy (only `unsynced` resources):

```bash
argocd app set guestbook-test --sync-option ApplyOutOfSyncOnly=true
```

:::info

For more information on synchronization strategies, see [Sync Options](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/)
:::

Sync succeeded:

![](/img/docs/user_docs/guides/argocd/synced.jpg)

## Configure Drift Detection

At this point, the ArgoCD monitoring KCL project has been completed, implement configuration drift detection and achieve result consistency.
Let's modify the mirror version of `guestbook-test` to implement configuration changes.

1. Update image

```diff
 appConfiguration: frontend.Server {
-    image = "gcr.io/google-samples/gb-frontend:v4"
+    image = "gcr.io/google-samples/gb-frontend:v5"
     schedulingStrategy.resource = res_tpl.tiny
 }
```

2. Compile Again

```bash
kusion compile -w appops/guestbook/prod
```

3. Git commit and push

```bash
git add .
git commit -m "manual drifted config for appops/guestbook/prod"
git push origin main
```

4. Drift configuration auto-convergence

![](/img/docs/user_docs/guides/argocd/reconcile-drifted-config.jpg)
