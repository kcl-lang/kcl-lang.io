import crd.v1

v1.CronTab {
    metadata.name = "my-new-cron-object",
    spec: {
        cronSpec = "* * * * */5",
        image = "my-awesome-cron-image",
        replicas = 3,
    }
}
