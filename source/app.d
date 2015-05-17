import std.stdio;

import simpleHTML;

void main()
{
    auto doc = html.dup;
    doc.appendChild(a);
    writeln(doc.dump());
}

