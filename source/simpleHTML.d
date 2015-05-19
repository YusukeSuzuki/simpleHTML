module simpleHTML;

import std.xml;
import std.algorithm;
import std.string;

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

private class TagSingleton(T : TagHasContents!U, string U)
{
    T dup() const
    {
        return new T;
    }

    T appendChild(T2 : TagSingleton!U2, U2 : Tag)(const T2 t) const
    {
        return dup().appendChild(t.dup());
    }

    T appendChild(Tag t) const
    {
        return dup().appendChild(t);
    }
}

private class TagSingleton(T : TagEmpty!U, string U)
{
    T dup() const
    {
        return new T;
    }
}

private template GenTag(string NAME, bool HAS_CONTENTS)
{
    const char[] uName = NAME.toUpper;
    const char[] type = HAS_CONTENTS ? "TagHasContents" : "TagEmpty";
    const char[] GenTag =
        "alias "~uName~" = "~type~"!(\""~NAME~"\");\n"
        "const auto "~NAME~" = new TagSingleton!(" ~uName~ ");";
}

mixin(GenTag!("html", true));
mixin(GenTag!("a", true));
mixin(GenTag!("br", false));
mixin(GenTag!("img", false));
mixin(GenTag!("span", true));

