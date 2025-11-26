import std.sumtype;

struct Config
{
    struct Help
    {
    }

    struct Dump
    {
        string project;
    }

    alias Mode = SumType!(Help, Dump);
    Mode mode;
}

interface ConfigParser
{
    Config parse(string[] args);
}

class ConfigParserGetopt : ConfigParser
{
    override Config parse(string[] args)
    {
        import std.stdio : writeln;

        writeln("Parse config from args: ", args[1 .. args.length]);

        return Config.init;
    }
}

struct Translation2d
{
    double x = 0.0;
    double y = 0.0;
}

string toString(const ref Translation2d t)
{
    import std.format : format;

    return format("Translation2d(x:%.2f, y:%.2f)", t.x, t.y);
}

void main(string[] args)
{
    import skif.core;
    import std.stdio : writeln;
    import std.format;

    scope opt_parser = new ConfigParserGetopt;

    auto config = opt_parser.parse(args);
    config.mode.match!(
        (Config.Help h) => writeln("Help mode selected"),
        (Config.Dump d) => writeln("dump project: ", d.project)
    );

    scope ctx = skif.core.make_context();
    auto version_ = ctx.get_version();

    writeln(format("Hello, skif v%d.%d.%d!", version_.major, version_.minor, version_.patch));

    auto reg = ctx.get_registry();
    auto entity = reg.create();
    auto transl2d = reg.emplace!Translation2d(entity, Translation2d(42, 21));

    writeln(format("%s added to entity %d", transl2d, entity));

    assert(reg.get!Translation2d(entity) == transl2d);
}
