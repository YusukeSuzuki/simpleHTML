import std.stdio;
import std.random;
import simpleHTML;

void main()
{
    auto doc = html.dup;
    doc <<= a( span( br ) );


    writeln(doc.dump());
}

