package util;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.io.File;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final String PROJECT_ROOT_PARAM = "PROJECT_ROOT";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();

        try {
            // 1️⃣ Read PROJECT_ROOT from web.xml
            String projectRoot = ctx.getInitParameter(PROJECT_ROOT_PARAM);

            if (projectRoot == null || projectRoot.trim().isEmpty()) {
                throw new IllegalStateException(
                        "PROJECT_ROOT not defined in web.xml"
                );
            }

            projectRoot = projectRoot.trim();

            // 2️⃣ FORCE data path inside project
            // <PROJECT_ROOT>/src/main/webapp/WEB-INF/data
            String basePath = projectRoot
                    + File.separator + "event_db"
                    + File.separator + "data";

            // 3️⃣ Initialize file system
            FileUtil.init(basePath);

            // 4️⃣ Store path in context (optional, useful)
            ctx.setAttribute("DATA_BASE_PATH", basePath);

            System.out.println("==========================================");
            System.out.println("[AppContextListener] DATA DIRECTORY READY");
            System.out.println("[AppContextListener] Path : " + basePath);
            System.out.println("==========================================");

        } catch (Exception e) {
            System.err.println("[AppContextListener] FAILED TO INITIALIZE DATA DIRECTORY");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Application stopped.");
    }
}
