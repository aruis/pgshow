package net.ximatai.pgshow.http

import io.vertx.core.MultiMap
import io.vertx.core.Vertx
import io.vertx.core.eventbus.EventBus
import io.vertx.core.http.HttpServerRequest
import io.vertx.core.http.HttpVersion
import io.vertx.core.json.JsonObject
import io.vertx.ext.web.Router
import io.vertx.ext.web.RoutingContext

abstract class HttpEndpoint {

    Router router
    Vertx vertx
    EventBus eventBus

    protected HttpEndpoint(Vertx vertx) {
        this.vertx = vertx
        this.router = Router.router(vertx)
        this.eventBus = vertx.eventBus()
        initRoutes()
    }

    abstract protected void initRoutes()

    protected void publishLog(RoutingContext ctx) {
        HttpServerRequest request = ctx.request()
        MultiMap headers = request.headers()
        String method = request.method().name()
        String uri = request.uri();
        HttpVersion version = request.version()
        String host = request.remoteAddress().host()

        String versionFormatted = "-";
        switch (version) {
            case HttpVersion.HTTP_1_0:
                versionFormatted = "HTTP/1.0";
                break;
            case HttpVersion.HTTP_1_1:
                versionFormatted = "HTTP/1.1";
                break;
            case HttpVersion.HTTP_2:
                versionFormatted = "HTTP/2.0";
        }

        String referrer = headers.contains("referrer") ? headers.get("referrer") : headers.get("referer");
        String userAgent = request.headers().get("user-agent");
        referrer = referrer == null ? "-" : referrer;
        userAgent = userAgent == null ? "-" : userAgent;

        def map = [
                method     : method,
                uri        : uri,
                host       : host,
                httpVersion: versionFormatted,
                referrer   : referrer,
                userAgent  : userAgent
        ]

        eventBus.send("http.log", new JsonObject(map))

        ctx.next()
    }
}
