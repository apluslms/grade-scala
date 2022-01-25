package example.unitTests

import example._

import org.scalatest._
import matchers.should._
import flatspec.AnyFlatSpec


trait MockOutput extends Output {
    var messages: Seq[String] = Seq()

    override def print(s: String) = messages = messages :+ s
}

class HelloTest extends AnyFlatSpec with Matchers {
    
    "Class Hello" should "correctly print 'Hello there!'" in {
        val hi = new Hello with MockOutput
        hi.hello()
        hi.messages should contain ("Hello there!")
    }
}

