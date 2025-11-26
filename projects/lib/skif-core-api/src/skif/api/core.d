module skif.api.core;

public import skif.api.types : Version, Entity;

public interface IScene
{
}

public interface IProfile
{
}

public interface IProject
{
}

public interface IRegistry
{
    Entity create();

    ref ComponentT emplace(ComponentT)(Entity entity, ComponentT component);
    ref ComponentT get(ComponentT)(Entity entity);
}

public interface IProfileManager
{
}

public interface IProjectManager
{
}

public interface IContext
{
    Version get_version();
    IRegistry get_registry();
}
