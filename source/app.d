import std.stdio;
import std.random;
import simpleHTML;

void main()
{
    auto doc = html.dup;
    doc <<= a( span(
        "this is html text".t,br,
        "multiline text.".t,br,
        "end".t ) );


    writeln(doc.dump());
}

