# Kafka Scala API - Advanced Nagios Plugin / CLI Tool with Kerberos support

![](https://i.imgur.com/waxVImv.png)
### [View all Roadmaps](https://github.com/nholuongut/all-roadmaps) &nbsp;&middot;&nbsp; [Best Practices](https://github.com/nholuongut/all-roadmaps/blob/main/public/best-practices/) &nbsp;&middot;&nbsp; [Questions](https://www.linkedin.com/in/nholuong/)
<br/>

Kafka 0.9+ API CLI Tester & Advanced Nagios Plugin with Kerberos support, written in Scala.

Tested on Hortonworks HDP 2.4.0 with Kerberos + Ranger ACLs and Apache Kafka 0.8.x / 0.9.0.1 [docker images](https://hub.docker.com/r/nholuongut/kafka) with regular ACLs.

You may need to change the Kafka library version in `pom.xml` / `build.sbt` / `build.gradle` before building to match your deployed Kafka server / cluster otherwise it may hang when run due to version / protocol mismatch.
<!--
Testing shows it does take an extra second to negotiate the Kerberos authentication so make sure not to set ```--timeout``` to less than 2 secs if using Kerberos.
-->
See [The Advanced Nagios Plugins Collection](https://github.com/nholuongut/Nagios-Plugins#advanced-nagios-plugins-collection) for many more related enterprise monitoring programs.

## Intro

This project builds a single self-contained Java jar file with all dependencies included and can simply be run on the command line with full switch option support:

```shell
java -jar check_kafka.jar --help
```

and there is an optional convenience shell wrapper script at the top level to make commands shorter:

```shell
./check_kafka --help
```

Run against one or more Kafka brokers, comma separated:

```shell
$ ./check_kafka --brokers localhost:9092 --topic test
OK: Kafka broker successfully returned unique message via topic 'test' partition '0', write time = 0.185s, read time = 0.045s, total time = 1.729s | write_time=0.185s read_time=0.045s total_time=1.729s
```

Use the ```--verbose``` switch to also show the brokers list that were tested. If you have specified one of the kerberos switches (or edited the consumer/producer properties files to do so) then the output will additionally contain the marker ```with sasl authentication``` to let you know that it was a secure configuration that was tested (originally I called this ```with kerberos``` but technically it may not be in future).

```none
OK: Kafka broker '<hortonworks_host>:6667' successfully returned unique message via topic 'topic3' partition '0' with sasl authentication, write time = 0.148s, read time = 0.043s, total time = 0.691s | write_time=0.148s read_time=0.043s total_time=0.691s
```

### Kafka 0.9+ API Caveats

This program only supports Kafka 0.9+ as the API changed (again) and Kerberos security was only added in the 0.9 API. For Kafka versions before 0.9 you can find Python and Perl versions of this program in the [Advanced Nagios Plugins Collection](https://github.com/nholuongut/Nagios-Plugins#advanced-nagios-plugins-collection) that support 0.8 onwards (they dosn't support Kafka <= 0.7 as the API changed in 0.8 too and the underlying libraries in those languages don't support Kafka <= 0.7).

It appears that several errors are caught too early in the new Kafka Java API and result in embedded looping retry behaviour on encountering errors (visible in debug level logging of the base library).

I haven't found a great way of handle that behaviour as it's not exposed to the client code so it ends up being handled via my generic default self timeout mechanism that I apply to all my tools. Hence if you specify an incorrect ```--brokers <host>:<port>``` or the Kafka brokers are down or you fail to negotiate the protocol due to security settings you will only receive a generic ```UNKNOWN: self timed out after 10 secs``` message as the code self terminates.

Otherwise the Kafka API would just hang there indefintely as it keeps retrying deeper in the library. I've tried various settings to get it to time out but nothing worked and I even posted to the Kafka users mailing list without an answer. If you know of a setting that will make the Kafka Client library time out and return the more specific error then please let me know and I'll update this code accordingly.

#### Kerberos Support

See the ```conf/``` directory for JAAS kerberos configurations.

If you're running the code on a Hortonworks Kafka broker it'll auto-detect the HDP configuration and use that.

### Build

A Dockerized pre-built version is available on [DockerHub](https://hub.docker.com/r/nholuongut/nagios-plugin-kafka).

If you have docker installed this one command will download and run it:

```shell
docker run nholuongut/nagios-plugin-kafka check_kafka --help
```

#### Automated Build from Source

```shell
curl -L https://git.io/nagios-plugin-kafka-bootstrap | sh
```

OR

Maven, Gradle and SBT automated builds are all provided.

A self-contained jar file with all dependencies will be created and symlinked to ```check_kafka.jar``` at the top level.

The Maven and Gradle builds are best as they will auto bootstap and run with no prior installed dependencies other than Java and ```make``` to kick it off.

The default ```make``` build will trigger a Gradle bootstrap from scratch with an embedded checksum for security:

```shell
make
```

You can call any one of the 3 major build systems explicitly instead, which will recurse to build the library submodule using the same mechanism:

Maven:

```shell
make mvn
```

Gradle:

```shell
make gradle
```

SBT:

```shell
make sbt
```

#### Custom TLDs

If using bespoke internal domains such as `.local`, `.intranet`, `.vm`, `.cloud` etc. that aren't part of the official IANA TLD list then this is additionally supported via a custom configuration file [lib/resources/custom_tlds.txt](https://github.com/nholuongut/lib-java/blob/master/src/main/resources/tlds-alpha-by-domain.txt) containing one TLD per line, with support for # comment prefixes. Just add your bespoke internal TLD to the file and it will then pass the host/domain/fqdn validations.

#### Testing

[Continuous Integration](https://travis-ci.org/nholuongut/nagios-plugin-kafka) is run on this repo with tests for success and failure scenarios:

- unit tests for the custom supporting [java library](https://github.com/nholuongut/lib-java)
- integration tests of the top level programs using the libraries for things like option parsing
- [functional tests](https://github.com/nholuongut/nagios-plugin-kafka/tree/master/tests) for the top level programs using [Docker containers](https://hub.docker.com/u/nholuongut/)

To trigger all tests run:

```shell
make test
```

which will start with the underlying libraries, then move on to top level integration tests and functional tests using docker containers if docker is available.

### Kafka 0.8 support - Alternative Perl & Python Kafka API Nagios Plugins

The [Advanced Nagios Plugins Collection](https://github.com/nholuongut/Nagios-Plugins#advanced-nagios-plugins-collection) has both Perl and Python predecessors to this program which work with Kafka 0.8+. The main differenitator with this Scala version is that it uses the new native 0.9+ Java API which has Kerberos support (the dynamic language versions were built on libraries for Kafka 0.8).

[git.io/nagios-plugin-kafka](https://git.io/nagios-plugin-kafka)

## More Core Repos

<!-- OTHER_REPOS_START -->

### Knowledge

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Knowledge-Base&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Knowledge-Base)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Diagrams-as-Code&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Diagrams-as-Code)

<!--

Not support on GitHub Markdown:

<iframe src="https://raw.githubusercontent.com/nholuongut/nholuongut/main/knowledge.md" width="100%" height="500px"></iframe>

Does nothing:

<embed src="https://raw.githubusercontent.com/nholuongut/nholuongut/main/knowledge.md" width="100%" height="500px" />

-->

### DevOps Code

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=DevOps-Bash-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/DevOps-Bash-tools)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=DevOps-Python-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/DevOps-Python-tools)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=DevOps-Perl-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/DevOps-Perl-tools)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=DevOps-Golang-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/DevOps-Golang-tools)

<!--
[![Gist Card](https://github-readme-stats.vercel.app/api/gist?id=f8f551332440f1ca8897ff010e363e03)](https://gist.github.com/nholuongut/f8f551332440f1ca8897ff010e363e03)
-->

### Containerization

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Kubernetes-configs&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Kubernetes-configs)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Dockerfiles&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Dockerfiles)

### CI/CD

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=GitHub-Actions&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/GitHub-Actions)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Jenkins&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Jenkins)

### DBA - SQL

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=SQL-scripts&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/SQL-scripts)

### DevOps Reloaded

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Nagios-Plugins&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Nagios-Plugins)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=HAProxy-configs&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/HAProxy-configs)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Terraform&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Terraform)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Packer-templates&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Packer-templates)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Nagios-Plugin-Kafka&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/nagios-plugin-kafka)

### Templates

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Templates&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Templates)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Template-repo&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Template-repo)

### Misc

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Spotify-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Spotify-tools)
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nholuongut&repo=Spotify-playlists&theme=ambient_gradient&description_lines_count=3)](https://github.com/nholuongut/Spotify-playlists)

The rest of my original source repos are
[here](https://github.com/nholuongut?tab=repositories&q=&type=source&language=&sort=stargazers).

Pre-built Docker images are available on my [DockerHub](https://hub.docker.com/u/nholuongut/).

<!-- 1x1 pixel counter to record hits -->
![](https://hit.yhype.me/github/profile?user_id=2211051)

<!-- OTHER_REPOS_END -->
