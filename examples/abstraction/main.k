import .app

app.App {
    name = "ngnix"
    containers.ngnix = {
        image = name
        ports = [{containerPort = 80}]
    }
    service.ports = [{ port = 80 }]
}
