package net.ximatai.pgshow.http.endpoint

import groovy.transform.CompileStatic
import groovy.util.logging.Slf4j
import io.vertx.core.Vertx
import io.vertx.ext.web.RoutingContext
import io.vertx.ext.web.handler.BodyHandler
import net.ximatai.pgshow.http.HttpEndpoint

@Slf4j
@CompileStatic
class ApiHttpEndpoint extends HttpEndpoint {

    static HttpEndpoint create(Vertx vertx) {
        return new ApiHttpEndpoint(vertx)
    }

    private ApiHttpEndpoint(Vertx vertx) {
        super(vertx)
    }

    @Override
    protected void initRoutes() {
        router.route()
                .handler(this::publishLog)
                .produces("application/json")

        router.post().handler(BodyHandler.create())

        router.get("/test").handler(this::test)
        router.get("/testDB").handler(this::testDB)
    }

    static void test(RoutingContext ctx) {
        ctx.end("ok")
    }

    void testDB(RoutingContext ctx) {
        eventBus.request("testDB", null)
                .onSuccess {
                    ctx.end(it.body().toString())
                }
                .onFailure {
                    log.error("testDB", it)
                    ctx.fail(it)
                }
    }

}
