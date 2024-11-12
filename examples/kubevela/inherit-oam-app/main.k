import oam

schema MyApplication(oam.Application):
    metadata.annotations = {
        "some-key" = "some-value"
    } # Extend default values

    check:
        "some-key" in metadata.annotations if metadata.annotations # Extend validation rules

MyApplication {
    metadata.name = "kcl-play-svc"
    spec.components = [{
        name = metadata.name
        type = "webservice"
        properties = {
            image = "kcllang/kcl:v0.9.0"
            ports = [{port = 80, expose = True}]  
            cmd = ["kcl", "play"]
        }
    }]
}
