package net.ximatai.pgshow.http

import groovy.util.logging.Slf4j
import io.vertx.core.AbstractVerticle
import io.vertx.core.Promise
import io.vertx.core.eventbus.EventBus
import io.vertx.core.http.HttpServer
import io.vertx.core.http.HttpServerOptions
import io.vertx.ext.bridge.PermittedOptions
import io.vertx.ext.web.Router
import io.vertx.ext.web.handler.StaticHandler
import io.vertx.ext.web.handler.sockjs.SockJSBridgeOptions
import io.vertx.ext.web.handler.sockjs.SockJSHandler
import net.ximatai.pgshow.http.endpoint.ApiHttpEndpoint

@Slf4j
class HttpVerticle extends AbstractVerticle {

    EventBus eventBus

    @Override
    void start(Promise<Void> startPromise) throws Exception {
        log.info(config().toString())
        def httpConfig = config().getJsonObject("http")
        int port = httpConfig.getInteger("port")


        HttpServer server = vertx.createHttpServer(new HttpServerOptions().setTcpKeepAlive(true).setIdleTimeout(30))

        Router router = Router.router(vertx)


        router.route("/api/*")
                .subRouter(ApiHttpEndpoint.create(vertx).router)

        SockJSHandler sockJSHandler = SockJSHandler.create(vertx)
        SockJSBridgeOptions options = new SockJSBridgeOptions()
                .addInboundPermitted(new PermittedOptions().setAddress("flunk"))
                .addOutboundPermitted(new PermittedOptions().setAddress("flunk"))

        router.route("/eventBus/*")
                .subRouter(sockJSHandler.bridge(options));


        router.route().handler(StaticHandler.create())

        server.requestHandler(router)
                .listen(port)
                .onComplete {
                    if (it.succeeded()) {
                        log.info("HTTP service run on port " + it.result().actualPort())
                        startPromise.complete()
                    } else {
                        log.error("HTTP service failed to start", it.cause())
                        startPromise.fail(it.cause())
                    }
                }

    }

}
