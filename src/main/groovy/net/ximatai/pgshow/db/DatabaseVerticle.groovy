package net.ximatai.pgshow.db

import groovy.transform.CompileStatic
import groovy.util.logging.Slf4j
import io.vertx.core.AbstractVerticle
import io.vertx.core.Promise
import io.vertx.core.eventbus.EventBus
import io.vertx.core.eventbus.Message
import io.vertx.core.json.JsonObject
import io.vertx.pgclient.PgBuilder
import io.vertx.pgclient.PgConnectOptions
import io.vertx.pgclient.PgConnection
import io.vertx.sqlclient.Pool
import io.vertx.sqlclient.PoolOptions

@Slf4j
@CompileStatic
class DatabaseVerticle extends AbstractVerticle {

    Pool pool
    EventBus eventBus
    String channelName = "flunk"

    @Override
    void start(Promise<Void> startPromise) throws Exception {
        def dbConfig = config().getJsonObject("db")
        pool = initPgPool(dbConfig)


        pool.getConnection {
            def conn = it.result() as PgConnection
            conn.notificationHandler { notification ->
                log.info("Received ${notification.payload} on channel ${notification.channel}")
                eventBus.publish(channelName, notification.payload)
            }
            conn.query("LISTEN ${channelName}".toString())
                    .execute()
                    .onComplete {
                        log.info("Subscribed to channel @ $channelName")
                    }
        }

        trySQL()

        eventBus = vertx.eventBus()

        eventBus.consumer("testDB", this::testDB)

        eventBus.consumer("flunk", {
            log.info(it.body().toString())
        })
    }

    void testDB(Message<? extends Object> msg) {
        pool.query("select 1 as num").execute()
                .onSuccess {
                    def res = it[0].getInteger("num")
                    msg.reply(res)
                }
                .onFailure {
                    msg.fail(500, it.message)
                }

    }


    Pool initPgPool(JsonObject dbConfig) {
        PgConnectOptions connectOptions = new PgConnectOptions()
                .setPort(dbConfig.getInteger("port"))
                .setHost(dbConfig.getString("host"))
                .setDatabase(dbConfig.getString("database"))
                .setUser(dbConfig.getString("user"))
                .setPassword(dbConfig.getString("password"))
                .setReconnectAttempts(5)
                .setReconnectInterval(5000)

        PoolOptions poolOptions = new PoolOptions()
                .setMaxSize(dbConfig.getInteger("poolSize"))
                .setShared(true)

        return PgBuilder
                .pool()
                .with(poolOptions)
                .connectingTo(connectOptions)
                .using(vertx)
                .build()

    }

    void trySQL() {
        pool.query("select 1")
                .execute()
                .onSuccess {
                    log.info("db connect success.")
                }
                .onFailure {
                    log.info("db connect fail.")
                    it.printStackTrace()
                }
    }
}
