-- Auto-generated config property inserts for springboot-demoapp-jenkins
-- Generated from actual application.properties
-- Adjust values per environment before running

-- Create table if not exists
CREATE TABLE IF NOT EXISTS PROPERTIES (
    APPLICATION VARCHAR(255) NOT NULL,
    PROFILE     VARCHAR(255) NOT NULL,
    LABEL       VARCHAR(255) NOT NULL,
    PROP_KEY    VARCHAR(255) NOT NULL,
    VALUE       VARCHAR(4000),
    SITE        VARCHAR(255),
    PRIMARY KEY (APPLICATION, PROFILE, LABEL, PROP_KEY)
);


-- =============================================================
-- Profile: dev
-- =============================================================
INSERT INTO PROPERTIES (APPLICATION, PROFILE, LABEL, PROP_KEY, VALUE, SITE) VALUES ('springboot-demoapp-jenkins', 'dev', 'latest', 'spring.application.name', 'springboot-demoapp-jenkins', NULL);
INSERT INTO PROPERTIES (APPLICATION, PROFILE, LABEL, PROP_KEY, VALUE, SITE) VALUES ('springboot-demoapp-jenkins', 'dev', 'latest', 'server.port', '8181', NULL);

-- =============================================================
-- Profile: sit
-- =============================================================
INSERT INTO PROPERTIES (APPLICATION, PROFILE, LABEL, PROP_KEY, VALUE, SITE) VALUES ('springboot-demoapp-jenkins', 'sit', 'latest', 'spring.application.name', 'springboot-demoapp-jenkins', NULL);
INSERT INTO PROPERTIES (APPLICATION, PROFILE, LABEL, PROP_KEY, VALUE, SITE) VALUES ('springboot-demoapp-jenkins', 'sit', 'latest', 'server.port', '8181', NULL);

-- =============================================================
-- Profile: uat
-- =============================================================
INSERT INTO PROPERTIES (APPLICATION, PROFILE, LABEL, PROP_KEY, VALUE, SITE) VALUES ('springboot-demoapp-jenkins', 'uat', 'latest', 'spring.application.name', 'springboot-demoapp-jenkins', NULL);
INSERT INTO PROPERTIES (APPLICATION, PROFILE, LABEL, PROP_KEY, VALUE, SITE) VALUES ('springboot-demoapp-jenkins', 'uat', 'latest', 'server.port', '8181', NULL);

-- =============================================================
-- Profile: prod
-- =============================================================
INSERT INTO PROPERTIES (APPLICATION, PROFILE, LABEL, PROP_KEY, VALUE, SITE) VALUES ('springboot-demoapp-jenkins', 'prod', 'latest', 'spring.application.name', 'springboot-demoapp-jenkins', NULL);
INSERT INTO PROPERTIES (APPLICATION, PROFILE, LABEL, PROP_KEY, VALUE, SITE) VALUES ('springboot-demoapp-jenkins', 'prod', 'latest', 'server.port', '8181', NULL);

