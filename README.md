# Bash Library
This package contains bash scripts that can be used as libraries in bash scripts

## Deployment
    mvn release:clean release:prepare
    mvn release:perform  
    
## Usage
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
      
## Versions
### 1.3.0
### 10FEB2023
#### Features
 * Added the ability to ask a user for input with out showing what has been typed
   * shellUtils: askUserSecret
 * Added the ability to set a default color per log type
#### Bug Fixes
  * shellUtils: ensureRoot would output an error message but not return 1 as exit code
    * This has been fixed

### 1.2.0
### 17APR2023
#### Features
 * Updated Documentation
 * Added ShUnit for testing / code quality
 * Added Ability to load properties (properties.sh)
 * Add Feature to ensure User Exists
 * Add Function to create a user if they don't exist.
 * Added Defult option when asking for user input.

### 1.1.0
### 11NOV2021
#### Features
 * Added Shell Check
 * Added shellUtilis.sh
 * Updated Documentation
 
#### Bugs
### 1.0.0
#### Features
Initial release
#### Bugs

# Developer Setup
## Setup PGP Signature
1) Install GnuPG
    1. ``` shell
        sudo apt install gnupg
        ```
2) Generate a Key
    * ``` shell
      gpg --gen-key
      ```
3) get Key ID
    * ``` shell
      gpg --list-keys
      ```
4) Publish Key
    ``` shell
      gpg --keyserver keyserver.ubuntu.com --send-keys [Key_ID]
    ```
    * **Key_ID example**: 9ECA6B4E800185C352F771389E6573430496E4EC
## Release Artifact
1) Cut Release
    * ``` shell
       mvn release:prepare
       mvn release:perform
      ```

## Deployment Info
**Repository URL**: 'https://oss.sonatype.org/#welcome'

## Deploy Artifact to Maven Central
1) Log in to nexus at **https://s01.oss.sonatype.org/#welcome**
2) Go to **Stagin Repositoryies** on the left under __Build Promotion__
3) Select the repository there and click the **Close** button across the top.
4) Wait for the process to finish
   * This may take several minutes
   * When it is finished it will the status of the repository will be __closed__
5) Select the repository and click **Release** form the top menu
   * This May take some time.
6) Eventually the version should show up on **https://central.sonatype.com**

## Setup Local Settings
1) Need to add connection information to __~/.m2/settings.xml__
2) Add
    ``` xml
    <server>
      <id>ossrh</id>
      <username>UserName</username>
      <password>Password</password>
    </server>
    ```