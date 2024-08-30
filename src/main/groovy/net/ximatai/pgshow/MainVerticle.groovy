package net.ximatai.pgshow

import groovy.util.logging.Slf4j
import io.vertx.core.AbstractVerticle
import io.vertx.core.DeploymentOptions
import net.ximatai.pgshow.db.DatabaseVerticle
import net.ximatai.pgshow.http.HttpVerticle

@Slf4j
class MainVerticle extends AbstractVerticle {
    @Override
    void start() throws Exception {
        super.start()

        DeploymentOptions deploymentOptions = new DeploymentOptions().setConfig(config())

//        deploymentOptions.setInstances(4)

        vertx.deployVerticle(HttpVerticle.class, deploymentOptions)
        vertx.deployVerticle(DatabaseVerticle.class, deploymentOptions)

    }
}
