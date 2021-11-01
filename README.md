# Bash Library
This package contains bash scripts that can be used as libraries in bash scripts

#Usage
Add the below to your Pom File this will copy the library files into the /target/bash folder

    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-dependency-plugin</artifactId>
        <executions>
          <execution>
            <id>unpack Bash Library</id>
            <goals>
              <goal>unpack</goal>
            </goals>
            <phase>process-sources</phase>
            <configuration>
              <artifactItems>
                <artifactItem>
                  <groupId>io.github.randy-blancett</groupId>
                  <artifactId>BashLibrary</artifactId>
                  <version>1.0.0</version>
                  <type>zip</type>
                  <overWrite>true</overWrite>
                  <outputDirectory>target/bash</outputDirectory>
                  <includes>lib/*</includes>
                </artifactItem>
              </artifactItems>
            </configuration>
          </execution>
        </executions>
      </plugin>
      
#Versions
## 1.0.0
### Features
Initial release
### Bugs