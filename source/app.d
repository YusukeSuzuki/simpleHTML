import std.stdio;
import std.random;
import simpleHTML;

void main()
{
    auto doc = html.dup;
    doc.appendChild(a.appendChild(span.appendChild(br)));
    writeln(doc.dump());
}

