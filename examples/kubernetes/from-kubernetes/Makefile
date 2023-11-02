default: import-manifests import-crds

import-manifests:
	cat deployment.yaml
	kcl import -f deployment.yaml
	kcl deployment.k

import-crds:
	kcl mod add k8s
	kcl import -m crd -s -f crd.yaml
	cat cr.k
	kcl cr.k
