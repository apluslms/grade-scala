ARG BASE_TAG=latest
FROM --platform=$TARGETPLATFORM apluslms/grade-java:$BASE_TAG

ARG SCALA_VER=3
ARG SCALA_FVER=3.3.0
ARG SCALA_URL=https://github.com/lampepfl/dotty/releases/download/$SCALA_FVER/scala3-$SCALA_FVER.tar.gz
ARG SCALA_DIR=/usr/local/scala
ENV SCALA_HOME=$SCALA_DIR/scala3-$SCALA_FVER

RUN mkdir -p $SCALA_HOME && cd $SCALA_HOME  \
 # Download scala scripts
 && curl -LSs $SCALA_URL -o - \
  | tar zx --strip-components=1 \
 # Remove Windows scripts
 && rm -f $SCALA_HOME/bin/*.bat \
 && ln -s $SCALA_HOME/bin/scala \
          $SCALA_HOME/bin/scalac \
          $SCALA_HOME/bin/scaladoc \
          /usr/local/bin \
 && :

# Override the "common" script in the Scala tar archive $SCALA_URL.
# Our version adds CLASSPATH to the -cp argument when the Java VM is started.
COPY lib/common $SCALA_HOME/bin

# Download libraries
RUN ivy_install -n "scala-library" -d "$SCALA_HOME/lib" \
    # These go to boot classpath
    # core
    org.scala-lang scala3-library_$SCALA_VER $SCALA_FVER \
    # compiler
    org.scala-lang scala3-compiler_$SCALA_VER $SCALA_FVER \
    org.scala-lang.modules scala-parser-combinators_$SCALA_VER [2.1.0,2.2[ \
 && ivy_install -n "grade-scala" -d "$SCALA_DIR/lib" \
    # These go to classpath
    # core libs are repeated, so the deps are resolved to same jars
    org.scala-lang scala3-library_$SCALA_VER $SCALA_FVER \
    org.scala-lang scala3-compiler_$SCALA_VER $SCALA_FVER \
    # extra libs
    org.scala-lang.modules scala-swing_$SCALA_VER [3.0.0,4.0[ \
    org.scalactic scalactic_$SCALA_VER [3.2.11,3.3[ \
    # for grading
    org.scalatest scalatest_$SCALA_VER [3.2.11,3.3[ "default->master,compile,runtime" \
    com.typesafe.akka akka-actor_$SCALA_VER [2.6.18,2.7[ \
 && :

# Add scala utilities
COPY bin /usr/local/bin

ENV CLASSPATH=.:/exercise:/exercise/*:/exercise/lib/*:$SCALA_DIR/lib/*:/usr/local/java/lib/*
