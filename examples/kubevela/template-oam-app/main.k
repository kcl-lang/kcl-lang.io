import oam

schema MyTemplate:
    name: str
    image: str
    cmd?: [str]
    port: int = 80

schema MyApplication[template: MyTemplate](oam.Application):
    metadata = {name = "kcl-play-svc"}
    spec = {
        components = [{
            name = metadata.name
            type = "webservice"
            properties = {
                image = "kcllang/kcl:v0.9.0"
                ports = [{port = 80, expose = True}]
                cmd = ["kcl", "play"]
            }
        }]
    }

MyApplication({
    name = "kcl-play-svc"
    image = "kcllang/kcl:v0.9.0"
    cmd: ["kcl", "play"]
}) {}
