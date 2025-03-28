# Spring Boot + HikariCP + Oracle RDS (SSL) + AWS Secrets Manager

This repository demonstrates how to configure a Spring Boot application using:
- **HikariCP** for connection pooling
- **Oracle RDS over SSL**
- **AWS Secrets Manager** to fetch the database password securely
- **Flexible Truststore Configuration** (supports both classpath and absolute path)

---

## 📌 Prerequisites
- **AWS Secrets Manager**: Store the database password in AWS Secrets Manager.
- **Oracle RDS with SSL**: Ensure RDS is configured to require SSL connections.
- **Spring Boot Application**: Running as either a JAR or a WAR.

---

## 🛠️ Project Setup

### 1️⃣ Add Dependencies (`pom.xml`)
```xml
<dependencies>
    <!-- Spring Boot Starter JDBC (Includes HikariCP) -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jdbc</artifactId>
    </dependency>

    <!-- HikariCP -->
    <dependency>
        <groupId>com.zaxxer</groupId>
        <artifactId>HikariCP</artifactId>
    </dependency>

    <!-- Oracle JDBC Driver -->
    <dependency>
        <groupId>com.oracle.database.jdbc</groupId>
        <artifactId>ojdbc8</artifactId>
        <version>19.8.0.0</version>
    </dependency>

    <!-- AWS SDK for Secrets Manager -->
    <dependency>
        <groupId>software.amazon.awssdk</groupId>
        <artifactId>secretsmanager</artifactId>
        <version>2.20.95</version>
    </dependency>

    <!-- AWS SDK Core -->
    <dependency>
        <groupId>software.amazon.awssdk</groupId>
        <artifactId>core</artifactId>
        <version>2.20.95</version>
    </dependency>
</dependencies>
```
```yaml
spring:
  datasource:
    url: jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCPS)(HOST=your-rds-endpoint)(PORT=2484))(CONNECT_DATA=(SID=yourdbsid)))
    driver-class-name: oracle.jdbc.OracleDriver
    hikari:
      maximum-pool-size: 10
      minimum-idle: 2
      idle-timeout: 30000
      connection-timeout: 20000
      max-lifetime: 1800000
      data-source-properties:
        javax.net.ssl.trustStore: "${TRUSTSTORE_PATH:classpath:ssl/rds-truststore.jks}"
        javax.net.ssl.trustStorePassword: "${TRUSTSTORE_PASSWORD:yourpassword}"
        oracle.jdbc.J2EE13Compliant: false

aws:
  secrets:
    name: "${AWS_SECRET_NAME:your-db-secret}"
    region: "${AWS_REGION:us-east-1}"
```
```java
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueResponse;

import javax.sql.DataSource;
import java.io.File;
import java.io.IOException;
import java.util.Properties;

@Configuration
public class DataSourceConfig {

    @Value("${spring.datasource.url}")
    private String jdbcUrl;

    @Value("${spring.datasource.driver-class-name}")
    private String driverClassName;

    @Value("${aws.secrets.name}")
    private String secretName;

    @Value("${aws.secrets.region}")
    private String awsRegion;

    @Value("${spring.datasource.hikari.data-source-properties.oracle.jdbc.J2EE13Compliant}")
    private boolean j2ee13Compliant;

    @Value("${spring.datasource.hikari.data-source-properties.javax.net.ssl.trustStore}")
    private String trustStorePathConfig;

    @Value("${spring.datasource.hikari.data-source-properties.javax.net.ssl.trustStorePassword}")
    private String trustStorePassword;

    @Bean
    public DataSource dataSource() throws IOException {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(jdbcUrl);
        config.setDriverClassName(driverClassName);
        config.setUsername("your-username"); // Can also be stored in AWS Secrets Manager

        // Fetch password from AWS Secrets Manager
        String dbPassword = fetchSecret(secretName, awsRegion);
        config.setPassword(dbPassword);

        // Resolve trustStore path
        String trustStorePath = resolveTrustStorePath(trustStorePathConfig);

        // Set HikariCP properties
        Properties dsProperties = new Properties();
        dsProperties.setProperty("javax.net.ssl.trustStore", trustStorePath);
        dsProperties.setProperty("javax.net.ssl.trustStorePassword", trustStorePassword);
        dsProperties.setProperty("oracle.jdbc.J2EE13Compliant", String.valueOf(j2ee13Compliant));

        config.setDataSourceProperties(dsProperties);

        return new HikariDataSource(config);
    }

    private String fetchSecret(String secretName, String region) {
        SecretsManagerClient client = SecretsManagerClient.builder()
                .region(Region.of(region))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();

        GetSecretValueRequest request = GetSecretValueRequest.builder()
                .secretId(secretName)
                .build();

        GetSecretValueResponse response = client.getSecretValue(request);
        return response.secretString(); // Assumes secretString contains only the password
    }

    private String resolveTrustStorePath(String trustStorePathConfig) throws IOException {
        if (trustStorePathConfig.startsWith("classpath:")) {
            String classpathLocation = trustStorePathConfig.replace("classpath:", "");
            return new ClassPathResource(classpathLocation).getFile().getAbsolutePath();
        } else {
            return new File(trustStorePathConfig).getAbsolutePath();
        }
    }
}
```
```bash
export TRUSTSTORE_PATH="/opt/app/config/rds-truststore.jks"
export TRUSTSTORE_PASSWORD="yourpassword"
export AWS_SECRET_NAME="your-db-secret"
export AWS_REGION="us-east-1"
java -jar myapp.jar
```
