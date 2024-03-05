import manifests

import app

# Convert the `App` model into Kubernetes Deployment and Service Manifests
test_kubernetesRender = lambda {
    a = app.App {
        name = "app"
        containers.ngnix = {
            image = "ngnix"
            ports = [{containerPort = 80}]
        }
        service.ports = [{ port = 80 }]
    }
    resources = kubernetesRender(a)
    assert resources[0].kind == "Deployment"
    assert resources[1].kind == "Service"
    assert resources[0].spec.template.spec.containers[0]["name"] == "ngnix", "expected {}, got {}".format("", resources[0].spec.template.spec.containers[0]["name"])
}
