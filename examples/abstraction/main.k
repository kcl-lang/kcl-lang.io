import .app

app.App {
    name = "ngnix"
    labels.app = name
    containers.ngnix = {
        image = name
        ports = [{containerPort = 80}]
    }
    service.ports = [{ port = 80 }]
}
