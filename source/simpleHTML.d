module simpleHTML;

import std.xml;

class Tag
{
    this(string name, string[string] attributes)
    {
        this.name = name;
        this.attributes = attributes;
    }

    this(string name)
    {
        this(name, null);
    }

    abstract string dump() const;

    string name;
    string[string] attributes;
}

class TagHasContents(string NAME) : Tag
{
    this()
    {
        super(NAME);
    }

    this(string[string] attributes)
    {
        super(NAME, attributes);
    }

    override string dump() const
    {
        string result = "<"~name;

        foreach(string aName, string aValue; attributes)
        {
            result ~= " "~aName~"=\""~aValue~"\"";
        }

        result ~= ">";

        foreach(const Tag child; children)
        {
            result ~= child.dump();
        }

        return result ~=  "</"~name~">";
    }

    typeof(this) appendChild(
        T : U!V, alias U : TagSingleton, V : Tag)(T t)
    {
        children ~= t.dup;
        return this;
    }

    typeof(this) appendChild(Tag t)
    {
        children ~= t;
        return this;
    }

    typeof(this) appendChild(Tag[] t)
    {
        children ~= t;
        return this;
    }

    Tag[] children;
}

class TagEmpty(string NAME) : Tag
{
    this()
    {
        super(NAME);
    }

    this(string[string] attributes)
    {
        super(NAME, attributes);
    }

    override string dump() const
    {
        string result = "<"~name;

        foreach(string aName, string aValue; attributes)
        {
            result ~= " "~aName~"=\""~aValue~"\"";
        }

        return result~" />";
    }
}

private class TagSingleton(T : Tag)
{
    T dup() const
    {
        return new T;
    }
}

@() alias HTML = TagHasContents!("html");
@() alias A = TagHasContents!("a");
@() alias BR = TagEmpty!("br");
@() alias IMG = TagEmpty!("img");

const auto html = new TagSingleton!(HTML);
const auto a = new TagSingleton!(A);
const auto br = new TagSingleton!(BR);
const auto img = new TagSingleton!(BR);

