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

    //abstract Tag dup() const;

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

    /*
    typeof(this) opBinary(string op)(Tag t)
        if(op == "<<")
    {
        return this;
    }
    */

    typeof(this) opOpAssign(string op)(Tag t)
        if(op == "<<")
    {
        return this.appendChild(t);
    }

    typeof(this) opOpAssign(string op)(Tag[] t)
        if(op == "<<")
    {
        return this.appendChild(t);
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

    T opCall(T2 : TagSingleton!U2, U2 : Tag)(const T2 t) const
    {
        return this.appendChild(t);
    }

    T opCall(Tag t) const
    {
        return this.appendChild(t);
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

// GenTag(NAME, HAS_CONTENTS)
mixin(GenTag!("a", true));
mixin(GenTag!("abbr", true));
mixin(GenTag!("address", true));
mixin(GenTag!("area", false));
mixin(GenTag!("article", true));
mixin(GenTag!("aside", true));
mixin(GenTag!("audio", true));
mixin(GenTag!("b", true));
mixin(GenTag!("base", false));
mixin(GenTag!("bdi", true));
mixin(GenTag!("bdo", true));
mixin(GenTag!("blockquote", true));
mixin(GenTag!("body_", true));
mixin(GenTag!("br", false));
mixin(GenTag!("button", true));
mixin(GenTag!("canvas", true));
mixin(GenTag!("caption", true));
mixin(GenTag!("cite", true));
mixin(GenTag!("code", true));
mixin(GenTag!("col", false));
mixin(GenTag!("colgroup", true));
mixin(GenTag!("data", true));
mixin(GenTag!("datalist", true));
mixin(GenTag!("dd", true));
mixin(GenTag!("del", true));
mixin(GenTag!("dfn", true));
mixin(GenTag!("div", true));
mixin(GenTag!("dl", true));
mixin(GenTag!("dt", true));
mixin(GenTag!("em", true));
mixin(GenTag!("embed", false));
mixin(GenTag!("fieldset", true));
mixin(GenTag!("figcaption", true));
mixin(GenTag!("figure", true));
mixin(GenTag!("footer", true));
mixin(GenTag!("form", true));
mixin(GenTag!("h1", true));
mixin(GenTag!("h2", true));
mixin(GenTag!("h3", true));
mixin(GenTag!("h4", true));
mixin(GenTag!("h5", true));
mixin(GenTag!("h6", true));
mixin(GenTag!("head", true));
mixin(GenTag!("header", true));
mixin(GenTag!("hr", false));
mixin(GenTag!("html", true));
mixin(GenTag!("i", true));
mixin(GenTag!("iframe", true));
mixin(GenTag!("img", false));
mixin(GenTag!("input", false));
mixin(GenTag!("ins", true));
mixin(GenTag!("kbd", true));
mixin(GenTag!("keygen", false));
mixin(GenTag!("label", true));
mixin(GenTag!("legend", true));
mixin(GenTag!("li", true));
mixin(GenTag!("link", false));
mixin(GenTag!("main", true));
mixin(GenTag!("map", true));
mixin(GenTag!("mark", true));
mixin(GenTag!("meta", false));
mixin(GenTag!("meter", true));
mixin(GenTag!("nav", true));
mixin(GenTag!("noscript", true));
mixin(GenTag!("object_", true));
mixin(GenTag!("ol", true));
mixin(GenTag!("optgroup", true));
mixin(GenTag!("option", true));
mixin(GenTag!("output", true));
mixin(GenTag!("p", true));
mixin(GenTag!("param", false));
mixin(GenTag!("pre", true));
mixin(GenTag!("progress", true));
mixin(GenTag!("q", true));
mixin(GenTag!("rb", true));
mixin(GenTag!("rp", true));
mixin(GenTag!("rt", true));
mixin(GenTag!("rtc", true));
mixin(GenTag!("ruby", true));
mixin(GenTag!("s", true));
mixin(GenTag!("samp", true));
mixin(GenTag!("script", true));
mixin(GenTag!("section", true));
mixin(GenTag!("select", true));
mixin(GenTag!("small", true));
mixin(GenTag!("source", false));
mixin(GenTag!("span", true));
mixin(GenTag!("strong", true));
mixin(GenTag!("style", true));
mixin(GenTag!("sub", true));
mixin(GenTag!("sup", true));
mixin(GenTag!("table", true));
mixin(GenTag!("tbody", true));
mixin(GenTag!("td", true));
mixin(GenTag!("template_", true));
mixin(GenTag!("textarea", true));
mixin(GenTag!("tfoot", true));
mixin(GenTag!("th", true));
mixin(GenTag!("thead", true));
mixin(GenTag!("time", true));
mixin(GenTag!("title", true));
mixin(GenTag!("tr", true));
mixin(GenTag!("track", false));
mixin(GenTag!("u", true));
mixin(GenTag!("ul", true));
mixin(GenTag!("var", true));
mixin(GenTag!("video", true));
mixin(GenTag!("wbr", false));



