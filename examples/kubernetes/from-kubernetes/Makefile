default: import-manifests import-crds

import-manifests:
	cat deployment.yaml
	kcl import -f deployment.yaml
	kcl deployment.k

import-crds:
	# Convert the CRD YAML to KCL Schema
	kcl import -m crd -s -f crd.yaml
	# Init a new KCL project.
	rm -rf kcl.mod && kcl mod init
	# Add the crd models dependency
	kcl mod add ./models --rename crd
	kcl cr.k
