import oam

oam.Application {
    metadata.name = "kcl-play-svc"
    spec.components = [{
        name = metadata.name
        type = "webservice"
        properties = {
            image = "kcllang/kcl"
            ports = [{port = 80, expose = True}]  
            cmd = ["kcl", "play"]
        }
    }]
}
