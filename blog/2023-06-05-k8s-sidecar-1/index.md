---
slug: 2023-06-05-k8s-sidecar-1
title: Talking about the Sidecar design pattern in K8S - Part 1
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, k8s, Sidecar]
---

## Introduction

In `K8S`, there is a design pattern called `Sidecar`, The `Sidecar` pattern deploys application components into a separate process or container to provide isolation and encapsulation. And it also allows applications to be composed of heterogeneous components and technologies.

This pattern is named `Sidecar` because it resembles a Sidecar attached to a motorcycle. The Sidecar connects to a parent application and provides support functions for the application. The Sidecar also shares the same lifecycle as the parent application, being created and retired alongside the parent. The Sidecar pattern is sometimes referred to as the sidepick pattern and is a decomposition pattern.

This series of articles will show the usage of the `Sidecar` pattern and how to use the `Sidecar` pattern by KCL.

## A Cloud-Native Minimalist Web Services

At first, we could start a web service in our kubernetes environment. Define a pod with only one `Nginx` service and start a web service on port 80 in the `pod.yaml` file below.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
  - image: nginx
    name: main-container
    ports:
      - containerPort: 80
```

`Pod` is a foundational primitive in cloud native. `Pod` wraps multiple containers into a single logical unit, and the kubernetes runtime ensures that the containers in a `Pod` run on a single machine. So all containers in a `Pod` share lifecycles, disk volumes, network, etc. The `Sidecar` pattern is about adding other containers to a `Pod` to extend and augment the capabilities of the main container.

The `Pod` is then created via the kubectl, and then the `Pod` execution status is viewed via `kubectl get po`.

```bash
$ kubectl create -f pod.yaml
$ kubectl get po
NAME READY STATUS RESTARTS AGE
web-app 1/1 Running 0 45m
```

You can see that a `Pod` named `web-app` is up and running properly, containing the `Nginx` service. To configure port forwarding for external access, the port 3999 of the host corresponds to port 80 of the master container:

```bash
$ kubectl port-forward web-app 3999:80
Forwarding from 127.0.0.1:3999 ->80
Forwarding from [::1]:3999 -> 80
```

Port forwarding is a blocking procedure, keep the command line open. Then open the test page in your browser at

![](/img/blog/2023-06-05-k8s-side-car/port-forward.png)

## Expand the page content by Sidecar

In this section, we try to add the ability to customize web pages to the `Nginx` service via Sidecar without modifying the original `Nginx` container image. Before we start, remove the previously started `Pod`:

```bash
$ kubectl delete po web-app
pod "web-app" deleted
```

Then add a second `Busybox` Sidecar container to the `Pod`, with the `pod.yaml` file as follows:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
  - image: nginx
    name: main-container
    ports:
      - containerPort: 80

    # --- Here are the new additions ---

    # andSidecar share file directories to be published via disk volumes
    volumeMounts:
    - name: var-logs
      mountPath: /usr/share/nginx/html
  
  # Sidecar Container
  - image: busybox
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo $(date -u) 'Hi I am from Sidecar container' > /var/log/index.html; sleep 5;done"]
    name: Sidecar-container
    volumeMounts: var-logs
      mountPath: /var/log

  # All containers in Pod share disk volumes
  volumes:
  - name: var-logs
    emptyDir: {}

```

The commands executed by the `Busybox` Sidecar container correspond to the following shell scripts:

```bash
while true; do
	echo $(date -u) 'Hi I am from Sidecar container' > /var/log/index.html;
	sleep 5;
done
```

The `Busybox` has only one function: it overwrites the `/var/log/index.html` file every 5 seconds, which happens to correspond to the home page file of the Nginx service.

Then restart the Pod and remap the local host port to the container port.

```bash
$ kubectl create -f pod.yaml 
pod/web-app created
$ kubectl port-forward web-app 3999:80
Forwarding from 127.0.0.1:3999 -> 80
Forwarding from [::1]:3999 -> 80
```

Upon reopening your browser you will see the following page:

![](/img/blog/2023-06-05-k8s-side-car/port-forward-1.png)

## How Sidecar mode works

`Busybox` is a `Sidecar` container that produces the home page data, while `Nginx` is the main container that consumes the home page data produced by `Busybox`; the two containers share space through the var-logs disk volume.

![](/img/blog/2023-06-05-k8s-side-car/how-sidecar-work.png)

In the example, `Nginx` is still the main container, and the `Sidecar` container is BusyBox. we can also add more `Sidecar` containers for network, monitoring, logging, etc.

![](/img/blog/2023-06-05-k8s-side-car/how-sidecar-work-1.png)

## Advantages of Sidecar

Containers have now become a popular packaging technology, where various teams can build, publish and run programs in a unified way, and even manage various resources through containers. So a container is more like a product with its own runtime, release cycle, documentation, API, etc. A good container/product is responsible for solving only one problem, and maintaining the KISS principle allows the container itself to be extremely reusable and replaceable.

It is reusability that makes the modern build process more agile and efficient. But reusable containers are generally single-function, and we often need to extend the functionality of containers, as well as the need for more collaboration between containers.

The Sidecar can be added lots of trailers without modifying the main motorcycle, and accordingly the `Sidecar` pattern can extend and enhance the existing main container functions without modifying the main container.

There is a rule in object-oriented programming that "combination is better than inheritance, use more combination and less inheritance", so `Sidecar` is also a recommended pattern to use. Because of the advantages of the Sidecar pattern, it has recently been used in a lot of cloud-native scenarios. For example, it can be used to encrypt communication between Pods through a service mesh or to act as a database proxy. Sidecar containers can be used for log forwarding (e.g., `fluentd`), Service Mesh (e.g., `Istio`, `Linkerd`), proxying (e.g., `Docker Ambassador`), health checking (to check if certain components are working properly), and other auxiliary tasks (such as copying files or downloading files).

## Summary

In this article, we briefly introduce and demonstrate the `Sidecar` pattern, while comparing the relationship between `Sidecar` pattern and the combinatorial programming pattern in the context of traditional object-oriented programming ideas. the advantages of the `Sidecar` pattern are not only in the harmless enhancement of the main container, but also in the more flexible ability to dynamically adjust the main container capability.

In later articles, we will try to simplify writing `Sidecar` configurations by modern cloud-native configuration languages such as `KCL`. Extending existing configuration based on `Sidecar` by dynamically injecting and modifying it through `KCL`.
