package net.ximatai.pgshow.launcher

import groovy.transform.CompileStatic
import io.vertx.core.Launcher
import io.vertx.core.VertxOptions
import org.slf4j.bridge.SLF4JBridgeHandler

@CompileStatic
class AruisLauncher extends Launcher {

    static {
        SLF4JBridgeHandler.removeHandlersForRootLogger();
        SLF4JBridgeHandler.install();
    }

    static void main(String[] args) {
        new AruisLauncher().dispatch(args)
    }

    @Override
    void beforeStartingVertx(VertxOptions options) {
        options.setWarningExceptionTime(10L * 1000 * 1000000)  //block时间超过此值，打印代码堆栈
        options.setBlockedThreadCheckInterval(2000) // 每隔x，检查下是否block
        options.setMaxEventLoopExecuteTime(2L * 1000 * 1000000) //允许eventloop block 的最长时间
        options.workerPoolSize = 20
        super.beforeStartingVertx(options)
    }
}
