# Grade-scala

Grading environment with specific Scala version in path.

This image extends [grade-java](https://github.com/apluslms/grade-java).

The base layer has Scala 3.3 and Java 11 installed.

Images are tagged with Scala and grading-base versions in the format `<scala>-<grading-base>`.
Version tag can also include `uN` meaning *update N* where N is an increasing number.
The update part is used to indicate updates to the image, where software versions did not change.
For an example, `3.1-4.2u1` includes Scala 3.1 on top of grading-base 4.2 and has one update after the first release.

There are additional versions of the image:

* `python-*` includes Python3


This image provides following convenience utilities.

* `scala-compile [-M] [-m ok_message] [files/dirs..]`

    Passes `files/dirs` to `move-to-package-dirs` and then executes `scalac` with all matched files.
    If `files/dirs` is empty (no argument), then all `*.scala` files in the working tree are moved and compiled.

    You can control classpath via `CLASSPATH` environment variable.
    You can define options for `scalac` using `SCALACFLAGS` environment variable.
    Default options are `-encoding utf-8 -deprecation -feature -language:postfixOps`.

    If compilation is successfull, then `ok_message` is printed.
    By default, it is `ok`, but it can be suppressed with `-M`.

* `scalatest [-r runner] [files..]`

    Executes scala using `runner` as the class and `files` as arguments.
    Default `runner` is `org.scalatest.tools.Runner`.
    For this runner, script passes arguments `-R . -eW` and for single argument `-s argument`.
    To search from module, use `-- -m module`.

* `run-all-scalatests [-C] [-p points_per_test_class]`

    Command to do it all.
    Can replace `run.sh` in trivial cases.

    First, script compiles all `*.scala` files from the current tree and /exercise, unless `-C` is provided.
    If compilation fails, then no tests are run.
    Second, script finds all files matching `*Test*.scala` pattern from the current tree.
    Then, it runs all files that contain string `org.scalatest.` using `testcase` and `scalatest`.
    Testcase will give `points_per_test_class` many points per successful execution of scalatest.
