module skif.core;
import skif.api.core;

public Context make_context()
{
    auto registry = new Registry();
    return new Context(registry);
}

package class ComponentPool(T)
{
    size_t emplace(T element)
    {
        data_ ~= element;
        return data_.length - 1;
    }

    bool erase(size_t id)
    {
        if (id >= data_.length)
            return false;

        deleted_ ~= id;
        return true;
    }

    T* at(size_t id)
    {
        import std.algorithm.searching : canFind;

        if (deleted_.canFind(id))
        {
            return null;
        }
        else
        {
            return &data_[id];
        }
    }

    private T[] data_;
    private size_t[] deleted_;
}

public class Registry : IRegistry
{
    Entity create()
    {
        size_t entity = next_id_++;
        entities_ ~= entity;
        return entity;
    }

    ref ComponentT emplace(ComponentT)(Entity entity, ComponentT component)
    {
        auto pool = getPool!ComponentT();
        size_t componentId = pool.emplace(component);
        entityToComponentId_[entity] = componentId;
        return *pool.at(componentId);
    }

    ref ComponentT get(ComponentT)(Entity entity)
    {
        assert(entity in entityToComponentId_, "Entity doesn't have component");
        auto pool = getPool!ComponentT();
        auto componentId = entityToComponentId_[entity];
        return *pool.at(componentId);
    }

private:

    ComponentPool!T getPool(T)()
    {
        auto tid = typeid(T);
        if (tid !in pools_)
            pools_[tid] = cast(void*)(new ComponentPool!T());
        return cast(ComponentPool!T) pools_[tid];
    }

    size_t next_id_ = 0;
    size_t[] entities_;
    size_t[Entity] entityToComponentId_;
    void*[TypeInfo] pools_;
}

package class Context : IContext
{
    this(Registry registry)
    {
        registry_ = registry;
    }

    override Version get_version()
    {
        return Version(0, 1, 0);
    }

    override Registry get_registry()
    {
        return registry_;
    }

    private Registry registry_;
}
