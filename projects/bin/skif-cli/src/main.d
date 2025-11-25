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
    Mode mode = Help.init;
}

interface ConfigParser
{
    Config parse(string[] args);
}

class ConfigParserGetopt : ConfigParser
{
    override Config parse(string[] args)
    {
        return Config.init;
    }
}

void main(string[] args)
{
    import skif.core;
    import std.stdio : writeln;
    import std.format;

    writeln(format("Hello, %s!", skif.core.get_library_name()));

    scope opt_parser = new ConfigParserGetopt;

    auto config = opt_parser.parse(args);
    config.mode.match!(
        (Config.Help h) => writeln("Help mode selected"),
        (Config.Dump d) => writeln("dump project: ", d.project)
    );
}
